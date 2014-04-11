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

@interface FeedActivityViewController : ACViewController
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
    
    
}
@property(nonatomic,strong)NSString *activity;
@property(nonatomic,strong)NSString *feedWay;
@property(nonatomic,strong)NSString *breast;
@property (strong, nonatomic)SummaryViewController *summary;
@property(nonatomic,strong)NSString *obj;
+(id)shareViewController;
@end
