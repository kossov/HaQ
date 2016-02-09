//
//  CollectItemsViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

//PFUser *testUser = [PFUser currentUser];
//PFObject *testObj = [testUser objectForKey:@"moneyBags"];
//NSString *testStr = (NSString*)testObj;
//NSLog(@"%d", testStr.intValue);

#import <MBProgressHUD/MBProgressHUD.h>
#import "CollectItemsViewController.h"
#import "GoogleMapViewController.h"
#import "DataManager.h"
#import "HelperMethods.h"
#import "GlobalConstants.h"
#import "ModelConstants.h"
#import "Item.h"
#import "PictureCell.h"
#import "LocationManager.h"

@implementation CollectItemsViewController {
    NSMutableArray *_itemsForCurrentLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkForItemsOrCreate];
    
    UIBarButtonItem *refreshTargetsBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                       target:self
                                                                                       action:@selector(getItemsForCurrentLocation)];
    self.navigationItem.rightBarButtonItem = refreshTargetsBtn;
    self.ItemsTableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [DataFetcher getInstance].delegate = self;
}

-(void)hackAttack {
    
}

- (IBAction)ShowMap:(id)sender {
    GoogleMapViewController *toVC = [[GoogleMapViewController alloc] init];
    toVC.mustShowItems = YES;
    [self.navigationController pushViewController:toVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemsForCurrentLocation.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Item *currentItemAtCell = (Item*)_itemsForCurrentLocation[indexPath.row];
    static NSString *cellIdentifier = @"ItemCell";
    
    PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PictureCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.Label.text = currentItemAtCell.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Item *claimedItem = ((Item*)_itemsForCurrentLocation[indexPath.row]);
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query whereKey:@"isTaken" equalTo:@NO];
    [query whereKey:@"objectId" equalTo:claimedItem.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSString *errorString = [HelperMethods getStringFromError:error];
            UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        if (!object) {
            UIAlertController *alert = [HelperMethods getAlert:ItemAlreadyClaimedMessageTitle andMessage:ItemAlreadyClaimedMessageDescription];
            [self presentViewController:alert animated:YES completion:nil];
            
            [_itemsForCurrentLocation removeObjectAtIndex:indexPath.row];
            [self.ItemsTableView reloadData];

            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        PFUser *user = [PFUser currentUser];
        Item *item = ((Item*)object);
        item.isTaken = YES;
        item.takenBy = user;
        
        [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error2) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertController *alert;
            if (!succeeded) {
                NSString *errorString = [HelperMethods getStringFromError:error2];
                alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
            } else {
                alert = [HelperMethods getAlert:ItemSuccessfullyClaimedMessageTitle andMessage:ItemSuccessfullyClaimedMessageDescription];
            }
            
            [user incrementKey:@"moneyBags"];
            [user saveInBackground];
            [_itemsForCurrentLocation removeObjectAtIndex:indexPath.row];
            [self.ItemsTableView reloadData];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }];
}

- (void)checkForItemsOrCreate {
    NSDate *todaysDate = [HelperMethods getEarliestTodaysDate];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query whereKey:@"createdAt" greaterThan:todaysDate];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSString *errorString = [HelperMethods getStringFromError:error];
            UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        if (objects.count == 0) {
            PFObject *itemsToAdd[6];
            for (int i = 0; i < ItemsPerDay; i++) {
                Item *itemToAdd = [Item itemWithName:ItemMoney andLocation:[HelperMethods getRandomLocationInSofia]];
                itemsToAdd[i] = itemToAdd;
            }
            
            NSArray *array = [NSArray arrayWithObjects:itemsToAdd count:5];
            [PFObject saveAllInBackground:array block:^(BOOL succeeded, NSError * _Nullable error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error) {
                    NSString *errorString = [HelperMethods getStringFromError:error];
                    UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
                    [self presentViewController:alert animated:YES completion:nil];
                    return;
                }
                
                [self getItemsForCurrentLocation];
            }];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self getItemsForCurrentLocation];
        }
    }];
}

- (void)getItemsForCurrentLocation {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFGeoPoint *currentLocation = [DataManager getInstance].currentPosition;
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query whereKey:@"location" nearGeoPoint:currentLocation withinKilometers:0.1];
    [query whereKey:@"isTaken" equalTo:@NO];
    query.limit = ItemsPerDay;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSString *errorString = [HelperMethods getStringFromError:error];
            UIAlertController *alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        _itemsForCurrentLocation = [NSMutableArray arrayWithArray:objects];
        self.ItemsTableView.dataSource = self;
        [self.ItemsTableView reloadData];
    }];
}

@end
