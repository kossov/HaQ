//
//  UserDataManager.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "DataManager.h"
#import "Item.h"
#import "HelperMethods.h"
#import "GlobalConstants.h"

@implementation DataManager

static DataManager *dataManager = nil;

+ (DataManager*)getInstance {
    if (dataManager == nil) {
        dataManager = [[super alloc] init];
    }
    
    return dataManager;
}

- (void)pushUserLocation:(CLLocation*)location {
    PFUser *user = [PFUser currentUser];
    PFGeoPoint *currentLocation = [PFGeoPoint geoPointWithLocation:location];
    [DataManager getInstance].currentPosition = currentLocation;
    user[@"location"] = currentLocation;
    [user saveInBackground];
}

@end
