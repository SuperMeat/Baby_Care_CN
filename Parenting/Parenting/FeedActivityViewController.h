//
//  FeedActivityViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-4-7.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ACViewController.h"
#import "SummaryViewController.h"
#import "save_feedview.h"

@interface FeedActivityViewController : ACViewController<save_feedviewDelegate>
{
    UIButton * startButton;
    UIButton * startButtonleft;
    UIButton * startButtonright;
    UIButton * addRecordBtn;
    UIButton * chooseBreast;
    UIButton * chooseBottle;
    
    UIImageView *timerImage;
    UIImageView *timerImageView;
    UIImageView *adviseImageView;

    NSTimer *timer;
    UILabel *timeLable;
    UILabel *pmintro;
    save_feedview *saveView;
    UILabel *labletip;
    
    UIImageView *historyView;
    
    UILabel *breastweeklabel;
    UILabel *breastmonthlabel;
    UILabel *milkweeklabel;
    UILabel *milkmonthlabel;
    
    UILabel *breastweekamount;
    UILabel *breastmonthamount;
    UILabel *milkweekamount;
    UILabel *milkmonthamount;
    
    UIImageView *breastweekstatusImageView;
    UIImageView *breastmonthstatusImageView;
    UIImageView *milkweekstatusImageView;
    UIImageView *milkmonthstatusImageView;
    
    UILabel *cutbreastweek;
    UILabel *cutbreastmonth;
    UILabel *cutmilkweek;
    UILabel *cutmilkmonth;
    
}
@property(nonatomic,strong)NSString *activity;
@property(nonatomic,strong)NSString *feedWay;
@property(nonatomic,strong)NSString *breast;
@property (strong, nonatomic)SummaryViewController *summary;
@property(nonatomic,strong)NSString *obj;
+(id)shareViewController;
@end
