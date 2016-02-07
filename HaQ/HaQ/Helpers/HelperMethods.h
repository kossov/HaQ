//
//  HelperMethods.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Friendship.h"

@interface HelperMethods : NSObject

+ (UIAlertController*)validateLogin:(NSString*) username andPassword:(NSString*) password;
+ (UIAlertController*)validateRegister:(NSString*) username
                              password:(NSString*) password
                        andConfirmPass:(NSString*) confirm;
+ (UIAlertController*)getAlert:(NSString*) title andMessage:(NSString*) message;
+ (NSString*)getStringFromError:(NSError*) error;
+ (NSString*)getTargetUsername:(Friendship*) object;
+ (NSDate*)getEarliestTodaysDate;
+ (PFGeoPoint*)getRandomLocationInSofia;

@end
