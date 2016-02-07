//
//  ItemLocation.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/4/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface Item : PFObject<PFSubclassing>

@property PFGeoPoint *location;
@property NSString *name;
@property BOOL isTaken;
@property PFUser *takenBy;

+(NSString *)parseClassName;
+(Item *) itemWithName:(NSString*) name andLocation:(PFGeoPoint*) location;

@end