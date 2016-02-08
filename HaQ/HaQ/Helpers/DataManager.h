//
//  UserDataManager.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Attack.h"

@interface DataManager : NSObject

@property Attack *hackAttack;
@property PFGeoPoint *currentPosition;
@property NSMutableArray *items;
@property NSMutableArray *targetPositions;

@property NSMutableArray *targets;

+ (DataManager*)getInstance;

- (void)pushUserLocation:(CLLocation*)location;

@end
