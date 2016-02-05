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

@interface MainViewController ()

@property NSInteger* testCount;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // HIDE BACK BUTTON - COMMING FROM LOGINVIEWCONTROLLER
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
    
    if (![PFUser currentUser]) {
        [self MoveToLogInStage];
        return;
    }
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"LogOut"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(LogOutUser)];
    self.navigationItem.rightBarButtonItem = myButton;
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LogOutUser {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"%@", errorString);
            return;
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self MoveToLogInStage];
    }];
}

- (void)MoveToLogInStage {
    [self performSegueWithIdentifier:@"LogOut" sender:self];
}

- (IBAction)StartHackingButtonAction:(id)sender {
}

- (IBAction)ShowTargetsButtonAction:(id)sender {
}

- (IBAction)CollectItemsButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"CollectItems" sender:self];
}

+ (void)FetchUserData {
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        NSLog(@"no user");
        return;
    }
    
    //[UserDataManager getInstance].test += 1;
    //NSLog(@"%d", [UserDataManager getInstance].test);
}

@end
