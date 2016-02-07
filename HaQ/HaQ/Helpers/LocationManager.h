//
//  LocationManager.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/6/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;

+ (LocationManager*)getInstance;

- (void)startLocationServices;

@end
