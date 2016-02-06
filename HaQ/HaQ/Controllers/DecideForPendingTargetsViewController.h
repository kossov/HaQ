//
//  DecideForPendingTargetsViewController.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/6/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friendship.h"

@interface DecideForPendingTargetsViewController : UIViewController

@property Friendship *decideForPendingTarget;

@property (weak, nonatomic) IBOutlet UILabel *UsernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
- (IBAction)ApproveButtonAction:(id)sender;
- (IBAction)DeclineButtonAction:(id)sender;

@end
