//
//  CheckinOperation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 8/7/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "CheckinOperation.h"
#import "CoreDataManager.h"

@implementation CheckinOperation

- (id)initCheckinOperationWithLocation:(NSNumber *)locationId {
    
    if(self = [super initWithMethod:RESTMethodPost
                        forEndpoint:@"checkin"
                         withParams:@{@"userId": @"1", @"locationId": [locationId stringValue]}])
    {
        self.delegate = self;
        self.locationId = locationId;
    }
    
    return self;
}

#pragma mark - MTServiceOperationDelegate Methods

-(void)serviceTaskDidReceiveResponseJSON:(id)responseJSON
{
    SCLogMessage(kLogLevelDebug, @"responseJSON %@", responseJSON);
  /*  CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
    NSManagedObjectContext *managedObjectContext = [coreDataManager operationContext];
    //Data Return
    //NSMutableArray *flashcardIds = [[NSMutableArray alloc] init];
    //Setup Core Data Model Access
    
    for (NSDictionary *pollDictionary in responseJSON) {
        
        id userIdJSON = pollDictionary[@"UserId"];
        id userNameJSON = pollDictionary[@"UserName"];
        id userLocationIdJSON = pollDictionary[@"LocationId"];
        id userLocationName = pollDictionary[@"LocationName"];
        SCLogMessage(kLogLevelDebug, @"user id %@", userIdJSON);
        SCLogMessage(kLogLevelDebug, @"user name %@", userNameJSON);
        SCLogMessage(kLogLevelDebug, @"user Location Id %@", userLocationIdJSON);
        SCLogMessage(kLogLevelDebug, @"user location name %@", userLocationName);
        /*  [flashcardIds addObject:flashcardId];
         Flashcard *flashcard = [Flashcard flashcardForUpsertWithCardId:flashcardId forDeck:deck inContext:managedObjectContext];
         id frontContentJSON = flashcardDictionary[@"frontContent"];
         if ([frontContentJSON isKindOfClass:[NSString class]]) {
         if (![flashcard.frontContent isEqualToString:frontContentJSON]) {
         flashcard.frontContent = frontContentJSON;
         }
         } else {
         SCLog
         Message(kLogLevelError, @"unexpected type for frontContent: %@", flashcardDictionary);
         }
    }
    BOOL saved = [coreDataManager saveContext:managedObjectContext];
    if (saved) {
        SCLogMessage(kLogLevelDebug, @"Saved");
    } else {
        SCLogMessage(kLogLevelError, @"No Locations Saved");
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (saved) {
            [self.pollParticipantDelegate pollParticipantLocationDidSucceed];
        } else {
            NSError *error = [NSError errorWithDomain:kCoreDataErrorDomain code:ErrorCodeCoreDataFailedSave userInfo:nil];
            [self.pollParticipantDelegate pollParticipantLocationDidFailWithError:error];
        }
    }); */
    
}

@end
