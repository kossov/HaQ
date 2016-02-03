//
//  RegisterViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/2/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>

@interface RegisterViewController () {
    UIAlertController *alert;
    UIAlertAction *alertOkButton;
    NSString *alertTitle;
    NSString *alertMessage;
    PFUser *user;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    user = [PFUser user];
    alertTitle = @"Buug!";
    alertOkButton = [UIAlertAction
                     actionWithTitle:@"OK"
                     style:UIAlertActionStyleDefault
                     handler:^(UIAlertAction * action)
                     {
                         [alert dismissViewControllerAnimated:YES completion:nil];
                         
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
        alertMessage = @"Register with at least 5 symbols for username.";
    }
    
    if (password.length < 5 && !isDirty) {
        isDirty = YES;
        alertMessage = @"Password must be with at least 5 symbols.";
    }
    
    if (confirmPassword.length < 5 && !isDirty) {
        isDirty = YES;
        alertMessage = @"Confirm password with at least 5!!1 symbols!";
    }
    
    if (password != confirmPassword && !isDirty) {
        isDirty = YES;
        alertMessage = @"Passwords don't match!";
    }
    
    if (isDirty) {
        alert = [UIAlertController alertControllerWithTitle: alertTitle
                                                    message: alertMessage
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:alertOkButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    user.username = username;
    user.password = password;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            alert = [UIAlertController alertControllerWithTitle: @"HaQuu!"
                                                        message: @"Registered successfully!"
                                                 preferredStyle:UIAlertControllerStyleAlert];

            alertOkButton = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert removeFromParentViewController];
                                 [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
                             }];
            
            [alert addAction:alertOkButton];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            alert = [UIAlertController alertControllerWithTitle: @"Whooops!"
                                                        message: @"Something bad happened! Please check your connection."
                                                 preferredStyle:UIAlertControllerStyleAlert];

            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}
@end
