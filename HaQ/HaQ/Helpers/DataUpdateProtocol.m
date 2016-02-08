//
//  DataUpdateProtocol.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/7/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import "DataUpdateProtocol.h"
#import "DataManager.h"

@implementation FetchDataProtocol

static FetchDataProtocol *dataProtocol = nil;

+(FetchDataProtocol*)getInstance {
    if (dataProtocol == nil) {
        dataProtocol = [[FetchDataProtocol alloc] init];
    }
    
    return dataProtocol;
}

-(void)checkForAttack{
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        return;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Attack"];
    [query whereKey:@"hasEnded" equalTo:@NO];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count > 0) {
            if (self.isHandled) {
                return;
            }
            
            [DataManager getInstance].hackAttack = objects[0];
            [self.delegate hackAttack];
        }
    }];
}

@end