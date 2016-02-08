//
//  ChooseTargetToHackViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/7/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "ChooseTargetToHackViewController.h"
#import "PictureCell.h"
#import "ModelConstants.h"
#import "HelperMethods.h"
#import "GlobalConstants.h"
#import "InitiateHackViewController.h"
#import "DataManager.h"
#import "GoogleMapViewController.h"
#import "Attack.h"

@interface ChooseTargetToHackViewController ()

@end

@implementation ChooseTargetToHackViewController {
    NSMutableArray *_displayTargetsToHack;
    PFUser *_selectedUserToHack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateTargetsToHack];
    UIBarButtonItem *refreshTargetsBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                       target:self
                                                                                       action:@selector(updateTargetsToHack)];
    self.navigationItem.rightBarButtonItem = refreshTargetsBtn;
    self.HackTargetsTableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [DataUpdateProtocol getInstance].delegate = self;
}

- (void)newDataFetched {
    
}

- (void)updateTargetsToHack {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFGeoPoint *currentLocation = [DataManager getInstance].currentPosition;
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" notEqualTo:[PFUser currentUser].objectId];
    [query whereKey:@"isOnline" equalTo:@YES];
    [query whereKey:@"location" nearGeoPoint:currentLocation withinKilometers:0.1];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSString *errorString = [HelperMethods getStringFromError:error];
            UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _displayTargetsToHack = [NSMutableArray arrayWithArray:users];
        PFQuery *queryUsersNotPlaying = [PFQuery queryWithClassName:@"Attack"];
        [queryUsersNotPlaying whereKey:@"hasEnded" equalTo:@NO];
        [queryUsersNotPlaying findObjectsInBackgroundWithBlock:^(NSArray * _Nullable attacks, NSError * _Nullable error2) {
            if (error2) {
                NSString *errorString = [HelperMethods getStringFromError:error2];
                UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            
            for (int i = 0; i < users.count; i++) {
                PFUser *currentUser = users[i];
                for (int j = 0; j < attacks.count; j++) {
                    Attack *currentAttack = attacks[i];
                    if (currentUser.username == currentAttack.byUser ||
                        currentUser.username == currentAttack.toUser) {
                        [_displayTargetsToHack removeObject:currentUser];
                    }
                }
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.HackTargetsTableView.dataSource = self;
            [self.HackTargetsTableView reloadData];
        }];
    }];
}

- (IBAction)ShowMapButtonAction:(id)sender {
    GoogleMapViewController *toVC = [[GoogleMapViewController alloc] init];
    toVC.mustShowItems = NO;
    [self.navigationController pushViewController:toVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _displayTargetsToHack.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PFUser *currentHackTargetAtCell = (PFUser*)_displayTargetsToHack[indexPath.row];
    static NSString *cellIdentifier = @"HackableTargetCell";
    
    PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PictureCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.Label.text = currentHackTargetAtCell.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedUserToHack = _displayTargetsToHack[indexPath.row];
    [self performSegueWithIdentifier:@"InitiateHackAttack" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"InitiateHackAttack"]) {
        InitiateHackViewController *toVC = [segue destinationViewController];
        toVC.userToHack = _selectedUserToHack;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
