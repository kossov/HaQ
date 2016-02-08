//
//  Attack.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/8/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Attack : PFObject<PFSubclassing>

@property NSString* byUser;
@property NSString* toUser;
@property BOOL hasEnded;

+(NSString *)parseClassName;

+(Attack *) attackWithUser:(NSString*) byUser toUser:(NSString*) toUser;

@end
