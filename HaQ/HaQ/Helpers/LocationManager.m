//
//  LocationManager.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/6/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "LocationManager.h"
#import "DataManager.h"

@implementation LocationManager

static LocationManager *locationManager = nil;

+ (LocationManager*)getInstance {
    if (locationManager == nil) {
        locationManager = [[super alloc] init];
    }
    
    return locationManager;
}

- (void)startLocationServices {
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    self.locationManager.distanceFilter = 1; // meters
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        [[DataManager getInstance] pushUserLocation:location];
    }
}

@end
