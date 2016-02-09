//
//  RegisterViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/2/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "RegisterViewController.h"
#import "HelperMethods.h"
#import "GlobalConstants.h"
#import "ModelConstants.h"
#import "MoneyBag.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController {
    UIAlertController *_alert;
    PFUser *_user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UsernameTextField.delegate = self;
    self.PasswordTextField.delegate = self;
    self.PasswordConfirmTextField.delegate = self;
    
    _user = [PFUser user];
}

- (IBAction)CameraButtonAction:(id)sender {
}

- (IBAction)MediaButtonAction:(id)sender {
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            _alert = [UIAlertController alertControllerWithTitle: @"HaQuu!"
                                                         message: @"Registered successfully!"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *alertOkButton = [UIAlertAction
                                            actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
                                            }];
            
            [self addCustomFieldsToUser];
            [_alert addAction:alertOkButton];
            [self presentViewController:_alert animated:YES completion:nil];
        } else {
            _alert.title = SomethingBadHappenedTitleMessage;
            _alert.message = [HelperMethods getStringFromError:error];
            [self presentViewController:_alert animated:YES completion:nil];
        }
    }];
}

- (void)addCustomFieldsToUser {
    MoneyBag *initialBagWithMoney = [MoneyBag moneyBagWithUser:_user.username andValue:InitialMoney];
    [initialBagWithMoney saveInBackground];
    
    _user[@"isOnline"] = @NO;
    [_user saveInBackground];
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
