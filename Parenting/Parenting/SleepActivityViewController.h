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
@interface SleepActivityViewController : ACViewController
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
}
@property (strong, nonatomic)SummaryViewController *summary;
+(id)shareViewController;
@end

