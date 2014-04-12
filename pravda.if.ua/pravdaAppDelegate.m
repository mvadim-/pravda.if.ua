//
//  pravdaAppDelegate.m
//  pravda.if.ua
//
//  Created by Vadim Maslov on 29.04.13.
//  Copyright (c) 2013 MDG. All rights reserved.
//

#import "pravdaAppDelegate.h"
#import "pravdaViewController.h"
#import "API.h"
#import "RSSItem.h"
#import "AFNetworkReachabilityManager.h"

@implementation pravdaAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Launched in background %d", UIApplicationStateBackground == application.applicationState);
    // Override point for customization after application launch.
    return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if ([[AFNetworkReachabilityManager sharedManager] isReachable])
    {
        [[API sharedInstance] refreshDataFromServerWithCategory:nil andOffset:nil completionBlock:^(NSArray *response, bool succeeded, NSError *error) {
            if (succeeded) {
                NSDate *lastUpdateSavedTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUpdateTime"];
                NSDate *lastUpdateTime = [(RSSItem *)[response firstObject] pubDate];
                if ([lastUpdateSavedTime compare: lastUpdateTime] != NSOrderedSame) {
                    NSLog(@"Application updated in background");
                    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
                    completionHandler(UIBackgroundFetchResultNewData);
                }else  completionHandler(UIBackgroundFetchResultNoData);
            }
        }];
    }
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return true;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
