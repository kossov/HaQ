//
//  Attack.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/8/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "Attack.h"
#import "ModelConstants.h"

@implementation Attack

@dynamic byUser;
@dynamic toUser;
@dynamic hasEnded;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Attack";
}

+(Attack *) attackWithUser:(NSString*) byUser toUser:(NSString*) toUser {
    Attack *attack = [Attack object];
    attack.byUser = byUser;
    attack.toUser = toUser;
    attack.hasEnded = NO;
    
    return attack;
}

@end
