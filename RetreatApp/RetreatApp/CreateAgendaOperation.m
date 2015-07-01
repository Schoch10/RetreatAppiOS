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
    NSArray *titleArray = @[@"Arrive & Checkin", @"Cocktail Hour", @"Breakfast", @"Activities Freetime", @"20s Gala", @"Breakfast", @"Checkout"];
    NSArray *locationArray = @[@"Mt. Omni Lobby", @"Mt. Omni Pool", @"Mt. Omni Restaurant", @"Check Activities Schedule", @"Mt. Omni Ballroom", @"Mt. Omni Restaurant", @"Mt. Omni Lobby"];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *friday = [[NSDateComponents alloc] init];
    [friday setDay:28];
    [friday setMonth:8];
    [friday setYear:2015];
    NSDate *fridayDate = [calendar dateFromComponents:friday];
    NSDateComponents *saturday = [[NSDateComponents alloc] init];
    [saturday setDay:29];
    [saturday setMonth:8];
    [saturday setYear:2015];
    NSDate *saturdayDate = [calendar dateFromComponents:saturday];
    NSDateComponents *sunday = [[NSDateComponents alloc] init];
    [sunday setDay:29];
    [sunday setMonth:8];
    [sunday setYear:2015];
    NSDate *sundayDate = [calendar dateFromComponents:sunday];
    NSArray *timeArray = @[fridayDate, fridayDate, saturdayDate, saturdayDate, saturdayDate, sundayDate, sundayDate];
    
    for (int i=0; i < titleArray.count; i++) {
        Agenda *agenda = [Agenda agendaUpsertWithAgendaType:@"agenda" inManagedObjectContext:context];
        agenda.title = [titleArray objectAtIndex:i];
        agenda.location = [locationArray objectAtIndex:i];
        agenda.time = [timeArray objectAtIndex:i];
    }
    [coreData saveContext:context];
    [[ServiceCoordinator sharedCoordinator] completeLocalOperation:self];
}

@end
