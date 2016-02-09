//
//  CollectItemsViewController.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"

@interface CollectItemsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, DataFetcherDelegate>

- (IBAction)ShowMap:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *ItemsTableView;

@end
