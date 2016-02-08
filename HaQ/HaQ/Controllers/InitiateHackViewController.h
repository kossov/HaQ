//
//  InitiateHackViewController.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/7/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface InitiateHackViewController : UIViewController <UIGestureRecognizerDelegate>

@property PFUser *userToHack;
@property (weak, nonatomic) IBOutlet UILabel *UsernameLabel;

@end
