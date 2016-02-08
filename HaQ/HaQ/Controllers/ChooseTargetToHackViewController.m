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

@interface ChooseTargetToHackViewController ()

@end

@implementation ChooseTargetToHackViewController {
    NSMutableArray *_allTargetsToHack;
    NSMutableArray *_displayTargetsToHack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [DataUpdateProtocol getInstance].delegate = self;
}

-(void)newDataFetched {
    
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
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [_displayTargetsToHack removeAllObjects];
        [_displayTargetsToHack addObjectsFromArray:_allTargetsToHack];
    } else {
        [_displayTargetsToHack removeAllObjects];
        for (int i = 0; i<_allTargetsToHack.count; i++) {
            PFUser *currentHackTarget = _allTargetsToHack[i];
            NSRange range = [currentHackTarget.username rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [_displayTargetsToHack addObject:currentHackTarget];
            }
        }
    }
    
    //[self.TargetsTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
