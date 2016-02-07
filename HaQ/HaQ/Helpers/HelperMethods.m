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
#import "RandomNumberGenerator.h"

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

+(NSDate*)getEarliestTodaysDate {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    [components setHour:0];
    [components setMinute:1];
    [components setSecond:0];
    NSDate *morningStart = [calendar dateFromComponents:components];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strFromDate = [formatter stringFromDate:morningStart];
    return [formatter dateFromString:strFromDate];
}

// TOP LEFT: (42.722142, 23.244152)
// TOP RIGHT: (42.722142, 23.363800)
// BOTTOM RIGHT: (42.722552, 23.244152)
// BOTTOM LEFT: (42.722552, 23.363800)
+(PFGeoPoint*)getRandomLocationInSofia {
    double latitude = ((42 * 1000000.0) + [RandomNumberGenerator getRandomNumberBetween:722142 to:722552]) / 1000000;
    double longitude = ((23 * 1000000.0) + [RandomNumberGenerator getRandomNumberBetween:244152 to:363800]) / 1000000;
    return [PFGeoPoint geoPointWithLatitude:latitude longitude:longitude];
}

@end
