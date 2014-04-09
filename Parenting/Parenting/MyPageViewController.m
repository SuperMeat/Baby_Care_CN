//
//  MyPageViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-19.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "MyPageViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"

#import "HomeTopView.h"

@interface MyPageViewController ()

@end

@implementation MyPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"首页"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated    {
    [MobClick beginLogPageView:@"首页"];
    
    //跳转至创建宝宝宝宝
    if (!BABYID) {
//        BabyinfoViewController *bi=[[BabyinfoViewController alloc]initWithNibName:@"BabyinfoViewController" bundle:nil];
//        [self.navigationController pushViewController:bi animated:YES];
    }
    
    //创建子视图
    [self initView];
    //加载数据
    [self LoadData];
}

#pragma 加载视图
-(void)initView{
    //加载头像区视图
    HomeTopView *homeTopView = [[HomeTopView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    [self.view addSubview:homeTopView];
    
    //加载时间轴区视图
}

#pragma 加载数据
-(void)LoadData{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
