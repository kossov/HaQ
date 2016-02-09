//
//  MoneyBag.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/8/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "MoneyBag.h"
#import "ModelConstants.h"

@implementation MoneyBag

@dynamic username;
@dynamic value;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"MoneyBag";
}

+(MoneyBag *) moneyBagWithUser:(NSString*)username andValue:(NSInteger) value {
    MoneyBag *moneyBag = [MoneyBag object];
    moneyBag.username = username;
    moneyBag.value = value;
    
    return moneyBag;
}

@end
