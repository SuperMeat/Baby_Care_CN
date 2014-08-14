//
//  MainController.m
//  BabyCalendar
//
//  Created by Will on 14-5-18.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "MainController.h"
#import "HomeController.h"
#import "CalendarController.h"
#import "EnvironmentController.h"
#import "PhysiologicalController.h"
#import "ActivityController.h"
#import "BaseNavigationController.h"
@interface MainController ()

@end

@implementation MainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _initControllers];
    
    [self _initTabBar];
}

- (void)_initTabBar
{
    
    // tabBar 背景
    _bgTabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
    [_bgTabBarView setImage:[UIImage imageNamed:@"tab_bg_all"]];
    [_bgTabBarView setUserInteractionEnabled:YES];
    [self.view addSubview:_bgTabBarView];
    
    // 选中视图
    _selectView = [[UIImageView alloc] initWithFrame:CGRectMake(5, _bgTabBarView.height/2.0-45.0/2, 50, 45)];
    [_selectView setImage:[UIImage imageNamed:@"selectTabbar_bg_all1"]];
    [_bgTabBarView addSubview:_selectView];
    
    
    NSArray* images = @[@"movie_home",@"msg_new",@"start_top250",@"icon_cinema",@"more_setting"];
    NSArray *titles = @[@"首页", @"活动", @"生理", @"环境", @"日历"];
    int x = 0;
    for (int index = 0; index < 5; index++) {
        
        ItemView *itemView = [[ItemView alloc] initWithFrame:CGRectMake(5+x, _bgTabBarView.height/2.0-45.0/2, 50, 45)];
        itemView.tag = index;
        itemView.delegate = self; // 设置委托
        itemView.item.image = [UIImage imageNamed:images[index]];
        itemView.title.text = titles[index];
        [_bgTabBarView addSubview:itemView];

        
        x += 65;
    }
    
    
}
- (void)_initControllers
{
//    // 首页
//    HomeController* homeVc = [[HomeController alloc] init];
//    BaseNavigationController* homeNav = [[BaseNavigationController alloc] initWithRootViewController:homeVc];
//
//    
//    // 活动
//    ActivityController* actiVc = [[ActivityController alloc] init];
//    BaseNavigationController* actiNav = [[BaseNavigationController alloc] initWithRootViewController:actiVc];
//
//    // 生理
//    PhysiologicalController* phyVc = [[PhysiologicalController alloc] init];
//    BaseNavigationController* phyNav = [[BaseNavigationController alloc] initWithRootViewController:phyVc];
//
//    // 环境
//    EnvironmentController* enviVc = [[EnvironmentController alloc] init];
//    BaseNavigationController* enviNav = [[BaseNavigationController alloc] initWithRootViewController:enviVc];

    // 日历
    CalendarController* calenVc = [[CalendarController alloc] init];
    BaseNavigationController* calenNav = [[BaseNavigationController alloc] initWithRootViewController:calenVc];

    
    self.viewControllers = @[homeNav,actiNav,phyNav,enviNav,calenNav];
    
    
}
int _lastIndex = 0;
- (void)changeViewController:(NSInteger)index
{
    // 获取到位置信息，如果点击到了第四个Item，并且_moreView视图存在，location的值应该为上一次的值
    NSInteger location = index;
    
    self.selectedIndex = location;
    [UIView beginAnimations:nil context:NULL];
    _selectView.frame = CGRectMake(5 + location*65, _bgTabBarView.height/2.0-45.0/2, 50, 45);
    [UIView commitAnimations];
    
//    // 记录上一次tag
//    _lastIndex = (index == 4)? _lastIndex:index;
    
}

// 显示或隐藏tabbar
- (void)showOrHideTabBar:(BOOL)isHidden
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.33];
    if (isHidden) {
        [_bgTabBarView setFrame:CGRectMake(-320,kDeviceHeight-49, kDeviceWidth, 49)];
    }else
        [_bgTabBarView setFrame:CGRectMake(0, kDeviceHeight-49, kDeviceWidth, 49)];
    
    [UIView commitAnimations];
    
}
#pragma mark - ItemViewDelegate
- (void)didItemView:(ItemView *)itemView atIndex:(NSInteger)index
{
    [self changeViewController:index];
    
}
@end
