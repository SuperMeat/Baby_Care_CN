//
//  BaseViewController.m
//  MySafedog
//
//  Created by Will on 13-12-26.
//  Copyright (c) 2013年 will. All rights reserved.
//

#import "BaseViewController.h"
#import "UIBarButtonItem+CustomForNav.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if (kSystemVersion >= 7) {
//        self.view.bounds = CGRectMake(0, -20, self.view.width, self.view.height);
//        
//    }
    

//    self.view.backgroundColor = [UIColor lightGrayColor];
    
    NSUInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        UIBarButtonItem* backButtonItem = [UIBarButtonItem customForTarget:self image:@"item_back" title:nil action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        self.view.bounds = CGRectMake(0, 0, self.view.width, self.view.height);
        
    }
    
    //_loadingView = [[LoadingView alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        // 隐藏tabbar
//        MainController* mainVC =  (MainController*)self.tabBarController;
//        [mainVC showOrHideTabBar:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSInteger count = self.navigationController.viewControllers.count;
    if (count == 1) {
//        MainController* mainVC =  (MainController*)self.tabBarController;
//        [mainVC showOrHideTabBar:NO];
    }
}


- (void)backAction
{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSNumber* push_testReportVc = [userDef objectForKey:kPush_testReportVc];
    if ([push_testReportVc boolValue]) {
         [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)setTitle:(NSString *)title
{
    UILabel* labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [labTitle setBackgroundColor:[UIColor clearColor]];
    [labTitle setTextColor:[UIColor whiteColor]];
    [labTitle setTextAlignment:NSTextAlignmentCenter];
    [labTitle setFont:[UIFont fontWithName:kFont size:18.f]];
    [labTitle setText:title];
    [labTitle sizeToFit];
    self.navigationItem.titleView = labTitle;
}

- (void)alertView:(NSString*)text
{
    [_loadingView setType:ProgressViewTypeAlert];
    [_loadingView setText:text];
    [_loadingView show:self.view];
    
}

@end
