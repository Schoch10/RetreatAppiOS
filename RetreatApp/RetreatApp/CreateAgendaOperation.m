//
//  CreateAgendaOperation.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/22/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "CreateAgendaOperation.h"
#import "CoreDataManager.h"
#import "Agenda+Extensions.h"
#import "ServiceCoordinator.h"

@implementation CreateAgendaOperation

- (instancetype)initAgendaWithType:(NSString *)agendaType {
    self = [super init];
    if (self) {
        self.agendaType = agendaType;
    }
    return self;
}

- (void)doWork {

    CoreDataManager *coreData = [CoreDataManager sharedManager];
    NSManagedObjectContext *context = coreData.operationContext;
    NSArray *titleArray = @[@"Arrive & Checkin", @"Cocktail Hour", @"Breakfast", @"Golf", @"Lawn Games", @"Zipline", @"Outdoor Activities", @"1920s Speakeasy", @"Breakfast", @"Checkout"];
    NSArray *locationArray = @[@"Omni Mt. Washington Lobby", @"Jewel Terrace", @"Main Dining Room", @"Omni Mt. Washington Golf Course", @"South Veranda Lawn", @"Omni Canopy Tours - Slopes", @"Check Activities Email", @"Presidential Foyer", @"Main Dining Room", @"Omni Mt. Washington Lobby"];
    NSArray *imagePathArray = @[@"checkin", @"cocktails", @"breakfast", @"golf", @"lawngames", @"zipline", @"outdoors", @"banquet", @"breakfast", @"checkout"];
    NSArray *dayArray = @[@"Friday", @"Friday", @"Saturday", @"Saturday", @"Saturday", @"Saturday", @"Saturday", @"Saturday", @"Sunday", @"Sunday"];
    NSArray *timeArray = @[@"4:00PM", @"6:00PM-10:00PM", @"7:00AM-10:00AM", @"9:00AM", @"10:00AM", @"11:00AM", @"All Day", @"6:00PM-10:00PM", @"7:00AM", @"11:00AM"];
    
    for (int i=0; i < titleArray.count; i++) {
        Agenda *agenda = [Agenda agendaUpsertWithAgendaID:@(i) inManagedObjectContext:context];
        agenda.title = [titleArray objectAtIndex:i];
        agenda.location = [locationArray objectAtIndex:i];
        agenda.day = [dayArray objectAtIndex:i];
        agenda.time = [timeArray objectAtIndex:i];
        agenda.type = [imagePathArray objectAtIndex:i];
    }
    [coreData saveContext:context];
    [[ServiceCoordinator sharedCoordinator] completeLocalOperation:self];
}

@end
