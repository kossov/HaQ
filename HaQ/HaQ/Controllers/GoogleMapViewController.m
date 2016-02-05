//
//  GoogleMapViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "GoogleMapViewController.h"
#import "UserDataManager.h"

@implementation GoogleMapViewController {
    GMSMapView *_mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    PFGeoPoint *currentUserPosition = [UserDataManager getInstance].currentPosition;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentUserPosition.latitude
                                                            longitude:currentUserPosition.longitude
                                                                 zoom:15];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    [self addMarkers];
    
    self.view = _mapView;
}

- (void)addMarkers {
    NSMutableArray *itemsPositions = [UserDataManager getInstance].itemPositions;
    NSMutableArray *targetsPositions = [UserDataManager getInstance].targetPositions;
    
    if (self.mustShowItems) {
        for (int i = 0; i<itemsPositions.count; i++) {
            PFGeoPoint *currentItem = (PFGeoPoint*)[itemsPositions objectAtIndex:i];
            double longitude = currentItem.longitude;
            double latitude = currentItem.latitude;
            
            GMSMarker *itemMarker = [[GMSMarker alloc] init];
            itemMarker.title = @"Briefcase!";
            itemMarker.icon = [UIImage imageNamed:@"briefcase"];
            itemMarker.position = CLLocationCoordinate2DMake(longitude, latitude);
            itemMarker.map = _mapView;
        }
    } else {
        for (int i = 0; i<targetsPositions.count; i++) {
            PFGeoPoint *currentTarget = (PFGeoPoint*)[targetsPositions objectAtIndex:i];
            double longitude = currentTarget.longitude;
            double latitude = currentTarget.latitude;
            
            GMSMarker *targetMarker = [[GMSMarker alloc] init];
            targetMarker.title = @"Unknown Hacker!";
            targetMarker.icon = [UIImage imageNamed:@"glow-marker"];
            targetMarker.position = CLLocationCoordinate2DMake(longitude, latitude);
            targetMarker.map = _mapView;
        }
    }
}

@end