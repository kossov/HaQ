//
//  ChooseTargetToHackViewController.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/7/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataUpdateProtocol.h"

@interface ChooseTargetToHackViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, DataUpdateProtocolDelegate>

@property (weak, nonatomic) IBOutlet UITableView *HackTargetsTableView;

- (IBAction)ShowMapButtonAction:(id)sender;

@end
