//
//  DataUpdateProtocol.h
//  HaQ
//
//  Created by Ognyan Kossov on 2/7/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataUpdateProtocolDelegate <NSObject>

@required
-(void) newDataFetched;

@end

@interface DataUpdateProtocol : NSObject


@property (nonatomic, weak) id <DataUpdateProtocolDelegate> delegate;

+ (DataUpdateProtocol*)getInstance;

-(void)fetchData;

@end