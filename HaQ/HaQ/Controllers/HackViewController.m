//
//  HackViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "HackViewController.h"
#import "HaQ-Swift.h"
#import "HelperMethods.h"
#import "Attack.h"
#import "DataManager.h"
#import "DataUpdateProtocol.h"

@interface HackViewController ()

@end

@implementation HackViewController {
    int _tappedCount;
    NSDate *_attackBeganAt;
    NSDate *_attackBeganAtPlusTwoMinutes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *handler = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    handler.delegate = self;
    [self.HackButton addGestureRecognizer:handler];
}

- (void) viewWillAppear:(BOOL)animated {
    _attackBeganAt = [NSDate date];
    _attackBeganAtPlusTwoMinutes = [_attackBeganAt dateByAddingTimeInterval:120];
}

- (void)tapGesture {
    if (_tappedCount >= 50) {
        UIAlertController *alert = [HelperMethods getAlert:@"Congratz!" andMessage:@"No one even noticed! You get them money!"];
        [self presentViewController:alert animated:YES completion:nil];
        // TODO: add score
    } else {
        NSDate *now = [NSDate date];
        
        if ([now compare:_attackBeganAtPlusTwoMinutes] == NSOrderedDescending) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Run man!"
                                                                           message: @"They almost got you.. maybe next time.."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertOkButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                [self performSegueWithIdentifier:@"hackTimedUp" sender:self];
                                            }];
            
            Attack *attack = [DataManager getInstance].hackAttack;
            attack.hasEnded = YES;
            [attack saveInBackground];
            [FetchDataProtocol getInstance].isHandled = YES;
            [alert addAction:alertOkButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
