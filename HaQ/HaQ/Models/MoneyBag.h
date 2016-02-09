//
//  MoneyBag.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/8/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface MoneyBag : PFObject<PFSubclassing>

@property NSString* username;
@property NSInteger value;

+(NSString *)parseClassName;

+(MoneyBag *) moneyBagWithUser:(NSString*)username andValue:(NSInteger) value;

@end
