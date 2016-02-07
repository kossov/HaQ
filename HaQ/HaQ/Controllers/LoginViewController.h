//
//  LoginViewController.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/2/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *UsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;

- (IBAction)SignUpButtonAction:(id)sender;

- (IBAction)LogInButtonAction:(id)sender;

@end
