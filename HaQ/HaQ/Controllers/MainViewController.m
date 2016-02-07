//
//  MainViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/4/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

// TOP LEFT: (42.722142, 23.244152)
// TOP RIGHT: (42.722142, 23.363800)
// BOTTOM RIGHT: (42.722552, 23.244152)
// BOTTOM LEFT: (42.722552, 23.363800)
//int longitude = [RandomNumberGenerator getRandomNumberBetween:722142 to:722552];
//int latitude = [RandomNumberGenerator getRandomNumberBetween:244152 to:363800];
//NSLog(@"Longitude: %d", longitude);
//NSLog(@"Latitude: %d", latitude);

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MainViewController.h"
#import "LoginViewController.h"
#import "UserDataManager.h"
#import "HelperMethods.h"
#import "GlobalConstants.h"
#import "LocationManager.h"

@interface MainViewController ()

@property NSInteger* testCount;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // HIDE BACK BUTTON - COMMING FROM LOGINVIEWCONTROLLER
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
    
    if (![PFUser currentUser]) {
        [self moveToLogInStage];
        return;
    }
    
    UIBarButtonItem *logOutBtn = [[UIBarButtonItem alloc] initWithTitle:@"LogOut"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(logOutUser)];
    self.navigationItem.rightBarButtonItem = logOutBtn;
    [[LocationManager getInstance] startLocationServices];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logOutUser {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSString *errorString = [HelperMethods getStringFromError:error];
            UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
            [self presentViewController:alert animated:YES completion:^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
            return;
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self moveToLogInStage];
    }];
}

- (void)moveToLogInStage {
    [self performSegueWithIdentifier:@"LogOut" sender:self];
}

- (IBAction)StartHackingButtonAction:(id)sender {
}

- (IBAction)ShowTargetsButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"ShowTargets" sender:self];
}

- (IBAction)CollectItemsButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"CollectItems" sender:self];
}

@end
