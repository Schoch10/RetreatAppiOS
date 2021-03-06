//
//  Agenda+Extensions.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/22/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "Agenda+Extensions.h"
#import "CoreDataManager.h"

@implementation Agenda (Extensions)

+ (NSMutableDictionary *)agendaMapInContext:(NSManagedObjectContext *)context
{
    static NSMutableDictionary *agendaMap = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        agendaMap = [coreDataManager objectUriMap:@"Agenda" keyName:@"agendaId" context:context];
    });
    return agendaMap;
}


+ (Agenda *)agendaUpsertWithAgendaID:(NSNumber *)agendaId inManagedObjectContext: (NSManagedObjectContext *)backgroundContext {
    
    NSManagedObjectContext *context = backgroundContext;
    @synchronized(self)
    {
        CoreDataManager *coreDataManager = [CoreDataManager sharedManager];
        NSMutableDictionary *agendaMap = [self agendaMapInContext:context];
        NSURL *objectUri = [agendaMap objectForKey:agendaId];
        
        Agenda *agenda = nil;
        if(objectUri) {
            agenda = (Agenda *)[coreDataManager objectWithURI:objectUri context:context];
        }
        if(!agenda) {
            agenda = [NSEntityDescription insertNewObjectForEntityForName:@"Agenda" inManagedObjectContext:context];
            agenda.agendaId = agendaId;
            [context obtainPermanentIDsForObjects:@[agenda] error:nil];
            [agendaMap setObject:agenda.objectID.URIRepresentation forKey:agendaId];
        }
        return agenda;
    }
}

@end
