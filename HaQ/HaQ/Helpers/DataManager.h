//
//  UserDataManager.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface DataManager : NSObject

@property PFGeoPoint *currentPosition;
@property NSMutableArray *items;
@property NSMutableArray *targetPositions;

@property NSMutableArray *targets;

+ (DataManager*)getInstance;

+ (void)fetchData;

- (void)pushUserLocation:(CLLocation*)location;

@end
