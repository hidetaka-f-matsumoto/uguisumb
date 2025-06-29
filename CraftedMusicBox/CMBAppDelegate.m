//
//  CMBAppDelegate.m
//  CraftedMusicBox
//
//  Created by hide on 2014/06/22.
//  Copyright (c) 2014年 hidetaka.f.matsumoto. All rights reserved.
//

@import Firebase;
#import "CMBAppDelegate.h"
#import "CMBUtility.h"
#import "CMBSoundManager.h"

@implementation CMBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FIRApp configure];
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    // Push 通知
    UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    // SoundManager 初期化
    [CMBSoundManager sharedInstance];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    // バッジを消す
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    // 通知
    [[NSNotificationCenter defaultCenter] postNotificationName:CMBNotifyAppDidEnterBackground
                                                        object:nil
                                                      userInfo:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    // 通知
    [[NSNotificationCenter defaultCenter] postNotificationName:CMBNotifyAppWillTerminate
                                                        object:nil
                                                      userInfo:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL isOpenable = NO;
    if ([[url scheme] isEqualToString:CMBURLScheme]) {
        [[CMBUtility sharedInstance] openURL:url];
        isOpenable = YES;
    }
    return isOpenable;
}
@end
