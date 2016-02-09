//
//  StatusItemView.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/7/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "StatusItemView.h"

@implementation StatusItemView

- (void)drawRect:(CGRect)rect {
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width / 2 - 98, 0, 200, 100)];
    [image setImage:[UIImage imageNamed:@"status_money_bag"]];
    image.backgroundColor = [UIColor clearColor];
    [self addSubview:image];
    
    UILabel *bagsCount = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 12, rect.size.height/2 - 15, rect.size.width,30)];
    bagsCount.text = self.bagsCount;
    bagsCount.backgroundColor = [UIColor clearColor];
    bagsCount.font = [bagsCount.font fontWithSize:45];
    bagsCount.textColor = [UIColor redColor];
    [self addSubview:bagsCount];
}

@end
