//
//  Friendship.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "Friendship.h"

@implementation Friendship

@dynamic byUser;
@dynamic toUser;
@dynamic isApproved;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Friendship";
}

+(Friendship *) friendshipWithUser:(NSString*) byUser toUser:(NSString*) toUser {
    Friendship *friendship = [Friendship object];
    friendship.byUser = byUser;
    friendship.toUser = toUser;
    friendship.isApproved = NO;
    
    return friendship;
}

@end
