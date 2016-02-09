//
//  HackViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "HaQ-Swift.h"
#import "HackViewController.h"
#import "DataManager.h"
#import "DataFetcher.h"
#import "HelperMethods.h"
#import "GlobalConstants.h"
#import "Attack.h"
#import "MoneyBag.h"

@interface HackViewController ()

@end

@implementation HackViewController {
    int _tappedCount;
    UIAlertController *_alert;
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *handler = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    handler.delegate = self;
    [self.HackButton addGestureRecognizer:handler];
    
    _alert = [UIAlertController alertControllerWithTitle:SomethingBadHappenedTitleMessage
                                                 message:@"Whooops."
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertOkButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self performSegueWithIdentifier:@"backToMain" sender:self];
                                    }];
    [_alert addAction:alertOkButton];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
    _timer = [NSTimer scheduledTimerWithTimeInterval:120
                                              target:self
                                            selector:@selector(hackTimeIsUp)
                                            userInfo:nil
                                             repeats:NO];
}

- (void)tapGesture {
    if (_tappedCount >= 50) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // CHECK IF ATTACK IS NOT ENDED -> ADD POINT OTHERWISE REMOVE POINT
        Attack *attack = [DataManager getInstance].hackAttack;
        if (attack.hasEnded) {
            PFQuery *queryTakeAPoint = [PFQuery queryWithClassName:@"MoneyBag"];
            [queryTakeAPoint whereKey:@"username" equalTo:[PFUser currentUser].username];
            [queryTakeAPoint getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                MoneyBag *userMoneyBag = (MoneyBag*)object;
                userMoneyBag.value -= 1;
                [userMoneyBag saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error) {
                        _alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:[HelperMethods getStringFromError:error]];
                    } else {
                        _alert = [HelperMethods getAlert:HackFailedUserBustedMessageTitle andMessage:HackFailedUserBustedMessageDescription];
                    }
                    
                    [self presentViewController:_alert animated:YES completion:nil];
                }];
            }];
            
            return;
        }
        
        attack.hasEnded = YES;
        [attack saveInBackground];
        
        PFQuery *query = [PFQuery queryWithClassName:[MoneyBag parseClassName]];
        [query whereKey:@"username" equalTo:[PFUser currentUser].username];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error) {
                _alert.message = [HelperMethods getStringFromError:error];
                [self presentViewController:_alert animated:YES completion:nil];
                return;
            }
            
            MoneyBag *userMoneyBag = (MoneyBag*)object;
            [userMoneyBag incrementKey:@"value"];
            [userMoneyBag saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    _alert.message = [HelperMethods getStringFromError:error];
                    [self presentViewController:_alert animated:YES completion:nil];
                    return;
                }
                
                _alert.message = HackedSuccessfullyMessageTitle;
                _alert.title = HackedSuccessfullyMessageDescription;
                [self presentViewController:_alert animated:YES completion:nil];
            }];
        }];
    } else {
        _tappedCount += 1;
    }
}

- (void)hackTimeIsUp {
    [_timer invalidate];
    _timer = nil;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _alert.title = HackTimeOutMessageTitle;
    _alert.message = HackTimeOutMessageDescription;

    [self presentViewController:_alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
