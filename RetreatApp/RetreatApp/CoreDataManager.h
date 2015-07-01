//
//  CoreDataManager.h
//
//  Created by Jon Allegre on 2/13/13.
//  Copyright (c) 2013 Slalom, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface CoreDataManager : NSObject

+ (CoreDataManager *) sharedManager;

// CORE DATA
@property (nonatomic, retain, readonly) NSManagedObjectContext *mainThreadManagedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *backgroundOperationPersistentStoreCoordinator;

- (void)setUpManagedObjects;
- (void)clearStores;
- (void)resetAccessObjects;
- (BOOL)saveContext:(NSManagedObjectContext *)operationContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSManagedObjectContext *)operationContextWithMergePolicy:(id)mergePolicy;
- (NSManagedObjectContext *)operationContext;
- (void)unregisterNotifications;
- (NSMutableDictionary *)objectUriMap:(NSString *)entityName keyName:(NSString *)keyName context:(NSManagedObjectContext *)context;
- (NSManagedObject *)objectWithURI:(NSURL *)uri context:(NSManagedObjectContext*)context;


@end
