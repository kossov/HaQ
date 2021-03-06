//
//  AppDelegate.m
//  HaQ
//
//  Created by Ognyan Kossov on 2/2/16.
//  Copyright © 2016 Ognyan Kossov. All rights reserved.
//

#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "DataManager.h"
#import "DataFetcher.h"
#import "Friendship.h"
#import "Item.h"
#import "Attack.h"
#import "MoneyBag.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Attack registerSubclass];
    [Friendship registerSubclass];
    [Item registerSubclass];
    [MoneyBag registerSubclass];
    
    [Parse setApplicationId:@"cm5tjPtfKoRz0TSj1xUiNMyt3zAQ7VTSfF6a2VgW" clientKey:@"FzW0YurxuShdoiFj6RICo069yPIzCBVoKXWTgCZ2"];
    [GMSServices provideAPIKey:@"AIzaSyAloq_exCmGNa2QU1Ycq1VM_D0FYfO_DRI"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application = [UIApplication sharedApplication];
    
    //create new uiBackgroundTask
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:15
                                                      target:[DataFetcher getInstance]
                                                    selector:@selector(checkForAttack)
                                                    userInfo:nil
                                                     repeats:YES];
    //and create new timer with async call:
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //run function methodRunAfterBackground
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
}

- (void)applicationWillTerminate:(UIApplication *)application {
    PFUser *user = [PFUser currentUser];
    user[@"isOnline"] = @NO;
    [user saveInBackground];
}

@end
