//
//  SleepActivityViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-4-9.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "ACViewController.h"

#import <UIKit/UIKit.h>
#import "SummaryViewController.h"
@class save_sleepview;
@interface SleepActivityViewController : ACViewController<save_sleepviewDelegate>
{
    
    UIButton * startButton;
    UIButton * addRecordBtn;
    NSTimer *timer;
    UILabel *timeLable;
    save_sleepview *saveView;
    UIImageView *timerImage;
    UIImageView *timerImageView;
    UIImageView *adviseImageView;
    UILabel *labletip;
    
    UIImageView *historyView;
    
    UILabel *averagesleepweeklabel;
    UILabel *averagesleepmonthlabel;
    UILabel *maxsleepweeklabel;
    UILabel *maxsleepmonthlabel;
    
    UILabel *averagesleepweekamount;
    UILabel *averagesleepmonthamount;
    UILabel *maxsleepweekamount;
    UILabel *maxsleepmonthamount;
    
    UIImageView *averagesleepweekstatusImageView;
    UIImageView *averagesleepmonthstatusImageView;
    UIImageView *maxsleepweekstatusImageView;
    UIImageView *maxsleepmonthstatusImageView;
    
    UILabel *cutaveragesleepweek;
    UILabel *cutaveragesleepmonth;
    UILabel *cutmaxsleepweek;
    UILabel *cutmaxsleepmonth;
}
@property (strong, nonatomic)SummaryViewController *summary;
+(id)shareViewController;
@end

