//
//  defaultAppDelegate.m
//  Parenting
//
//  Created by 爱摩信息科技 on 13-5-16.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "defaultAppDelegate.h"
#import "APService.h"
#import "LoginViewController.h"
#import "SyncController.h"
#import <TestinAgent/TestinAgent.h>

@implementation defaultAppDelegate

NSUncaughtExceptionHandler* _uncaughtExceptionHandler = nil;
void UncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    NSString *syserror = [NSString stringWithFormat:@"mailto://amoycaretech@gmail.com?subject=Bug Report&body=Thank you for your coordination!<br><br><br>"
                          "Crash Detail:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                          name,reason,[stackArray componentsJoinedByString:@"<br>"]];
    NSURL *url = [NSURL URLWithString:[syserror stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    return;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    application.applicationIconBadgeNumber = 0;

    // Override point for customization after application launch.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
       
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        self.window.clipsToBounds =YES;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"hastimerbefore" forKey:@"timerOnBefore"];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userreviews"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"none" forKey:@"userreviews"];
        [[NSUserDefaults standardUserDefaults] setObject:[ACDate date] forKey:@"userstartuserdate"];
    }
    
    //复制db到document才
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"ISEXISIT_BC_INFO"])
    {
        NSString *document  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *newFile = [document stringByAppendingPathComponent:@"BC_Info.sqlite"];
        NSString *oldFile = [[NSBundle mainBundle] pathForResource:@"BC_Info" ofType:@"sqlite"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        if ([fileManager copyItemAtPath:oldFile toPath:newFile error:&error]) {
             [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ISEXISIT_BC_INFO"];
        }
    }
    //FIXME:复制who数据库
    {
        NSString *document  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *newFile = [document stringByAppendingPathComponent:@"who.rdb"];
        NSString *oldFile = [[NSBundle mainBundle] pathForResource:@"who" ofType:@"rdb"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        if ([fileManager copyItemAtPath:oldFile toPath:newFile error:&error]) { 
        }

    }
    
    

    
    [self tap];
    
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"btn_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,14, 0, 8)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"btn3.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"btn3.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
     [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_title.png"]  forBarMetrics:UIBarMetricsDefault];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) {
        [[UINavigationBar appearance] setBarTintColor:[ACFunction colorWithHexString:@"0x68bfcc"]];

    }
    
    [[UINavigationBar appearance] setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    
    [[UINavigationBar appearance] setTintColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor],
                                                          UITextAttributeTextColor,
                                                          
                                                          [UIFont fontWithName:@"Arival-MTBOLD" size:20],
                                                
                                                UITextAttributeFont,
                                                          nil]];

    [self.window makeKeyAndVisible];

    _uncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);

    [MobClick startWithAppkey:UMENGAPPKEY];
    [MobClick checkUpdate];

    // Required
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    // Required
    [APService setupWithOption:launchOptions];
    
    //[APService setAlias:@"test" callbackSelector:nil object:self];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kAPNetworkDidReceiveMessageNotification object:nil];
    
//    [[NSUserDefaults standardUserDefaults] setObject:@"BLE_ENV"  forKey:@"BLE_ENV"];
//    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"BLE_ENV"] != nil)
//    {
//        bleweatherCtrler = [BLEWeatherController bleweathercontroller];
//
//    }
    
    [MAMapServices sharedServices].apiKey = AMAP_KEY;
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSLog(@"{\"oid\": \"%@\"}", deviceID);
    [MTA startWithAppkey:MTA_KEY];
    
    return YES;
}

-(void)tap
{
    summaryViewController   = [SummaryViewController summary];
     if (ISBLE) {
        envirViewController    = [[EnvironmentViewController alloc] init];
    }
    else
    {
        settingViewController = [[SettingViewController alloc] init];
    }
    myPageViewController   = [[MyPageViewController alloc] init];
    actViewController      = [[ActivityViewController alloc] init];
    phyViewController      = [[PhysiologyViewController alloc] init];
    calendarViewController = [[CalendarViewController alloc] init];
    guideViewController    = [[GuideViewController alloc] init];
    loginViewController    = [[LoginViewController alloc] init];
    
    myPageNavigationViewController   = [[UINavigationController alloc]
                                        initWithRootViewController:myPageViewController];
    if (!ISBLE) {
        settingNavigationViewController    = [[UINavigationController alloc]
                                              initWithRootViewController:settingViewController];
    }
    else
    {
        envirNavigationViewController    = [[UINavigationController alloc]
                                        initWithRootViewController:envirViewController];
    }
    actNavigationViewController      = [[UINavigationController alloc]
                                        initWithRootViewController:actViewController];
    phyNavigationViewController      = [[UINavigationController alloc]
                                        initWithRootViewController:phyViewController];
    calendarNavigationViewController = [[UINavigationController alloc]
                                        initWithRootViewController:calendarViewController];
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];

    if (!ISBLE) {
        [controllers addObject:myPageNavigationViewController];
        [controllers addObject:calendarNavigationViewController];
        [controllers addObject:actNavigationViewController];
        [controllers addObject:phyNavigationViewController];
        [controllers addObject:settingNavigationViewController];
    }
    else
    {
        [controllers addObject:myPageNavigationViewController];
        [controllers addObject:calendarNavigationViewController];
        [controllers addObject:actNavigationViewController];
        [controllers addObject:phyNavigationViewController];
        [controllers addObject:envirNavigationViewController];
    }
    
    myTabController = [[MyTabBarController alloc] init];
    [myTabController setViewControllers:controllers];
     
    
    //  向导版本有更新则跳转
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"GUIDE_V"]  isEqual: GUIDE_V]){
        guideViewController.mainViewController = myTabController;
        self.window.rootViewController = guideViewController;
        [[NSUserDefaults standardUserDefaults] setObject:GUIDE_V forKey:@"GUIDE_V"];
    }
    //  未登录账号则跳转
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ACCOUNT_NAME"] == nil){
        UINavigationController *loginNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        loginViewController.mainViewController = myTabController;
        self.window.rootViewController = loginNavigationController;
    }
    else{
        self.window.rootViewController  = myTabController;
    }
//    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"BABYID"];
    
    [self initializePlat];
    
    /*
     同步数据
     */
    [[SyncController syncController] SyncBasicContent];
}

- (void)initializePlat
{
    [TestinAgent init:TESTIN_KEY];
    
    //添加新浪微博应用
    [UMSocialData setAppKey:UMENGAPPKEY];
    
    //添加QQ分享
    [UMSocialQQHandler setQQWithAppId:@"1101701660" appKey:@"UD8B7lZmh4FwpP79" url:@"http://www.umeng.com/social"];
    
    //添加微信分享
    [UMSocialWechatHandler setWXAppId:@"wx8a04549b73aba34b" url:@"http://www.umeng.com/social"];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ACCOUNT_NAME"] != nil) {
        [[ASIController asiController] postLoginState:0];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"weather"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"weather"];
    }
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
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ACCOUNT_NAME"] != nil) {
        [[ASIController asiController] postLoginState:1];
    }
    
    application.applicationIconBadgeNumber = 0;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"weather"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"weather"];
    }
    
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ACCOUNT_NAME"] != nil) {
        [[ASIController asiController] postLoginState:-1];
    }
    
    _uncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    //return [ShareSDK handleOpenURL:url
    //                    wxDelegate:self];
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如新浪微博SDK等
    }
    return  result;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如新浪微博SDK等
    }
    return  result;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    //NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得自定义字段内容
    //NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    //NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field =[%@]",content,badge,sound,customizeField1);
    
    application.applicationIconBadgeNumber += 1;
    //当用户打开程序时候收到远程通知后执行
    if (application.applicationState == UIApplicationStateActive) {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:[NSString stringWithFormat:@"\n%@",
                                                                     [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            //hide the badge
            application.applicationIconBadgeNumber = 0;
            
        });
        
        [alertView show];
    }

    [DataBase insertNotifyMessage:content];
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
   
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    //NSString *extras = [userInfo valueForKey:@"extras"];
    //NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    [DataBase insertNotifyMessage:content];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (notification) {
        NSLog(@"didFinishLaunchingWithOptions");
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:nil message:notification.alertBody delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
