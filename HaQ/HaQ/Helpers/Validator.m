//
//  Validator.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "Validator.h"
#import "GlobalConstants.h"

@implementation Validator

+ (BOOL)isValidString:(NSString*) string min:(NSInteger) min andMax:(NSInteger) max {
    return min <= string.length && string.length <= max;
}

+ (BOOL)isUsernameValid:(NSString*)username {
    return [self isValidString:username min:UsernameMinLength andMax:UsernameMaxLength];
}

+ (BOOL)isPasswordValid:(NSString*)password {
    return [self isValidString:password min:PasswordMinLength andMax:PasswordMaxLength];
}

+ (BOOL)arePasswordsMatching:(NSString*)password andConfirmPassword:(NSString*)confirmPass {
    return password == confirmPass;
}

@end
