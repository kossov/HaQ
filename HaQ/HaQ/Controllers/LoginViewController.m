//
//  LoginViewController.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/2/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "LoginViewController.h"
#import "MainViewController.h"
#import "RegisterViewController.h"
#import "HelperMethods.h"
#import "GlobalConstants.h"

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
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 98,
                                                                      self.view.bounds.size.height / 5,
                                                                      200,
                                                                      100)];
    [logo setImage:[UIImage imageNamed:@"HaQ-logo"]];
    logo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:logo];
    
    self.UsernameTextField.delegate = self;
    self.PasswordTextField.delegate = self;
    
    // HIDE BACK BUTTON - COMMING FROM MAINVIEWCONTROLLER
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
}

- (IBAction)SignUpButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"SignUp" sender:self];
}

- (IBAction)LogInButtonAction:(id)sender {
    NSString *username = self.UsernameTextField.text;
    NSString *password = self.PasswordTextField.text;
    _alert = [HelperMethods validateLogin: username andPassword: password];
    
    if (_alert != nil) {
        [self presentViewController:_alert animated:YES completion:nil];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self MoveToMainStage];
        } else {
            NSString *errorString = [HelperMethods getStringFromError:error];
            _alert = [HelperMethods getAlert:SomethingBadHappenedTitleMessage andMessage:errorString];
            [self presentViewController:_alert animated:YES completion:nil];
        }
    }];
}

- (void)MoveToMainStage {
    [self performSegueWithIdentifier:@"LoggedIn" sender:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self.customTextField resignFirstResponder];
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
