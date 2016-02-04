//
//  UserLocation.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/4/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import "UserLocation.h"

@implementation UserLocation

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"UserLocation";
}

@end
