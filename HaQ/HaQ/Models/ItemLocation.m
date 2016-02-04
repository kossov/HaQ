//
//  ItemLocation.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/4/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

// TOP LEFT: (42.722142, 23.244152)
// TOP RIGHT: (42.722142, 23.363800)
// BOTTOM RIGHT: (42.722552, 23.244152)
// BOTTOM LEFT: (42.722552, 23.363800)

#import <Parse/Parse.h>
#import "ItemLocation.h"

@implementation ItemLocation

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"ItemLocation";
}

@end