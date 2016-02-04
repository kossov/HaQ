//
//  UserLocation.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/4/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface UserLocation : PFObject<PFSubclassing>

+(NSString *)parseClassName;

@end
