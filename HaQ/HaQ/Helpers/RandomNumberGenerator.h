//
//  RandomNumberGenerator.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/4/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomNumberGenerator : NSObject

+ (int)getRandomNumberBetween:(int)from to:(int)to;

@end
