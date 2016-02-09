//
//  MainViewController.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/4/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"
#import "StatusItemView.h"

@interface MainViewController : UIViewController <CLLocationManagerDelegate, DataFetcherDelegate>

@property (nonatomic , strong) CLLocationManager *locationManager;

- (IBAction)StartHackingButtonAction:(id)sender;

- (IBAction)ShowTargetsButtonAction:(id)sender;

- (IBAction)CollectItemsButtonAction:(id)sender;

@end