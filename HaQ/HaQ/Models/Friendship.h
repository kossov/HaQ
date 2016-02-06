//
//  Friendship.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Friendship : PFObject<PFSubclassing>

@property NSString* byUser;
@property NSString* toUser;
@property BOOL isApproved;

+(NSString *)parseClassName;
+(Friendship *) friendshipWithUser:(NSString*) user toUser:(NSString*) username;

@end
