//
//  RegisterViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/2/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import "RegisterViewController.h"
#import "HelperMethods.h"
#import "GlobalConstants.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController {
    UIAlertController *_alert;
    PFUser *_user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [PFUser user];
}

- (IBAction)SignUpAction:(id)sender {
    NSString *username = self.UsernameTextField.text;
    NSString *password = self.PasswordTextField.text;
    NSString *confirmPassword = self.PasswordConfirmTextField.text;
    _alert = [HelperMethods validateRegister:username password:password andConfirmPass:confirmPassword];
    
    if (_alert != nil) {
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
            
            UIAlertAction *alertOkButton = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [_alert removeFromParentViewController];
                                 [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
                             }];
            
            [_alert addAction:alertOkButton];
            [self presentViewController:_alert animated:YES completion:nil];
        } else {
            NSString *errorString = [HelperMethods getStringFromError:error];
            _alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
            [self presentViewController:_alert animated:YES completion:nil];
        }
    }];
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
