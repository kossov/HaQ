//
//  Validator.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validator : NSObject

+ (BOOL)isValidString:(NSString*) string min:(NSInteger) min andMax:(NSInteger) max;
+ (BOOL)isUsernameValid:(NSString*)username;
+ (BOOL)isPasswordValid:(NSString*)password;
+ (BOOL)arePasswordsMatching:(NSString*)password andConfirmPassword:(NSString*)confirmPass;

@end
