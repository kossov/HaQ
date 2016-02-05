//
//  GlobalConstants.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "GlobalConstants.h"

@implementation GlobalConstants

NSInteger const UsernameMinLength = 5;
NSInteger const UsernameMaxLength = 10;

NSInteger const PasswordMinLength = 5;
NSInteger const PasswordMaxLength = 10;

NSString *const InvalidUsernameMessage = @"Username must be with at least 5 symbols.";
NSString *const InvalidPasswordMessage = @"You forgot your password! At least 5 symbols, pleeease..";
NSString *const InvalidConfirmPasswordMessage = @"Confirm password with at least 5!!1 symbols!";
NSString *const InvalidMatchPasswordsMessage = @"Passwords don't match!";

@end
