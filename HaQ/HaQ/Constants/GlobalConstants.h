//
//  GlobalConstants.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/5/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalConstants : NSObject

extern NSInteger const UsernameMinLength;
extern NSInteger const UsernameMaxLength;

extern NSInteger const PasswordMinLength;
extern NSInteger const PasswordMaxLength;

extern NSString *const InvalidUsernameMessage;
extern NSString *const InvalidPasswordMessage;
extern NSString *const InvalidConfirmPasswordMessage;
extern NSString *const InvalidMatchPasswordsMessage;
extern NSString *const TargetContactSendMessageTitle;
extern NSString *const TargetContactSendMessageDescription;
extern NSString *const SomethingBadHappenedTitleMessage;
extern NSString *const TargetContactApprovedMessageTitle;
extern NSString *const TargetContactApprovedMessageDescription;
extern NSString *const TargetContactDeclinedMessageTitle;
extern NSString *const TargetContactDeclinedMessageDescription;

@end
