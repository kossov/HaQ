//
//  LoginViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/2/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController () {
    UIAlertController *alert;
    UIAlertAction *alertOkButton;
    NSString *alertTitle;
    NSString *alertMessage;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    alertTitle = @"Hacking? Not us!";
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

- (IBAction)LogInButtonAction:(id)sender {
    NSString *username = self.UsernameTextField.text;
    NSString *password = self.PasswordTextField.text;
    BOOL isDirty = NO;
    
    if (username.length < 5) {
        isDirty = YES;
        alertMessage = @"Enter your username with at least 5 symbols.";
    }
    
    if (password.length < 5 && !isDirty) {
        isDirty = YES;
        alertMessage = @"You forgot your password! At least 5 symbols, pleeease..";
    }
    
    if (isDirty) {
        alert = [UIAlertController alertControllerWithTitle: alertTitle
                                                    message: alertMessage
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:alertOkButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    // START LOADING SCREEN
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            // STOP LOADING SCREEN
            [self performSegueWithIdentifier:@"userLoggedIn" sender:self];
        } else {
            // ERROR MESSAGE
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            alert = [UIAlertController alertControllerWithTitle: @"Whooops!"
                                                        message: errorString
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:alertOkButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}
@end
