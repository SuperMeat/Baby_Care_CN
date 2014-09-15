//
//  InitTimeLineData.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-25.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyMessageDataDB.h"
#import "HomeViewController.h"

@interface InitTimeLineData : NSObject{
    BabyMessageDataDB *baby;
    MBProgressHUD *_hud;
}

@property (weak, nonatomic) UIViewController *targetViewController;

+(id)initTimeLineData;
-(void)getTimeLineData;//获取时间轴数据
 
-(void)checkSysMsg;
-(void)checkTips:(long)date;
@end
