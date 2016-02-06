//
//  HelperMethods.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import "HelperMethods.h"
#import "Validator.h"
#import "GlobalConstants.h"
#import "Friendship.h"

@implementation HelperMethods

+ (UIAlertController*)validateLogin:(NSString*) username andPassword:(NSString*) password {
    UIAlertController *alert = nil;
    NSString *alertTitle = @"Hacking? Not us!";
    BOOL isUsernameValid = [Validator isUsernameValid:username];
    BOOL isPasswordValid = [Validator isPasswordValid:password];
    
    if (!isUsernameValid) {
        return alert = [self getAlert:alertTitle andMessage:InvalidUsernameMessage];
    }
    
    if (!isPasswordValid) {
        alert = [self getAlert:alertTitle andMessage:InvalidPasswordMessage];
        
    }
    
    return alert;
}

+ (UIAlertController*)validateRegister:(NSString*) username
                              password:(NSString*) password
                        andConfirmPass:(NSString*) confirm {
    UIAlertController *alert = nil;
    NSString *alertTitle = @"Hacking? Not us!";
    BOOL isUsernameValid = [Validator isUsernameValid:username];
    BOOL isPasswordValid = [Validator isPasswordValid:password];
    BOOL isConfirmPasswordValid = [Validator isPasswordValid:confirm];
    BOOL arePasswordsMatching = [Validator arePasswordsMatching:password andConfirmPassword:confirm];
    
    if (!isUsernameValid) {
        return alert = [self getAlert:alertTitle andMessage:InvalidUsernameMessage];
    }
    
    if (!isPasswordValid) {
        return alert = [self getAlert:alertTitle andMessage:InvalidPasswordMessage];
    }
    
    if (!isConfirmPasswordValid) {
        return alert = [self getAlert:alertTitle andMessage:InvalidConfirmPasswordMessage];
    }
    
    if (!arePasswordsMatching) {
        alert = [self getAlert:alertTitle andMessage:InvalidMatchPasswordsMessage];
    }
    
    return alert;
}

+ (UIAlertController*)getAlert:(NSString*) title andMessage:(NSString*) message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title
                                                                   message: message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertOkButton = [self getAlertButton:alert];
    [alert addAction:alertOkButton];
    
    return alert;
}

+ (UIAlertAction*)getAlertButton:(UIAlertController*) alert {
    return [UIAlertAction
            actionWithTitle:@"OK"
            style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action)
            {
                [alert dismissViewControllerAnimated:YES completion:nil];
                
            }];
}

+ (NSString*)getStringFromError:(NSError *)error {
    return [[error userInfo] objectForKey:@"error"];
}

+(NSString*)getTargetUsername:(Friendship*) object {
    NSString *username;
    if ([PFUser currentUser].username == object.byUser) {
        username = object.toUser;
    } else {
        username = object.byUser;
    }
    
    return username;
}

@end
