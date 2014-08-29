//
//  defaultAppDelegate.h
//  Parenting
//
//  Created by 爱摩信息科技 on 13-5-16.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"
#import "SummaryViewController.h"
#import "InformationCenterViewController.h"
#import "GuideViewController.h"
#import "LoginViewController.h"

#import "ACTabBarController.h"
#import "MyTabBarController.h"
#import "EnvironmentViewController.h"
#import "ActivityViewController.h"
#import "PhysiologyViewController.h"
#import "CalendarViewController.h"
#import "HomeViewController.h"
#import "CalendarController.h"

#import "BaseNavigationController.h"

@class defaultViewController;
@interface defaultAppDelegate : UIResponder <UIApplicationDelegate>
{
    ACTabBarController              *TabbarController;
    MyTabBarController              *myTabController;
    
    HomeViewController            *homeViewController;
    EnvironmentViewController       *envirViewController;
    ActivityViewController          *actViewController;
    PhysiologyViewController        *phyViewController;
    CalendarController              *calendarViewController;
    
    SettingViewController           *settingViewController;
    InformationCenterViewController *icViewController;
    SummaryViewController           *summaryViewController;
    GuideViewController             *guideViewController;
    LoginViewController             *loginViewController;
    
    BLEWeatherController            *bleweatherCtrler;
   
    BaseNavigationController          *settingNavigationViewController;
    BaseNavigationController          *adviseNavigationViewController;
    BaseNavigationController          *summaryNavigationViewController;
    BaseNavigationController          *homeNavigationViewController;
    BaseNavigationController          *icNavigationViewController;
    
    BaseNavigationController          *myPageNavigationViewController;
    BaseNavigationController          *envirNavigationViewController;
    BaseNavigationController          *actNavigationViewController;
    BaseNavigationController          *phyNavigationViewController;
    BaseNavigationController          *calendarNavigationViewController; 

}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) defaultViewController *viewController;

@end
