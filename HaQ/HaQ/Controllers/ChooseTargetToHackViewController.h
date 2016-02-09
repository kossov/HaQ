//
//  ChooseTargetToHackViewController.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/7/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"

@interface ChooseTargetToHackViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, DataFetcherDelegate>

@property (weak, nonatomic) IBOutlet UITableView *HackTargetsTableView;

- (IBAction)ShowMapButtonAction:(id)sender;

@end
