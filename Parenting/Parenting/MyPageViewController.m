//
//  MyPageViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-19.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "MyPageViewController.h"
#import "LoginViewController.h"

#import "HomeTopView.h"
#import "TimeLineView.h"
#import "BabyDataDB.h"
#import "UserDataDB.h"
#import "NetWorkConnect.h"
#import "DataContract.h"

@interface MyPageViewController ()

@end

@implementation MyPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        [self setTitle:@"首页"];
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
    
    //检测or创建宝贝
    [self checkBaby];
    //创建子视图
    [self initView];
    //加载数据
    [self LoadData];
}

#pragma 检测or创建宝贝
-(void)checkBaby{
    if (ACCOUNTUID) {
        if (!BABYID) {
            //注册接口
            hud = [MBProgressHUD showHUDAddedTo:guideView animated:YES];
            //隐藏键盘
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.alpha = 0.5;
            hud.color = [UIColor grayColor];
            hud.labelText = http_requesting;
            //封装数据
            NSMutableDictionary *dictBody = [[DataContract dataContract]BabyCreateByUserIdDict:ACCOUNTUID];
            //Http请求
            [[NetWorkConnect sharedRequest]
             httpRequestWithURL:BABY_CREATEBYUSERID_URL
             data:dictBody
             mode:@"POST"
             HUD:hud
             didFinishBlock:^(NSDictionary *result){
                 hud.labelText = [result objectForKey:@"msg"];
                 //处理反馈信息: code=1为成功  code=99为失败
                 if ([[result objectForKey:@"code"]intValue] == 1) {
                     NSMutableDictionary *resultBody = [result objectForKey:@"body"];
                     //保存Babyid
                     [[NSUserDefaults standardUserDefaults]setObject:[resultBody objectForKey:@"babyId"] forKey:@"BABYID"];
                     //数据库保存Baby信息
                     [BabyDataDB createNewBabyInfo:ACCOUNTUID BabyId:BABYID Nickname:@"" Birthday:nil Sex:nil HeadPhoto:@"" RelationShip:@"" RelationShipNickName:@"" Permission:nil CreateTime:[resultBody objectForKey:@"create_time"] UpdateTime:nil];
                     
                     [hud hide:YES afterDelay:0.5];
                 }
                 else{
                     hud.labelText = http_error;
                     [hud hide:YES afterDelay:1];
                 }
             }
             didFailBlock:^(NSString *error){
                 //请求失败处理
                 hud.labelText = http_error;
                 [hud hide:YES afterDelay:1];
             }
             isShowProgress:YES
             isAsynchronic:YES
             netWorkStatus:YES
             viewController:self];
        }
    }
}

#pragma 加载视图
-(void)initView{
    //加载头像区视图
    HomeTopView *homeTopView = [[HomeTopView alloc]initWithFrame:CGRectMake(0, -10, self.view.bounds.size.width, 200)];
    [self.view addSubview:homeTopView];
    
    //加载时间轴区视图
    TimeLineView *timeLineView = [[TimeLineView alloc]initWithFrame:
     CGRectMake(0,
                homeTopView.frame.size.height + homeTopView.frame.origin.y,
                self.view.bounds.size.width,
                self.view.bounds.size.height - homeTopView.frame.size.height- 49 +10)];
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
