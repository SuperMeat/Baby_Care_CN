//
//  MyTabBarController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-18.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController
@synthesize currentSelectedIndex=_currentSelectedIndex,buttons,lable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initResourece];
    }
    return self;
}

- (void)initResourece
{
    [self setBtnImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"首页@2x.png"],[UIImage imageNamed:@"环境@2x.png"],[UIImage imageNamed:@"活动@2x.png"],[UIImage imageNamed:@"生理@2x.png"],[UIImage imageNamed:@"日历@2x.png"], nil]];
    [self setBtnHLightImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"首页_按@2x.png"],[UIImage imageNamed:@"环境_按@2x.png"],[UIImage imageNamed:@"活动_按@2x.png"],[UIImage imageNamed:@"生理_按@2x.png"], [UIImage imageNamed:@"日历_按@2x.png"],nil]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
