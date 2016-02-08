//
//  MainViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/4/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MainViewController.h"
#import "LoginViewController.h"
#import "DataManager.h"
#import "HelperMethods.h"
#import "GlobalConstants.h"
#import "LocationManager.h"
#import "GoogleMapViewController.h"
#import "StatusItemView.h"
#import "BackgroundAnimation.h"

@interface MainViewController ()

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
    
    BackgroundAnimation *animation = [[BackgroundAnimation alloc] init];
    [animation setBackgroundAnimationWithFrame:CGRectMake(self.view.bounds.size.width / 12 - 10,
                                                          (7 * self.view.bounds.size.height / 9) + 50,
                                                          80, 50)
                                       andView:self.view];
    [[LocationManager getInstance] startLocationServices];
}

- (void)addStatusItemView {
    StatusItemView *statusItemView = [[StatusItemView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 100, 90,200,100)];
    NSString *bagsCount = (NSString*)[PFUser currentUser][@"moneyBags"];
    statusItemView.bagsCount = [NSString stringWithFormat:@"%ld", bagsCount.integerValue];
    statusItemView.opaque = NO;
    [self.view addSubview:statusItemView];
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

- (IBAction)ShowMap:(id)sender {
    GoogleMapViewController *toVC = [[GoogleMapViewController alloc] init];
    toVC.mustShowItems = YES;
    [self.navigationController pushViewController:toVC animated:YES];
}

- (void)moveToLogInStage {
    [self performSegueWithIdentifier:@"LogOut" sender:self];
}

- (IBAction)StartHackingButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"HackTargets" sender:self];
}

- (IBAction)ShowTargetsButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"ShowTargets" sender:self];
}

- (IBAction)CollectItemsButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"CollectItems" sender:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [DataUpdateProtocol getInstance].delegate = self;
    
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[StatusItemView class]])
        {
            [subView removeFromSuperview];
        }
    }
    
    [self addStatusItemView];
}


-(void)newDataFetched {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
