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

extern NSInteger const ItemsPerDay;

extern NSInteger const InitiateAttackCountInSeconds;

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
extern NSString *const TargetContactSuchContactAlreadyExistsMessageTitle;
extern NSString *const TargetContactSuchContactAlreadyExistsMessageDescription;
extern NSString *const ItemAlreadyClaimedMessageTitle;
extern NSString *const ItemAlreadyClaimedMessageDescription;
extern NSString *const ItemSuccessfullyClaimedMessageTitle;
extern NSString *const ItemSuccessfullyClaimedMessageDescription;
extern NSString *const UserIsBusyOrNotAccesableMessageTitle;
extern NSString *const UserIsBusyOrNotAccesableMessageDescription;

extern NSString *const AttackerGuessedSuccessfullyMessageTitle;
extern NSString *const AttackerGuessedSuccessfullyMessageDescription;
extern NSString *const AttackerGuessedNotSuccessfullyMessageTitle;
extern NSString *const AttackerGuessedNotSuccessfullyMessageDescription;

@end
