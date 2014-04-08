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
    UIImageView *breastleft;
    UIImageView *breastright;
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
@property(weak,nonatomic)WeatherView *weather;
@property(weak,nonatomic)BLEWeatherView *bleweather;
@property(nonatomic,strong)NSString *obj;
+(id)shareViewController;
@end
