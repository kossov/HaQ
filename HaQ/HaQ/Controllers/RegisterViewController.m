//
//  RegisterViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/2/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>

@interface RegisterViewController ()

@end

@implementation RegisterViewController {
    UIAlertController *_alert;
    UIAlertAction *_alertOkButton;
    NSString *_alertTitle;
    NSString *_alertMessage;
    PFUser *_user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [PFUser user];
    _alertTitle = @"Buug!";
    _alertOkButton = [UIAlertAction
                     actionWithTitle:@"OK"
                     style:UIAlertActionStyleDefault
                     handler:^(UIAlertAction * action)
                     {
                         [_alert dismissViewControllerAnimated:YES completion:nil];
                         
                     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SignUpAction:(id)sender {
    NSString *username = self.UsernameTextField.text;
    NSString *password = self.PasswordTextField.text;
    NSString *confirmPassword = self.PasswordConfirmTextField.text;
    BOOL isDirty = NO;
    
    if (username.length < 5) {
        isDirty = YES;
        _alertMessage = @"Register with at least 5 symbols for username.";
    }
    
    if (password.length < 5 && !isDirty) {
        isDirty = YES;
        _alertMessage = @"Password must be with at least 5 symbols.";
    }
    
    if (confirmPassword.length < 5 && !isDirty) {
        isDirty = YES;
        _alertMessage = @"Confirm password with at least 5!!1 symbols!";
    }
    
    if (password != confirmPassword && !isDirty) {
        isDirty = YES;
        _alertMessage = @"Passwords don't match!";
    }
    
    if (isDirty) {
        _alert = [UIAlertController alertControllerWithTitle: _alertTitle
                                                    message: _alertMessage
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        [_alert addAction:_alertOkButton];
        [self presentViewController:_alert animated:YES completion:nil];
        return;
    }
    
    _user.username = username;
    _user.password = password;
    
    [_user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            _alert = [UIAlertController alertControllerWithTitle: @"HaQuu!"
                                                        message: @"Registered successfully!"
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
            _alertOkButton = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [_alert removeFromParentViewController];
                                 [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
                             }];
            
            [_alert addAction:_alertOkButton];
            [self presentViewController:_alert animated:YES completion:nil];
        } else {
            _alert = [UIAlertController alertControllerWithTitle: @"Whooops!"
                                                        message: [[error userInfo] objectForKey:@"error"]
                                                 preferredStyle:UIAlertControllerStyleAlert];
            _alertOkButton = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:nil];
            
            [_alert addAction:_alertOkButton];
            [self presentViewController:_alert animated:YES completion:nil];
        }
    }];
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}
@end
