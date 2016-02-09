//
//  AddTargetViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "AddTargetViewController.h"
#import "HelperMethods.h"
#import "Friendship.h"
#import "GlobalConstants.h"
#import "ModelConstants.h"

@interface AddTargetViewController ()

@end

@implementation AddTargetViewController {
    NSMutableArray *_allTargetUsernames;
    NSMutableArray *_displayItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" notEqualTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSString *errorMessage = [HelperMethods getStringFromError:error];
            UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorMessage];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        _allTargetUsernames = [NSMutableArray arrayWithArray:objects];
        _displayItems = [NSMutableArray arrayWithArray:objects];
        self.TargetNamesTableView.dataSource = self;
        [self.TargetNamesTableView reloadData];
    }];
    
    self.TargetNamesTableView.delegate = self;
    self.TargetNamesSearchBar.delegate = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _displayItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TargetNameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat: @"%@", ((PFUser*)_displayItems[indexPath.row]).username];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFUser *selectedUser = ((PFUser*)_displayItems[indexPath.row]);
    PFUser *currentUser = [PFUser currentUser];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *suchFriendshipIsNotExistant = [PFQuery queryWithClassName:@"Friendship"];
    [suchFriendshipIsNotExistant whereKey:@"byUser" equalTo:currentUser.username];
    [suchFriendshipIsNotExistant whereKey:@"toUser" equalTo:selectedUser.username];
    [suchFriendshipIsNotExistant whereKey:@"objectId" notEqualTo:currentUser.objectId];
    [suchFriendshipIsNotExistant getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:@"Dummy Alert"];
        //        UIAlertAction *alertOkButton = [UIAlertAction
        //                                        actionWithTitle:@"OK"
        //                                        style:UIAlertActionStyleDefault
        //                                        handler:^(UIAlertAction * action)
        //                                        {
        //                                            [self performSegueWithIdentifier:@"addTargetBackToMain" sender:self];
        //                                        }];
        //        [alert addAction:alertOkButton];
        
        if (object) {
            Friendship *targetContact = (Friendship*)object;
            if (targetContact.isApproved == TargetContactDeclined) {
                targetContact.isApproved = TargetContactPending;
                [targetContact saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    alert.title = TargetContactSendMessageTitle;
                    alert.message = TargetContactSendMessageDescription;
                }];
                
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            
            alert.title = TargetContactSuchContactAlreadyExistsMessageTitle;
            alert.message = TargetContactSuchContactAlreadyExistsMessageDescription;
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        Friendship *friendship = [Friendship friendshipWithUser:currentUser.username toUser:selectedUser.username];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [friendship saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (succeeded) {
                alert.title = TargetContactSendMessageTitle;
                alert.message = TargetContactSendMessageDescription;
            } else {
                NSString *errorString = [HelperMethods getStringFromError:error];
                alert.message = errorString;
            }
            
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [_displayItems removeAllObjects];
        [_displayItems addObjectsFromArray:_allTargetUsernames];
    } else {
        [_displayItems removeAllObjects];
        for (int i = 0; i<_allTargetUsernames.count; i++) {
            PFUser *currentUser = _allTargetUsernames[i];
            NSRange range = [currentUser.username rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [_displayItems addObject:currentUser];
            }
        }
    }
    
    [self.TargetNamesTableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
