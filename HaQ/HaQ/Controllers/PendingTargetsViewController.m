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
#import "DecideForPendingTargetsViewController.h"
#import "ModelConstants.h"

@interface PendingTargetsViewController ()

@end

@implementation PendingTargetsViewController {
    NSMutableArray *_pendingTargets;
    Friendship *_selectedPendingTarget;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updatePendingTargetsData];
    self.PendingTargetsTableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    UIBarButtonItem *refreshTargetsBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                       target:self
                                                                                       action:@selector(updatePendingTargetsData)];
    self.parentViewController.navigationItem.rightBarButtonItems = @[refreshTargetsBtn];
    self.parentViewController.title = @"Pending Targets";
}

- (void)updatePendingTargetsData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFUser *user = [PFUser currentUser];
    PFQuery *friendshipToCurrentUser = [PFQuery queryWithClassName:@"Friendship"];
    [friendshipToCurrentUser whereKey:@"toUser" equalTo:user.username];
    [friendshipToCurrentUser whereKey:@"isApproved" equalTo:TargetContactPending];
    [friendshipToCurrentUser findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSString *errorString = [HelperMethods getStringFromError:error];
            UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        _pendingTargets = [NSMutableArray arrayWithArray:objects];
        
        self.PendingTargetsTableView.dataSource = self;
        [self.PendingTargetsTableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pendingTargets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Friendship *currentTargetAtCell = (Friendship*)_pendingTargets[indexPath.row];
    static NSString *cellIdentifier = @"PendingTargetCell";
    
    TargetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TargetCell" owner:self options:nil] objectAtIndex:0];
    }
    
    //TODO: ADD IMAGE TO THE CELL
    
    cell.UsernameLabel.text = [HelperMethods getTargetUsername:currentTargetAtCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedPendingTarget = ((Friendship*)_pendingTargets[indexPath.row]);
    [self performSegueWithIdentifier:@"DecideForPendingTarget" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DecideForPendingTarget"]) {
        
        // Get destination view
        DecideForPendingTargetsViewController *toVC = [segue destinationViewController];
        
        // Pass the information to your destination view
        toVC.decideForPendingTarget = _selectedPendingTarget;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
