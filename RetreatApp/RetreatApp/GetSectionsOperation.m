//
//  GetSectionsOperation.m
//  mindtap
//
//  Created by Rod Smith on 2014/10/14.
//  Copyright (c) 2014 Slalom, LLC. All rights reserved.
//

#import "GetSectionsOperation.h"
#import "ServiceCoordinator.h"
#import "CoreDataManager.h"
#import "SettingsManager.h"





@implementation GetSectionsOperation

/*
- (id)initForUserId:(NSNumber*)userId
{
    if(self = [super initWithMethod:RESTMethodGet
                       forEndpoint:@"Sections"
                        withParams:@{@"userId": userId}])
    {
        self.delegate = self;
    }
    return self;
}

- (BOOL)useCachedDataIfAvailable
{
    SettingsManager *settings = [SettingsManager sharedManager];
    NSNumber *userId = settings.userId;
    if (!userId) {
        SCLogMessage(kLogLevelWarn, @"not logged in.");
        return NO;
    }
    NSManagedObjectContext *context = [CoreDataManager sharedManager].mainThreadManagedObjectContext;
   
    
    User *user = [User userWithUserId:userId inContext:context];
    NSMutableArray *sectionIds = [[NSMutableArray alloc] initWithCapacity:user.sections.count];
    for (Section *section in user.sectionsDownloaded) {
        [sectionIds addObject:section.sectionId];
    }
     
     
    if (sectionIds.count > 0) {
        [self.getSectionsOperationDelegate getSectionsOperationDidGetSectionIds:sectionIds fromCache:YES finished:!self.shouldDownloadFromNetwork];
        return YES;
    } else {
        return NO;
    }
     
}

- (BOOL)shouldDownloadFromNetwork
{
    SettingsManager *settings = [SettingsManager sharedManager];
    return [settings shouldDownloadSections];
}

- (void)completeFromCacheWithNoData
{
    [self.getSectionsOperationDelegate getSectionsOperationDidFailWithError:
     [NSError errorWithDomain:kMindtapErrorDomain code:ErrorCodeNoData userInfo:nil]];
}

-(void)serviceTaskDidReceiveResponseJSON:(id)responseJSON
{
    SettingsManager *settings = [SettingsManager sharedManager];
    NSNumber *userId = settings.userId;
    if (!userId) {
        SCLogMessage(kLogLevelWarn, @"not logged in");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.getSectionsOperationDelegate getSectionsOperationDidFailWithError:
             [NSError errorWithDomain:kMindtapErrorDomain code:ErrorCodeUnauthorized userInfo:nil]];
        });
        return;
    }
    CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
    NSManagedObjectContext *managedObjectContext = [coreDataManager operationContext];
    NSMutableArray *sectionIds = [[NSMutableArray alloc] init];
    User *user = [User userWithUserId:userId inContext:managedObjectContext];
    if (!user) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [NSError errorWithDomain:kMindtapErrorDomain code:ErrorCodeUnauthorized userInfo:@{@"userId":userId}];
            [self.getSectionsOperationDelegate getSectionsOperationDidFailWithError:error];
        });
        return;
    }
    NSSet *previouslyCachedSections = [NSSet setWithSet:user.sectionsDownloaded];
    for (id sectionJSON in responseJSON) {
        if (![sectionJSON isKindOfClass:[NSDictionary class]]) {
            SCLogMessage(kLogLevelError, @"unexpected type for section: %@", sectionJSON);
            continue;
        }
        NSDictionary *sectionDictionary = sectionJSON;
        Section *section = [self upsertSection:sectionDictionary userId:userId inContext:managedObjectContext];
        if (section) {
            [sectionIds addObject:section.sectionId];
        }
    }
    if (sectionIds.count > 0) {
        for (Section *cachedSection in previouslyCachedSections) {
            if (![sectionIds containsObject:cachedSection.sectionId]) {
                [managedObjectContext deleteObject:cachedSection];
            }
        }
    }
    BOOL saved = [coreDataManager saveContext:managedObjectContext];
    if (saved && sectionIds.count > 0) {
        settings.sectionsLastDownloaded = [NSDate date];
    } else {
        SCLogMessage(kLogLevelError, @"failed to save downloaded sections");
    }
    if (self.getSectionsOperationDelegate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (saved) {
                if (sectionIds.count > 0) {
                    [self.getSectionsOperationDelegate getSectionsOperationDidGetSectionIds:sectionIds fromCache:NO finished:YES];
                } else {
                    [self.getSectionsOperationDelegate getSectionsOperationDidFailWithError:
                     [NSError errorWithDomain:kServiceErrorDomain code:ErrorCodeNoData userInfo:@{@"url":self.url}]];
                }
            } else {
                NSError *error = [NSError errorWithDomain:kCoreDataErrorDomain code:ErrorCodeCoreDataFailedSave userInfo:@{@"entity":@"Section"}];
                [self.getSectionsOperationDelegate getSectionsOperationDidFailWithError:error];
            }
        });
    }
}

- (Section*)upsertSection:(NSDictionary *)sectionDictionary userId:(NSNumber*)userId inContext:(NSManagedObjectContext*)context
{
    id sectionIdJSON = sectionDictionary[@"id"];
    if (![sectionIdJSON isKindOfClass:[NSNumber class]]) {
        SCLogMessage(kLogLevelError, @"unexpected type for section id: %@", sectionDictionary);
        return nil;
    }
    NSNumber *sectionId = sectionIdJSON;
    Section *section = [Section sectionForUpsertWithSectionId:sectionId forUserId:userId inContext:context];
    id nameJSON = sectionDictionary[@"name"];
    if ([nameJSON isKindOfClass:[NSString class]]) {
        if (![section.name isEqualToString:nameJSON]) {
            section.name = nameJSON;
        }
    } else if (nameJSON) {
        SCLogMessage(kLogLevelError, @"unexpected type for name: %@", sectionDictionary);
    }
    id titleJSON = sectionDictionary[@"title"];
    if ([titleJSON isKindOfClass:[NSString class]]) {
        if (![section.title isEqualToString:titleJSON]) {
            section.title = titleJSON;
        }
    } else {
        SCLogMessage(kLogLevelError, @"unexpected type for title: %@", sectionDictionary);
    }
    id instructorsJSON = sectionDictionary[@"instructors"];
      
    if ([instructorsJSON isKindOfClass:[NSArray class]]) {
        NSArray *instructors = instructorsJSON;
            for (id item in instructors) {
                NSString *firstName;
                id firstNameJSON = item[@"firstName"];
                if ([firstNameJSON isKindOfClass:[NSString class]]) {
                    firstName = item[@"firstName"];
                } else {
                    SCLogMessage(kLogLevelError, @"unexpected type for instructor firstName: %@", item);
                    continue;
                }
                NSString *lastName;
                id lastNameJSON = item[@"lastName"];
                if ([lastNameJSON isKindOfClass:[NSString class]]) {
                    lastName = item[@"lastName"];
                } else {
                    SCLogMessage(kLogLevelError, @"unexpected type for instructor lastName: %@", item);
                    continue;
                }

                Instructor *instructor = [Instructor instructorForUpsertWithFirstName:firstName lastName:lastName inContext:context];
                
                if (instructor) {
                    BOOL sectionHasInstructor = NO;
                    for (Instructor *i in section.instructors) {
                        if ([i.instructorID isEqualToNumber:instructor.instructorID]) {
                            sectionHasInstructor = YES;
                            break;
                        }
                    }
                    if (sectionHasInstructor) {
                        SCLogMessage(kLogLevelDebug, @"skipping duplicate instructor");
                    } else {
                        [section addInstructorsObject:instructor];
                    }
                } else {
                    SCLogMessage(kLogLevelError, @"failed to upsert instructor from item %@", item);
                }
            }
    } else {
        SCLogMessage(kLogLevelWarn, @"section has no instructor(s): %@", sectionDictionary);
    }
    id timeJSON = sectionDictionary[@"time"];
    if ([timeJSON isKindOfClass:[NSString class]]) {
        if (![section.sectionTime isEqualToString:timeJSON]) {
            section.sectionTime = timeJSON;
        }
    } else if (section.sectionTime) {
        SCLogMessage(kLogLevelError, @"unexpected type for section time: %@", sectionDictionary);
    } else {
        SCLogMessage(kLogLevelWarn, @"missing section time: %@", sectionDictionary);
    }
    id timeZoneJSON = sectionDictionary[@"timeZone"];
    if ([timeZoneJSON isKindOfClass:[NSString class]]) {
        if (![section.timeZone isEqualToString:timeZoneJSON]) {
            section.timeZone = timeZoneJSON;
        }
    } else {
        SCLogMessage(kLogLevelError, @"unexpected type for timeZone: %@", sectionDictionary);
    }
    id startDateJSON = sectionDictionary[@"startUtcDateTimeInMillis"];
    if ([startDateJSON isKindOfClass:[NSNumber class]]) {
        NSNumber *startEpochNumber  = startDateJSON;
        NSTimeInterval startEpochTimeInterval = startEpochNumber.longLongValue / 1000;
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startEpochTimeInterval];
        if (![section.startDate isEqualToDate:startDate]) {
            section.startDate = startDate;
        }
    } else if (startDateJSON) {
        SCLogMessage(kLogLevelError, @"unexpected type for startDate: %@", sectionDictionary);
    } else {
        SCLogMessage(kLogLevelDebug, @"missing start date");
    }
    id endDateJSON = sectionDictionary[@"endUtcDateTimeInMillis"];
    if ([endDateJSON isKindOfClass:[NSNumber class]]) {
        NSNumber *endEpochNumber = endDateJSON;
        NSTimeInterval endEpochInterval = endEpochNumber.longLongValue / 1000;
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endEpochInterval];
        if (![section.endDate isEqualToDate:endDate]) {
            section.endDate = endDate;
        }
    } else if (endDateJSON) {
        SCLogMessage(kLogLevelError, @"unexpected type for endDate: %@", sectionDictionary);
    }
    id booksJSON = sectionDictionary[@"books"];
    if ([booksJSON isKindOfClass:[NSArray class]]) {
        NSArray *booksArray = booksJSON;
        SCLogMessage(kLogLevelDebug, @"books count %lu", (unsigned long)booksArray.count);
        for (id bookJSON in booksArray) {
            if ([bookJSON isKindOfClass:[NSDictionary class]]) {
                NSDictionary *bookDictionary = bookJSON;
                [self upsertBook:bookDictionary section:section];
            } else {
                SCLogMessage(kLogLevelError, @"Unexpected type in books JSON: %@", bookJSON);
            }
        }
    } else {
        SCLogMessage(kLogLevelError, @"Unexpected type for books JSON: %@", booksJSON);
    }
    return section;
}


- (void)upsertBook:(NSDictionary *)bookDictionary section:(Section*)section
{
    NSManagedObjectContext *context = section.managedObjectContext;
    id isbnJSON = bookDictionary[@"isbn"];
    if (![isbnJSON isKindOfClass:[NSString class]]) {
        SCLogMessage(kLogLevelWarn, @"unexpected type for isbn: %@", bookDictionary);
        return;
    }
    NSString *isbn = (NSString*)isbnJSON;
    Book *book = [Book bookForUpsertWithIsbn:isbn inContext:context];
    if (![book.sections containsObject:section]) {
        [book addSectionsObject:section];
    }
    id titleJSON = bookDictionary[@"title"];
    if ([titleJSON isKindOfClass:[NSString class]]) {
        book.title = titleJSON;
    } else {
        SCLogMessage(kLogLevelError, @"unexpected tyep for book title: %@", bookDictionary);
    }
    id authorJSON = bookDictionary[@"author"];
    if ([authorJSON isKindOfClass:[NSString class]]) {
        book.author = authorJSON;
    } else {
        SCLogMessage(kLogLevelError, @"unexpected type for book author: %@", bookDictionary);
    }
    id imagesJSON = bookDictionary[@"images"];
    if ([imagesJSON isKindOfClass:[NSArray class]]) {
        NSArray *images = imagesJSON;
        for (id imageJSON in images) {
            if ([imageJSON isKindOfClass:[NSDictionary class]]) {
                [self upsertImage:(NSDictionary*)imageJSON forBook:book];
            } else {
                SCLogMessage(kLogLevelError, @"Unexpected type for book image: %@", imageJSON);
            }
        }
    }
}


- (void)upsertImage:(NSDictionary*)imageDict forBook:(Book*)book
{
    NSString *imageId;
    id imageIdJSON = imageDict[@"id"];
    if ([imageIdJSON isKindOfClass:[NSString class]]) {
        imageId = imageIdJSON;
    } else {
        SCLogMessage(kLogLevelError, @"unexpected type for image id: %@", imageIdJSON);
        return;
    }
    Image *image = [Image imageForUpsertWithId:imageId forBook:book];
    id contentTypeJSON = imageDict[@"contentType"];
    if ([contentTypeJSON isKindOfClass:[NSString class]]) {
        image.contentType = contentTypeJSON;
    } else {
        SCLogMessage(kLogLevelError, @"unexpected JSON type for contentType: %@", contentTypeJSON);
    }
    id sizeJSON = imageDict[@"size"];
    if ([sizeJSON isKindOfClass:[NSString class]]) {
        image.size = sizeJSON;
    } else {
        SCLogMessage(kLogLevelError, @"unexpected JSON type for size: %@", sizeJSON);
    }
    id subjectJSON = imageDict[@"subject"];
    if ([subjectJSON isKindOfClass:[NSString class]]) {
        image.subject = subjectJSON;
    } else {
        SCLogMessage(kLogLevelError, @"unexpected JSON type for subject: %@", subjectJSON);
    }
}
*/

-(void)serviceTaskDidReceiveStatusFailure:(HttpStatusCode)httpStatusCode
{
    SCLogMessage(kLogLevelError, @"Failed status code %li", (long)httpStatusCode);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = [self errorForHttpStatusCode:httpStatusCode];
        [self.getSectionsOperationDelegate getSectionsOperationDidFailWithError:error];
    });
}

-(void)serviceTaskDidFailToCompleteRequest:(NSError *)error
{
    SCLogMessage(kLogLevelError, @"Failed to GET sections error: %@", error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.getSectionsOperationDelegate getSectionsOperationDidFailWithError:error];
    });
}

- (NSUInteger)hash
{
    return [GetSectionsOperation hash];
}

- (BOOL)isEqual:(id)object
{
    return [object isKindOfClass:[GetSectionsOperation class]];
}

@end
