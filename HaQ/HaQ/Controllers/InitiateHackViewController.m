//
//  InitiateHackViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/7/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "HaQ-Swift.h"
#import "InitiateHackViewController.h"
#import "GlobalConstants.h"
#import "HelperMethods.h"
#import "HackViewController.h"
#import "GoogleMapViewController.h"
#import "Attack.h"

@interface InitiateHackViewController ()

@end

@implementation InitiateHackViewController {
    NSInteger _initiateAttackCount;
    NSTimer *_timer;
    BOOL _incrementing;
    BOOL _attackInitiated;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.UsernameLabel.text = self.userToHack.username;
    
    CGRect rect = CGRectMake(self.view.bounds.size.width / 2 - 75, 8 * (self.view.bounds.size.height / 12) + 30, 150, 150);
    DoubleCircleButton *btn = [[DoubleCircleButton alloc] initWithFrame:rect];
    UILongPressGestureRecognizer *handler = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleHoldGesture:)];
    handler.minimumPressDuration = 0.3;
    handler.delegate = self;
    [btn addGestureRecognizer:handler];
    [self.view addSubview:btn];
}

- (void)handleHoldGesture:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if (!_incrementing) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                      target:self
                                                    selector:@selector(addToCount)
                                                    userInfo:nil
                                                     repeats:YES];
            _incrementing = YES;
        }
    }
    
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        if (_initiateAttackCount < InitiateAttackCountInSeconds && [_timer isValid] && _incrementing) {
            [_timer invalidate];
        } else {
            [_timer invalidate];
            _timer = nil;
            return;
        }
        
        _timer = nil;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(takeFromCount)
                                                userInfo:nil
                                                 repeats:YES];
        _incrementing = NO;
    }
}

- (void)addToCount {
    if (_initiateAttackCount >= InitiateAttackCountInSeconds && !_attackInitiated) {
        [self initiateAttack];
        _attackInitiated = YES;
    }
    
    _initiateAttackCount += 1;
}

- (void)takeFromCount {
    if (_initiateAttackCount == 0) {
        return;
    }
    
    _initiateAttackCount -= 1;
}

- (void)initiateAttack {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.userToHack[@"isOnline"]) {
        PFQuery *queryNoBodyAttacksHim = [PFQuery queryWithClassName:@"Attack"];
        [queryNoBodyAttacksHim whereKey:@"hasEnded" equalTo:@NO];
        [queryNoBodyAttacksHim findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            for (int i = 0; i < objects.count; i++) {
                Attack *currentAttack = objects[i];
                if (currentAttack.byUser == self.userToHack.username ||
                    currentAttack.toUser == self.userToHack.username) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    UIAlertController *alert = [HelperMethods getAlert:UserIsBusyOrNotAccesableMessageTitle andMessage:UserIsBusyOrNotAccesableMessageDescription];
                    [self presentViewController:alert animated:YES completion:nil];
                    return;
                }
            }
            
            Attack *attack = [Attack attackWithUser:[PFUser currentUser].username toUser:self.userToHack.username];
            
            [attack saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error) {
                    NSString *errorString = [HelperMethods getStringFromError:error];
                    UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
                    [self presentViewController:alert animated:YES completion:nil];
                    return;
                }
                
                [self loadHackScreen];
            }];
        }];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alert = [HelperMethods getAlert:UserIsBusyOrNotAccesableMessageTitle andMessage:@"User is offline."];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)loadMap {
    GoogleMapViewController *toVC = [[GoogleMapViewController alloc] init];
    toVC.mustShowItems = NO;
    [self.navigationController pushViewController:toVC animated:YES];
}

-(void)loadHackScreen {
    [self performSegueWithIdentifier:@"StartHacking" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
