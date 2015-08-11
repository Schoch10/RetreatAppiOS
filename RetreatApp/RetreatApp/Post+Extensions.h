//
//  Post+Extensions.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/11/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "Post.h"

@interface Post (Extensions)

+ (Post *)postUpsertWithPostId:(NSNumber *)postId inManagedObjectContext: (NSManagedObjectContext *)backgroundContext;

@end
