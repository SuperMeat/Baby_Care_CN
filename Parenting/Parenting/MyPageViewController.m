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
        // Custom initialization
        [self setTitle:@"首页"];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated    {
    [MobClick beginLogPageView:@"首页"];
    
    [self LoadData];
    
    //FIXME:是否有创建过宝宝
//    if (!BABYID) {
//        BabyinfoViewController *bi=[[BabyinfoViewController alloc]initWithNibName:@"BabyinfoViewController" bundle:nil];
//        [self.navigationController pushViewController:bi animated:YES];
//    }
}

-(void)LoadData{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    
}

#pragma 加载视图
-(void)initView{
    //加载头像区视图
    HomeTopView *homeTopView = [[HomeTopView alloc]initWithFrame:CGRectMake(0, 0, 320, 235)];
    [self.view addSubview:homeTopView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
