//
//  DecideForPendingTargetsViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/6/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "DecideForPendingTargetsViewController.h"
#import "Friendship.h"
#import "GlobalConstants.h"
#import "HelperMethods.h"
#import "PendingTargetsViewController.h"
#import "ModelConstants.h"

@interface DecideForPendingTargetsViewController ()

@end

@implementation DecideForPendingTargetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.UsernameLabel.text = [HelperMethods getTargetUsername:self.decideForPendingTarget];
    // TODO: Add image
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ApproveButtonAction:(id)sender {
    self.decideForPendingTarget.isApproved = TargetContactApproved;
    [self saveTargetInBackground];
    [self performSegueWithIdentifier:@"AcceptedContactBackToMain" sender:self];
}

- (IBAction)DeclineButtonAction:(id)sender {
    self.decideForPendingTarget.isApproved = TargetContactDeclined;
    [self saveTargetInBackground];
    [self performSegueWithIdentifier:@"AcceptedContactBackToMain" sender:self];
}

- (void)saveTargetInBackground {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.decideForPendingTarget saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alert;
        if (succeeded) {
            alert = [HelperMethods getAlert:TargetContactApprovedMessageTitle
                                 andMessage:TargetContactApprovedMessageDescription];
        } else {
            NSString *errorString = [HelperMethods getStringFromError:error];
            alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
        }
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
@end
