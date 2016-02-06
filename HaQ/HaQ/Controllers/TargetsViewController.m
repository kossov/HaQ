//
//  TargetsViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "TargetsViewController.h"
#import "TargetCell.h"
#import "HelperMethods.h"
#import "Friendship.h"
#import "GlobalConstants.h"

@interface TargetsViewController ()

@end

@implementation TargetsViewController {
    NSMutableArray *_allTargets;
    NSMutableArray *_displayTargets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTargetData];
    
    self.TargetsTableView.delegate = self;
    self.TargetsSearchBar.delegate = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _displayTargets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Friendship *currentTargetAtCell = (Friendship*)_displayTargets[indexPath.row];
    static NSString *cellIdentifier = @"TargetCell";
    
    TargetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TargetCell" owner:self options:nil] objectAtIndex:0];
    }
    
    //TODO: ADD IMAGE TO THE CELL
    
    cell.UsernameLabel.text = [HelperMethods getTargetUsername:currentTargetAtCell];
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [_displayTargets removeAllObjects];
        [_displayTargets addObjectsFromArray:_allTargets];
    } else {
        [_displayTargets removeAllObjects];
        for (int i = 0; i<_allTargets.count; i++) {
            Friendship *currentTarget = _allTargets[i];
            NSString *username = [HelperMethods getTargetUsername:currentTarget];
            NSRange range = [username rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [_displayTargets addObject:currentTarget];
            }
        }
    }
    
    [self.TargetsTableView reloadData];
}

- (void)updateTargetData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFUser *user = [PFUser currentUser];
    PFQuery *friendshipByCurrentUser = [PFQuery queryWithClassName:@"Friendship"];
    [friendshipByCurrentUser whereKey:@"byUser" equalTo:user.username];
    [friendshipByCurrentUser whereKey:@"isApproved" equalTo:@NO];
    [friendshipByCurrentUser findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        _allTargets = [NSMutableArray arrayWithArray:objects];
        _displayTargets = [NSMutableArray arrayWithArray:objects];
        PFQuery *friendshipToCurrentUser = [PFQuery queryWithClassName:@"Friendship"];
        [friendshipToCurrentUser whereKey:@"toUser" equalTo:user.username];
        [friendshipToCurrentUser whereKey:@"isApproved" equalTo:@NO];
        [friendshipToCurrentUser findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects2, NSError * _Nullable error2) {
            if (error2) {
                NSString *errorString = [HelperMethods getStringFromError:error2];
                UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            
            [_allTargets addObjectsFromArray:objects2];
            [_displayTargets addObjectsFromArray:objects2];
            
            self.TargetsTableView.dataSource = self;
            [self.TargetsTableView reloadData];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    UIBarButtonItem *refreshTargetsBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                       target:self
                                                                                       action:@selector(updateTargetData)];
    UIBarButtonItem *addTargetBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self
                                                                                  action:@selector(addTarget)];
    self.parentViewController.navigationItem.rightBarButtonItems = @[refreshTargetsBtn, addTargetBtn];
    self.parentViewController.title = @"Your Targets";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTarget {
    [self performSegueWithIdentifier:@"AddTarget" sender:self];
}

@end
