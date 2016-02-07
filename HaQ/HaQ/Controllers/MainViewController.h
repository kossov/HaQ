//
//  MainViewController.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/4/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic , strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UICollectionView *StatusBarGrid;
- (IBAction)StartHackingButtonAction:(id)sender;
- (IBAction)ShowTargetsButtonAction:(id)sender;
- (IBAction)CollectItemsButtonAction:(id)sender;

@end