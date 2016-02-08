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
#import "DataUpdateProtocol.h"

@interface BeingHackedViewController ()

@end

@implementation BeingHackedViewController {
    NSMutableArray *_allTargetUsernames;
    NSMutableArray *_displayItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    self.TargetsTable.delegate = self;
    self.SearchBar.delegate = self;
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
    Attack *attack = [DataManager getInstance].hackAttack;
    __block UIAlertController *alert;
    if (selectedUser.username == attack.byUser) {
        // TODO: add point
        alert = [UIAlertController alertControllerWithTitle: AttackerGuessedSuccessfullyMessageTitle
                                                    message: AttackerGuessedSuccessfullyMessageDescription
                                             preferredStyle:UIAlertControllerStyleAlert];
    } else {
        // TODO: remove point
        alert = [UIAlertController alertControllerWithTitle: AttackerGuessedNotSuccessfullyMessageTitle
                                                     message: AttackerGuessedNotSuccessfullyMessageDescription
                                              preferredStyle:UIAlertControllerStyleAlert];
    }
    
    UIAlertAction *alertOkButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [self performSegueWithIdentifier:@"attackHandled" sender:self];
                                    }];
    
    attack.hasEnded = YES;
    [attack saveInBackground];
    [FetchDataProtocol getInstance].isHandled = YES;
    [alert addAction:alertOkButton];
    [self presentViewController:alert animated:YES completion:nil];
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
