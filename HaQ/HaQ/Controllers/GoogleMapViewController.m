//
//  GoogleMapViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "GoogleMapViewController.h"
#import "DataManager.h"
#import "Item.h"
#import "HelperMethods.h"
#import "GlobalConstants.h"

@implementation GoogleMapViewController {
    GMSMapView *_mapView;
    PFGeoPoint *_currentUserPosition;
    NSArray *_currentItems;
    NSArray *_currentTargets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *refreshTargetsBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                       target:self
                                                                                       action:@selector(updateMap)];
    self.navigationItem.rightBarButtonItem = refreshTargetsBtn;

    _currentUserPosition = [DataManager getInstance].currentPosition;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_currentUserPosition.latitude
                                                            longitude:_currentUserPosition.longitude
                                                                 zoom:15];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [self updateMap];
    
    self.view = _mapView;
}

- (void)addMarkers {
    GMSMarker *userMarker = [[GMSMarker alloc] init];
    userMarker.title = @"That's you!";
    userMarker.icon = [UIImage imageNamed:@"glow-marker"];
    userMarker.position = CLLocationCoordinate2DMake(_currentUserPosition.latitude, _currentUserPosition.longitude);
    userMarker.map = _mapView;
    
    UIColor *color = [UIColor colorWithHue:.5f saturation:1.f brightness:1.f alpha:1.0f];
    if (self.mustShowItems) {
        for (int i = 0; i<_currentItems.count; i++) {
            Item *currentItem = (Item*)[_currentItems objectAtIndex:i];
            
            double longitude = currentItem.location.longitude;
            double latitude = currentItem.location.latitude;
            
            GMSMarker *itemMarker = [[GMSMarker alloc] init];
            itemMarker.title = @"Money!";
            itemMarker.icon = [UIImage imageNamed:@"icon_money"];
            itemMarker.position = CLLocationCoordinate2DMake(latitude, longitude);
            itemMarker.appearAnimation = kGMSMarkerAnimationPop;
            itemMarker.map = _mapView;
        }
    } else {
        for (int i = 0; i<_currentTargets.count; i++) {
            PFGeoPoint *currentTarget = (PFGeoPoint*)[_currentTargets objectAtIndex:i];
            double longitude = currentTarget.longitude;
            double latitude = currentTarget.latitude;
            
            GMSMarker *targetMarker = [[GMSMarker alloc] init];
            targetMarker.title = @"Unknown Hacker!";
            targetMarker.position = CLLocationCoordinate2DMake(latitude, longitude);
            targetMarker.appearAnimation = kGMSMarkerAnimationPop;
            targetMarker.icon = [GMSMarker markerImageWithColor:color];
            targetMarker.map = _mapView;
        }
    }
}

- (void)updateMap {
    [_mapView clear];
    [self updateMapData];
}

- (void)updateMapData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDate *todaysDate = [HelperMethods getEarliestTodaysDate];
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query whereKey:@"createdAt" greaterThan:todaysDate];
    [query whereKey:@"isTaken" equalTo:@NO];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSString *errorString = [HelperMethods getStringFromError:error];
            UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        _currentItems = [NSArray arrayWithArray:objects];
        [self addMarkers];
    }];
}

@end