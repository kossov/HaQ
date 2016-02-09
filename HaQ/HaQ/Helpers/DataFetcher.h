//
//  DataUpdateProtocol.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/7/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataFetcherDelegate <NSObject>

@required
-(void) hackAttack;

@end

@interface DataFetcher : NSObject

@property BOOL isHandled;
@property (nonatomic, weak) id <DataFetcherDelegate> delegate;

+ (DataFetcher*)getInstance;

-(void)checkForAttack;

@end