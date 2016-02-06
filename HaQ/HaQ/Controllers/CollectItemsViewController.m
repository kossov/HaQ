//
//  CollectItemsViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "CollectItemsViewController.h"
#import "GoogleMapViewController.h"
#import "UserDataManager.h"

@implementation CollectItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)ShowMap:(id)sender {
    GoogleMapViewController *toVC = [[GoogleMapViewController alloc] init];
    toVC.mustShowItems = YES;
    [self.navigationController pushViewController:toVC animated:YES];
}

- (void)checkForItemsOrCreate {
    
}

@end
