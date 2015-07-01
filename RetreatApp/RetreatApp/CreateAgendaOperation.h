//
//  CreateAgendaOperation.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/22/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "SCOperation.h"

@interface CreateAgendaOperation : SCOperation

@property (strong, nonatomic) NSString *agendaType;

-(instancetype)initAgendaWithType:(NSString *)agendaType;

@end
