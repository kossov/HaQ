//
//  DataUpdateProtocol.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/7/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import "DataUpdateProtocol.h"

@implementation DataUpdateProtocol

static DataUpdateProtocol *dataProtocol = nil;

+(DataUpdateProtocol*)getInstance {
    if (dataProtocol == nil) {
        dataProtocol = [[DataUpdateProtocol alloc] init];
    }
    
    return dataProtocol;
}

-(void)fetchData{
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        return;
    }
    
    
    [self.delegate newDataFetched];
}

@end