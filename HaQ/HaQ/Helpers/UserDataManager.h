//
//  UserDataManager.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserDataManager : NSObject

@property PFGeoPoint *currentPosition;
@property NSMutableArray *itemPositions;
@property NSMutableArray *targetPositions;

@property NSMutableArray *targets;

+ (UserDataManager*)getInstance;

+ (void)fetchUserData;

@end
