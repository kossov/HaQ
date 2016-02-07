//
//  RegisterViewController.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/2/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *UsernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordConfirmTextField;

- (IBAction)SignUpAction:(id)sender;

@end
