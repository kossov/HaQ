//
//  UserDataManager.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "UserDataManager.h"

@implementation UserDataManager

static UserDataManager *dataManager = nil;

+ (UserDataManager*)getInstance {
    if (dataManager == nil) {
        dataManager = [[super alloc] init];
    }
    
    return dataManager;
}

- (id)init {
    if ((self = [super init])) {
        // prepare data?
    }
    
    return self;
}

+ (void)fetchUserData {
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        return;
    }
    
}

- (void)pushUserLocation:(CLLocation*)location {
    PFUser *user = [PFUser currentUser];
    PFGeoPoint *currentLocation = [PFGeoPoint geoPointWithLocation:location];
    [UserDataManager getInstance].currentPosition = currentLocation;
    user[@"location"] = currentLocation;
    [user saveInBackground];
}

@end
