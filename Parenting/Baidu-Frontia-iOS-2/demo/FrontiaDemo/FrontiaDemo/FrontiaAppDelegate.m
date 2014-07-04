//
//  FrontiaAppDelegate.m
//  frontiaDemo
//
//  Copyright (c) 2013 Baidu. All rights reserved.
//
#import <Frontia/FrontiaPush.h>
#import <Frontia/Frontia.h>
#import "FrontiaAppDelegate.h"

#define APP_KEY @"iG2ffdkYaq8kIjrSfvjMcUrf"
#define REPORT_ID @"d5dd317228"

#define IosAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@implementation FrontiaAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化Frontia
    [Frontia initWithApiKey:APP_KEY];
    
    [Frontia getPush];
    [FrontiaPush setupChannel:launchOptions];

    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];
    
    
    FrontiaStatistics* statTracker = [Frontia getStatistics];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
    statTracker.channelId = @"this_is_a_invalid_channel_ID";//设置您的app的发布渠道
    statTracker.logStrategy = FrontiaStatLogStrategyCustom;//根据开发者设定的时间间隔接口发送 也可以使用启动时发送策略
    statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时
    statTracker.logSendWifiOnly = YES; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 60;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    statTracker.shortAppVersion  = IosAppVersion; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [statTracker startWithReportId:REPORT_ID];//设置您在mtj网站上添加的app的appkey
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"frontia application:%@", deviceToken);
    [FrontiaPush registerDeviceToken: deviceToken];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"frontia application:%@", error);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"frontia applciation receive Notify: %@", [userInfo description]);
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Did receive a Remote Notification"
                                                            message:[NSString stringWithFormat:@"The application received this remote notification while it was running:\n%@", alert]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    [application setApplicationIconBadgeNumber:0];
    
    [FrontiaPush handleNotification:userInfo];

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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    FrontiaShare *share = [Frontia getShare];
    return [share handleOpenURL:url];
}

@end
