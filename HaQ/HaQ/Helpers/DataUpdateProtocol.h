//
//  DataUpdateProtocol.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/7/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FetchDataProtocolDelegate <NSObject>

@required
-(void) hackAttack;

@end

@interface FetchDataProtocol : NSObject

@property BOOL isHandled;
@property (nonatomic, weak) id <FetchDataProtocolDelegate> delegate;

+ (FetchDataProtocol*)getInstance;

-(void)checkForAttack;

@end