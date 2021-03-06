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

NSInteger const ItemsPerDay = 5;

NSInteger const InitiateAttackCountInSeconds = 5;

NSInteger const InitialMoney = 3;

NSString *const InvalidUsernameMessage = @"Username must be with at least 5 symbols.";
NSString *const InvalidPasswordMessage = @"You forgot your password! At least 5 symbols, pleeease..";
NSString *const InvalidConfirmPasswordMessage = @"Confirm password with at least 5!!1 symbols!";
NSString *const InvalidMatchPasswordsMessage = @"Passwords don't match!";
NSString *const TargetContactSendMessageTitle = @"Target Contact Send!";
NSString *const TargetContactSendMessageDescription = @"Waiting for approval.. they might fear you!";
NSString *const SomethingBadHappenedTitleMessage = @"Whooops!";
NSString *const TargetContactApprovedMessageTitle = @"Target Contact Approved!";
NSString *const TargetContactApprovedMessageDescription = @"Watch out, you are vurnable too.";
NSString *const TargetContactDeclinedMessageTitle = @"Target Contact Declined!";
NSString *const TargetContactDeclinedMessageDescription = @"I bet you are better :)";
NSString *const TargetContactSuchContactAlreadyExistsMessageTitle = @"Target Contact already sent..";
NSString *const TargetContactSuchContactAlreadyExistsMessageDescription = @"It might not be accepted or still pending or existing.";
NSString *const ItemAlreadyClaimedMessageTitle = @"Someone already claimed that item!";
NSString *const ItemAlreadyClaimedMessageDescription = @"He must have been hacked and traced. Dayuumn!";
NSString *const ItemSuccessfullyClaimedMessageTitle = @"Item claimed!";
NSString *const ItemSuccessfullyClaimedMessageDescription = @"#MUSTBENICE";
NSString *const UserIsBusyOrNotAccesableMessageTitle = @"Sorry..";
NSString *const UserIsBusyOrNotAccesableMessageDescription = @"Can't be Hacked right now..(others might hack him also)";

NSString *const AttackerGuessedSuccessfullyMessageTitle = @"Noice!";
NSString *const AttackerGuessedSuccessfullyMessageDescription = @"You guessed successfully! You Receive a Money in the Bag!";
NSString *const AttackerGuessedNotSuccessfullyMessageTitle = @"Sorry..";
NSString *const AttackerGuessedNotSuccessfullyMessageDescription = @"You did not guessed correctly, they will hack you.. pretty soon..";
NSString *const HackedSuccessfullyMessageTitle = @"Congratz!";
NSString *const HackedSuccessfullyMessageDescription = @"No one even noticed! You get them money!";
NSString *const HackTimeOutMessageTitle = @"Run man!";
NSString *const HackTimeOutMessageDescription = @"Lets hope they don't find you, because you will loose that Bag.";

NSString *const HackedLostMoneyMessageTitle = @"Sorry!!";
NSString *const HackedLostMoneyMessageDescription = @"You have been hacked, before you respond.";

NSString *const HackFailedUserBustedMessageTitle = @"Oops, Busted!";
NSString *const HackFailedUserBustedMessageDescription = @"They found you before you hack them..";

@end
