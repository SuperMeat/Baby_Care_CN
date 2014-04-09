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
#import "TimeLineView.h"
#import "BabyDataDB.h"
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
    self.navigationController.navigationBarHidden = YES;
    
    //创建子视图
    [self initView];
    //加载数据
    [self LoadData];
    //未创建宝宝
    [self initGuideView];
}

#pragma 未创建宝宝引导遮盖视图
-(void)initGuideView{
    UIView *guideView = [[UIView alloc]initWithFrame:
                         CGRectMake(0,
                                    0,
                                    320,
                                    568)];
    guideView.alpha = 0.8;
    guideView.backgroundColor = [UIColor blackColor];
    
    UIButton *buttonGuide = [[UIButton alloc]init];
    UILabel * labelGuide = [[UILabel alloc]init];
    labelGuide.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    labelGuide.textColor = [UIColor whiteColor];
    labelGuide.textAlignment = CPTTextAlignmentCenter;
//    UIImageView *imageArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"提示箭头"]];
    
    if (!BABYID) {
        //提示加载头像
        UIImage *imageHeadBG = [UIImage imageNamed:@"114.png"];
        [buttonGuide setImage:imageHeadBG forState:UIControlStateNormal];
        buttonGuide.frame = CGRectMake(102.5, 46.5, 114, 114);
        buttonGuide.layer.masksToBounds = YES;
        buttonGuide.layer.cornerRadius = 57;
        buttonGuide.alpha = 1;
        
        labelGuide.text = @"请选择宝宝照片";
        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI*-0.16);
        [labelGuide setTransform:rotation];
        labelGuide.frame = CGRectMake(35,40,140,20);
        
        [guideView addSubview:buttonGuide];
        [guideView addSubview:labelGuide];
        [self.navigationController.parentViewController.view addSubview:guideView];
    }
    else{
        NSDictionary *babyDict = [[BabyDataDB babyinfoDB]selectBabyInfoByBabyId:BABYID];
        if ([[[babyDict objectForKey:@"icon"] stringValue]  isEqual: @""]) {
            //处理头像
        }
        if ([[[babyDict objectForKey:@"nickname"] stringValue]  isEqual: @""]) {
            //处理宝贝名
        }
        if ([[[babyDict objectForKey:@"birth"] stringValue]  isEqual: @""]) {
            //处理生日
        }
        [self.navigationController.parentViewController.view addSubview:guideView];
    }
    
}

#pragma 加载视图
-(void)initView{
    //加载头像区视图
    HomeTopView *homeTopView = [[HomeTopView alloc]initWithFrame:CGRectMake(0, -10, self.view.bounds.size.width, 200)];
    [self.view addSubview:homeTopView];
    
    //加载时间轴区视图
    TimeLineView *timeLineView =
    [[TimeLineView alloc]initWithFrame:
     CGRectMake(0,
                homeTopView.frame.size.height + homeTopView.frame.origin.y,
                self.view.bounds.size.width,
                self.view.bounds.size.height - (homeTopView.frame.size.height + homeTopView.frame.origin.y))];
    [self.view addSubview:timeLineView];
}

#pragma 加载数据
-(void)LoadData{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
