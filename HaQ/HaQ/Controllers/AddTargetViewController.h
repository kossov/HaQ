//
//  AddTargetViewController.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTargetViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *TargetNamesSearchBar;

@property (weak, nonatomic) IBOutlet UITableView *TargetNamesTableView;

@end
