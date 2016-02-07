//
//  ItemLocation.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/4/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import "Item.h"

@implementation Item

@dynamic location;
@dynamic name;
@dynamic isTaken;
@dynamic takenBy;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"Item";
}

+(Item *) itemWithName:(NSString*) name andLocation:(PFGeoPoint*) location {
    Item *item = [Item object];
    item.name = name;
    item.location = location;
    item.isTaken = NO;
    
    return item;
}

@end