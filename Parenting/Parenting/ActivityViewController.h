//
//  ActivityViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-31.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "ACViewController.h"
#import "feedViewController.h"
#import "SleepActivityViewController.h"
#import "diaperViewController.h"
#import "bathViewController.h"
#import "playViewController.h"
#import "FeedActivityViewController.h"

@interface ActivityViewController : ACViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{
    NSTimer *timer;
    NSTimer *tipTimer;
    UITableView *datatable;
    NSArray *dataArray;
    UILabel *labelText;
    UILabel *timeTip;
    UIImageView *statusImageView;
    NSInteger timerOnType;
}

@property (strong, nonatomic) UIImageView *activityImageView;
@property (strong, nonatomic) UIButton *btnFeed;
@property (strong, nonatomic) UIButton *btnBath;
@property (strong, nonatomic) UIButton *btnPlay;
@property (strong, nonatomic) UIButton *btnSleep;
@property (strong, nonatomic) UIButton *btnDiaper;
@property (strong, nonatomic) UIButton *btnSummary;
@property (strong, nonatomic) UIButton *btnAdvise;

@end
