//
//  Agenda+Extensions.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/22/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "Agenda.h"

@interface Agenda (Extensions)
+ (Agenda *)agendaUpsertWithAgendaID:(NSNumber *)agendaId inManagedObjectContext: (NSManagedObjectContext *)backgroundContext;

@end
