//
//  CoreDataManager.m
//
//  Created by Jon Allegre on 2/13/13.
//  Copyright (c) 2013 Slalom, LLC. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"
#import "SCFileUtil.h"
#import "SlalomCommon.h"

#define kDatabaseFilename @"MindTap.sqlite"
#define kDatabaseFilenameWriteAheadLog kDatabaseFilename @"-wal"
#define kDatabaseFilenameSharedMemory kDatabaseFilename @"-shm"

@interface CoreDataManager()

@end

@implementation CoreDataManager

//CORE DATA
@synthesize mainThreadManagedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize backgroundOperationPersistentStoreCoordinator = __backgroundOperationPersistentStoreCoordinator;

+ (CoreDataManager *)sharedManager
{
    static CoreDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)resetAccessObjects
{
    SCLogMessage(kLogLevelDebug, @"reset");
    [self unregisterNotifications];
    __managedObjectContext = nil;
    __managedObjectModel = nil;
    __persistentStoreCoordinator = nil;
    __backgroundOperationPersistentStoreCoordinator = nil;
}

- (void)clearStores
{
    NSString *sqliteFilePath = [SCFileUtil documentPath:kDatabaseFilename];
    [[NSFileManager defaultManager] removeItemAtPath:sqliteFilePath error:nil];
    
    NSString *shmFilePath = [SCFileUtil documentPath:kDatabaseFilenameSharedMemory];
    [[NSFileManager defaultManager] removeItemAtPath:shmFilePath error:nil];
    
    NSString *walFilePath = [SCFileUtil documentPath:kDatabaseFilenameWriteAheadLog];
    [[NSFileManager defaultManager] removeItemAtPath:walFilePath error:nil];
}

//This method makes sure that the stores and contexts are created on the correct threads the first time.
- (void)setUpManagedObjects
{
    [self performSelectorOnMainThread:@selector(mainThreadManagedObjectContext) withObject:nil waitUntilDone:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self operationContext];
    });
}

- (void)unregisterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:nil];
}

/* Create a mapping of object ids for the given entity and unique key */
- (NSMutableDictionary *)objectUriMap:(NSString *)entityName keyName:(NSString *)keyName context:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    request.includesSubentities = NO;
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    
    for (NSManagedObject *result in results)
    {
        [map setObject:result.objectID.URIRepresentation forKey:[result valueForKeyPath:keyName]];
    }
    
    return map;
}

//This is adapted from:
//http://www.cocoawithlove.com/2008/08/safely-fetching-nsmanagedobject-by-uri.html
- (NSManagedObject *)objectWithURI:(NSURL *)uri context:(NSManagedObjectContext*)context allowFault:(BOOL)allowFault
{
    NSManagedObjectID *objectID = [[self persistentStoreCoordinator] managedObjectIDForURIRepresentation:uri];
    
    if (!objectID)
    {
        return nil;
    }
    
    NSManagedObject *objectForID = [context objectWithID:objectID];
    
    if(allowFault && objectForID)
    {
        return objectForID;
    }
    else
    {
        if ([objectForID isFault])
        {
            objectForID = [context existingObjectWithID:objectID error:nil];
        }
        
        if(!objectForID)
        {
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[objectID entity]];
            
            NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForEvaluatedObject]
                                                                        rightExpression:[NSExpression expressionForConstantValue:objectID]
                                                                               modifier:NSDirectPredicateModifier
                                                                                   type:NSEqualToPredicateOperatorType
                                                                                options:0];
            [request setPredicate:predicate];
            request.fetchBatchSize = 1;
            request.fetchLimit = 1;
            
            NSError *error = nil;
            NSArray *results = [context executeFetchRequest:request error:&error];
            
            if(error)
            {
                SCLogMessage(kLogLevelDebug, @"CoreData Error: %@", error.description);
            }
            
            objectForID = [results lastObject];
        }
    }
    
    return objectForID;
}

- (NSManagedObject *)objectWithURI:(NSURL *)uri context:(NSManagedObjectContext*)context
{
    return [self objectWithURI:uri context:context allowFault:NO];
}

#pragma mark - Core Data
- (void)mergeChangesOnMainThread:(NSNotification *)notification
{
    NSManagedObjectContext *context = (NSManagedObjectContext *)notification.object;
    
    // Only interested in merging from operation into main.
    if (context == self.mainThreadManagedObjectContext)
    {
        SCLogMessage(kLogLevelWarn, @"Trying to merge with changes saved on mainthread. This is not allowed. Changes should not be saved on the mainthread! If your code is trying to save on the mainThreadManagedObjectContext, then you are doing it wrong. #SnarkyApplesqueErrorMessage");
        return;
    }
    else
    {
        [self.mainThreadManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    }
}

- (void)contextDidSave:(NSNotification *)notification
{
    [self performSelectorOnMainThread:@selector(mergeChangesOnMainThread:) withObject:notification waitUntilDone:YES];
}

- (BOOL)saveContext:(NSManagedObjectContext *)operationContext
{
    if([operationContext isEqual:self.mainThreadManagedObjectContext])
    {
        SCLogMessage(kLogLevelError, @"The App should NOT save the mainThreadManagedObjectContext! If your code is trying to save on the mainThreadManagedObjectContext, then you are doing it wrong. #SnarkyApplesqueErrorMessage");
        
        @throw [NSException exceptionWithName:@"saveContextError" reason:@"You cannot save the mainThreadManagedObjectContext. It is readonly." userInfo:nil];
    }
    
    __block BOOL retVal = NO;
    
    if (operationContext != nil)
    {
        [operationContext performBlockAndWait:^{
            NSError *error = nil;
            @try {
                if ([operationContext hasChanges] && ![operationContext save:&error])
                {
                    /*
                     Replace this implementation with code to handle the error appropriately.
                     
                     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                     */
//                    [LogEventOperation queueWithEventType:EventTypeError className:SCClassName methodName:SCMethodName errorCode:error.code errorDescription:error.description stackTrace:SCCallStack requestUrl:nil response:nil];
                    
                    SCLogMessage(kLogLevelError, @"OPERATION THREAD CONTEXT: Unresolved error %@, %@", error, [error userInfo]);
                    
                    // If Cocoa generated the error...
                    if ([[error domain] isEqualToString:@"NSCocoaErrorDomain"]) {
                        // ...check whether there's an NSDetailedErrors array
                        NSDictionary *userInfo = [error userInfo];
                        if ([userInfo valueForKey:@"NSDetailedErrors"] != nil) {
                            // ...and loop through the array, if so.
                            NSArray *errors = [userInfo valueForKey:@"NSDetailedErrors"];
                            for (NSError *anError in errors) {
                                
                                NSDictionary *subUserInfo = [anError userInfo];
                                subUserInfo = [anError userInfo];
                                // Granted, this indents the NSValidation keys rather a lot
                                // ...but it's a small loss to keep the code more readable.
                                SCLogMessage(kLogLevelError, "Core Data Save Error\n\n \
                                             NSValidationErrorKey\n%@\n\n \
                                             NSValidationErrorPredicate\n%@\n\n \
                                             NSValidationErrorObject\n%@\n\n \
                                             NSLocalizedDescription\n%@",
                                             [subUserInfo valueForKey:@"NSValidationErrorKey"],
                                             [subUserInfo valueForKey:@"NSValidationErrorPredicate"],
                                             [subUserInfo valueForKey:@"NSValidationErrorObject"],
                                             [subUserInfo valueForKey:@"NSLocalizedDescription"]);
                            }
                        }
                        // If there was no NSDetailedErrors array, print values directly
                        // from the top-level userInfo object. (Hint: all of these keys
                        // will have null values when you've got multiple errors sitting
                        // behind the NSDetailedErrors key.
                        else {
                            SCLogMessage(kLogLevelError, @"Core Data Save Error\n\n \
                                         NSValidationErrorKey\n%@\n\n \
                                         NSValidationErrorPredicate\n%@\n\n \
                                         NSValidationErrorObject\n%@\n\n \
                                         NSLocalizedDescription\n%@",
                                         [userInfo valueForKey:@"NSValidationErrorKey"],
                                         [userInfo valueForKey:@"NSValidationErrorPredicate"],
                                         [userInfo valueForKey:@"NSValidationErrorObject"],
                                         [userInfo valueForKey:@"NSLocalizedDescription"]);
                        }
                    }
                    // Handle mine--or 3rd party-generated--errors
                    else {
                        SCLogMessage(kLogLevelError, @"Custom Error: %@", [error localizedDescription]);
                    }
                    
#if DEBUG
                    abort();
#endif
                }
                else
                {
                    retVal = YES;
                }
            }
            @catch (NSException *exception)
            {
                SCLogMessage(kLogLevelError, @"%@", exception.debugDescription);
            }
        }];
    }
    
    return retVal;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)operationContextWithMergePolicy:(id)mergePolicy
{
    NSManagedObjectContext *opContext = nil;
    
    NSPersistentStoreCoordinator *coordinator = [self backgroundOperationPersistentStoreCoordinator];
    if (coordinator != nil)
    {
        opContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [opContext setPersistentStoreCoordinator:coordinator];
        [opContext setUndoManager:nil];
        [opContext setMergePolicy:mergePolicy];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:opContext];
    }
    
    return opContext;
}

- (NSManagedObjectContext *)operationContext
{
    //Make sure the mainthread context exists
    return [self operationContextWithMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
}


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)mainThreadManagedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    [__managedObjectContext setStalenessInterval:0.0]; //0.0 represents “no staleness acceptable”.
    [__managedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RetreatApp" withExtension:@"momd"];
    
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorFactory
{
    NSPersistentStoreCoordinator *storeCoordinator;
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kDatabaseFilename];
    SCLogMessage(kLogLevelDebug, @"CoreData storeURL: %@", storeURL);
    
    NSError *error = nil;
    storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                              NSInferMappingModelAutomaticallyOption: @YES,
                              NSSQLitePragmasOption: @{@"journal_mode":
#if DEBUG
                                                       @"DELETE" // enable sqlite browsing in DEBUG builds
#else
                                                       @"WAL" // enable fast write-ahead log in PROD builds
#endif
                                                       }}; //When upgrading: http://openradar.appspot.com/13982460
    
    if (![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        SCLogMessage(kLogLevelError, @"Unresolved error %@, %@", error, [error userInfo]);
        
        NSError *fileError;
        if (![[NSFileManager defaultManager] removeItemAtURL:storeURL error:&fileError])
        {
            SCLogMessage(kLogLevelError, @"Unresolved File Delete error %@, %@", fileError, [fileError userInfo]);
            
//            [LogEventOperation queueWithEventType:EventTypeFatal className:SCClassName methodName:SCMethodName errorCode:fileError.code errorDescription:fileError.description stackTrace:SCCallStack requestUrl:nil response:nil];
            
            abort();
        }
        
        if (![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
        {
            SCLogMessage(kLogLevelError, @"Unresolved error %@, %@", error, [error userInfo]);
            
//            [LogEventOperation queueWithEventType:EventTypeFatal className:SCClassName methodName:SCMethodName errorCode:error.code errorDescription:error.description stackTrace:SCCallStack requestUrl:nil response:nil];
            
            abort();
        }
    }
    else
    {
#if !DEBUG
        if (![SCFileUtil addSkipBackupAttributeToItemAtURL:storeURL])
        {
            SCLogMessage(kLogLevelError, @"Unable to add the iCloud Skip Backup Attribute to the sqlite file.");
        }
        
        NSString *shmFilePath = [SCFileUtil documentPath:kDatabaseFilenameSharedMemory];
        if (![SCFileUtil addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:shmFilePath]])
        {
            SCLogMessage(kLogLevelError, @"Unable to add the iCloud Skip Backup Attribute to the sqlite-shm file.");
        }
        
        NSString *walFilePath = [SCFileUtil documentPath:kDatabaseFilenameWriteAheadLog];
        if (![SCFileUtil addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:walFilePath]])
        {
            SCLogMessage(kLogLevelError, @"Unable to add the iCloud Skip Backup Attribute to the sqlite-wal file.");
        }
#endif
    }
    
    return storeCoordinator;
}

- (NSPersistentStoreCoordinator *)backgroundOperationPersistentStoreCoordinator
{
    if (__backgroundOperationPersistentStoreCoordinator != nil)
    {
        return __backgroundOperationPersistentStoreCoordinator;
    }
    
    __backgroundOperationPersistentStoreCoordinator = [self persistentStoreCoordinatorFactory];
    
    return __backgroundOperationPersistentStoreCoordinator;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    __persistentStoreCoordinator = [self persistentStoreCoordinatorFactory];
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
