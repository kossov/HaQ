//
//  BackgroundAnimation.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/7/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import "BackgroundAnimation.h"

@implementation BackgroundAnimation

-(void)setBackgroundAnimationWithFrame:(CGRect)frame andView:(UIView *)view {
    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:frame];
    animatedImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"animation_1.png"], [UIImage imageNamed:@"animation_2.png"], nil];
    animatedImageView.animationDuration = 1.0f;
    animatedImageView.animationRepeatCount = -1;
    animatedImageView.frame = frame;
    [view addSubview:animatedImageView];
    [animatedImageView startAnimating];
}

@end
