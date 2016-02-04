//
//  RandomNumberGenerator.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/4/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "RandomNumberGenerator.h"

@implementation RandomNumberGenerator

+ (int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

@end
