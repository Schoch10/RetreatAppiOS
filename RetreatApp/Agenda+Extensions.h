//
//  Agenda+Extensions.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/22/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "Agenda.h"

@interface Agenda (Extensions)
+ (Agenda *)agendaUpsertWithAgendaType:(NSString *)agendaType inManagedObjectContext: (NSManagedObjectContext *)backgroundContext;

@end
