//
//  PendingTargetsViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "PendingTargetsViewController.h"
#import "TargetCell.h"
#import "HelperMethods.h"
#import "Friendship.h"
#import "GlobalConstants.h"

@interface PendingTargetsViewController ()

@end

@implementation PendingTargetsViewController {
    NSMutableArray *_pendingTargets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updatePendingTargetsData];
    self.PendingTargetsTableView.delegate = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pendingTargets.count;
}

- (void)viewDidAppear:(BOOL)animated {
    UIBarButtonItem *refreshTargetsBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                       target:self
                                                                                       action:@selector(updatePendingTargetsData)];
    self.parentViewController.navigationItem.rightBarButtonItems = @[refreshTargetsBtn];
    self.parentViewController.title = @"Pending Targets";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Friendship *currentTargetAtCell = (Friendship*)_pendingTargets[indexPath.row];
    static NSString *cellIdentifier = @"TargetCell";
    
    TargetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TargetCell" owner:self options:nil] objectAtIndex:0];
    }
    
    //TODO: ADD IMAGE TO THE CELL
    
    cell.UsernameLabel.text = [HelperMethods getTargetUsername:currentTargetAtCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Friendship *selectedPendingTarget = ((Friendship*)_pendingTargets[indexPath.row]);
    
    // THIS IS RIGHT; MAKE TRANSITION TO SCREEN WITH APPROVE/DECLINE BUTTONS
//    selectedPendingTarget.isApproved = YES;
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [selectedPendingTarget saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        UIAlertController *alert;
//        
//        if (succeeded) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            alert = [HelperMethods getAlert:TargetContactApprovedMessageTitle andMessage:TargetContactApprovedMessageDescription];
//            [self presentViewController:alert animated:YES completion:nil];
//        } else {
//            NSString *errorString = [HelperMethods getStringFromError:error];
//            alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
//            [self presentViewController:alert animated:YES completion:^{
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            }];
//        }
//        
//    }];
}

- (void)updatePendingTargetsData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFUser *user = [PFUser currentUser];
    PFQuery *friendshipToCurrentUser = [PFQuery queryWithClassName:@"Friendship"];
    [friendshipToCurrentUser whereKey:@"toUser" equalTo:user.username];
    [friendshipToCurrentUser whereKey:@"isApproved" equalTo:@NO];
    [friendshipToCurrentUser findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSString *errorString = [HelperMethods getStringFromError:error];
            UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        [_pendingTargets addObjectsFromArray:objects];
        
        self.PendingTargetsTableView.dataSource = self;
        [self.PendingTargetsTableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
