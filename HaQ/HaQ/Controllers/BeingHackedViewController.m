//
//  BeingHackedViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/8/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "HelperMethods.h"
#import "Friendship.h"
#import "GlobalConstants.h"
#import "ModelConstants.h"
#import "BeingHackedViewController.h"
#import "Attack.h"
#import "DataManager.h"
#import "DataFetcher.h"
#import "MoneyBag.h"

@interface BeingHackedViewController ()

@end

@implementation BeingHackedViewController {
    NSMutableArray *_allTargetUsernames;
    NSMutableArray *_displayItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TargetsTable.delegate = self;
    self.SearchBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
    [self updateTableData];
}

- (void)updateTableData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" notEqualTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSString *errorMessage = [HelperMethods getStringFromError:error];
            UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorMessage];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        _allTargetUsernames = [NSMutableArray arrayWithArray:objects];
        _displayItems = [NSMutableArray arrayWithArray:objects];
        self.TargetsTable.dataSource = self;
        [self.TargetsTable reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:@"Dummy Alert"];
    UIAlertAction *alertOkButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self performSegueWithIdentifier:@"attackHandled" sender:self];
                                    }];
    [alert addAction:alertOkButton];
    
    PFUser *selectedUser = ((PFUser*)_displayItems[indexPath.row]);
    Attack *attack = [DataManager getInstance].hackAttack;
    if (attack.hasEnded) {
        // TAKE FROM HIM ONE POINT
        PFQuery *queryTakeAPoint = [PFQuery queryWithClassName:@"MoneyBag"];
        [queryTakeAPoint whereKey:@"username" equalTo:[PFUser currentUser].username];
        [queryTakeAPoint getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MoneyBag *userMoneyBag = (MoneyBag*)object;
            userMoneyBag.value -= 1;
            [userMoneyBag saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error) {
                    alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:[HelperMethods getStringFromError:error]];
                } else {
                    alert = [HelperMethods getAlert:HackedLostMoneyMessageTitle andMessage:HackedLostMoneyMessageDescription];
                }
                
                [DataFetcher getInstance].isHandled = YES;
                [self presentViewController:alert animated:YES completion:nil];
            }];
        }];
        
        return;
    }
    
    if (selectedUser.username == attack.byUser) {
        // GIVE HIM A POINT, END ATTACK
        // THE ATTACKER ALSO CHECKS IF IT IS INVALID -> GIVE HIM A POINT, END ATTACK, IF NOT TAKE A POINT
        PFQuery *queryGiveAPoint = [PFQuery queryWithClassName:@"MoneyBag"];
        [queryGiveAPoint whereKey:@"username" equalTo:[PFUser currentUser].username];
        [queryGiveAPoint getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            MoneyBag *userMoneyBag = (MoneyBag*)object;
            [userMoneyBag incrementKey:@"value"];
            [userMoneyBag saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                alert.title = AttackerGuessedSuccessfullyMessageTitle;
                alert.message = AttackerGuessedSuccessfullyMessageDescription;
                
                attack.hasEnded = YES;
                [attack saveInBackground];
                [self presentViewController:alert animated:YES completion:nil];
            }];
        }];
    } else {
        // DONT GIVE HIM A POINT, DONT END ATTACK -> ATTACKER WILL END IT AND WILL TAKE A POINT FOR IT WHEN TAPPED 50 TIMES
        alert.title = AttackerGuessedNotSuccessfullyMessageTitle;
        alert.message = AttackerGuessedNotSuccessfullyMessageDescription;
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [DataFetcher getInstance].isHandled = YES;
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
    
    [self.TargetsTable reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
