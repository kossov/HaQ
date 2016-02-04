//
//  LoginViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/2/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface LoginViewController () {
    UIAlertController *_alert;
    UIAlertAction *_alertOkButton;
    NSString *_alertTitle;
    NSString *_alertMessage;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // HIDE BACK BUTTON - COMMING FROM MAINVIEWCONTROLLER
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
    
    _alertTitle = @"Hacking? Not us!";
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

- (IBAction)LogInButtonAction:(id)sender {
    NSString *username = self.UsernameTextField.text;
    NSString *password = self.PasswordTextField.text;
    BOOL isDirty = NO;
    //    KeychainItemWrapper *keychain =
    //    [[KeychainItemWrapper alloc] initWithIdentifier:@"TestAppLoginData" accessGroup:nil];
    if (username.length < 5) {
        isDirty = YES;
        _alertMessage = @"Enter your username with at least 5 symbols.";
    }
    
    if (password.length < 5 && !isDirty) {
        isDirty = YES;
        _alertMessage = @"You forgot your password! At least 5 symbols, pleeease..";
    }
    
    if (isDirty) {
        _alert = [UIAlertController alertControllerWithTitle: _alertTitle
                                                     message: _alertMessage
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [_alert addAction:_alertOkButton];
        [self presentViewController:_alert animated:YES completion:nil];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self MoveToMainStage];
        } else {
            // ERROR MESSAGE
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            _alert = [UIAlertController alertControllerWithTitle: @"Whooops!"
                                                         message: errorString
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            [_alert addAction:_alertOkButton];
            [self presentViewController:_alert animated:YES completion:nil];
        }
    }];
}

- (void)MoveToMainStage {
    [self performSegueWithIdentifier:@"LoggedIn" sender:self];
}

- (IBAction)SignUpButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"SignUp" sender:self];
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField{
    [textField resignFirstResponder];
    return YES;
}
@end
