//
//  diaperViewController.h
//  Parenting
//
//  Created by user on 13-5-23.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryViewController.h"
@class save_diaperview;
@interface diaperViewController : ACViewController<save_diaperviewDelegate>
{

    UIButton * startButton;
    NSTimer *timer;
    UILabel *timeLable;
    UIImageView *timerImage;
    UIImageView *timerImageView;
    UIImageView *adviseImageView;
     save_diaperview *saveView;
    UIImageView *historyView;
    UIImageView *todayCountView;
    UIImageView *XuXuStatusView;
    UIImageView *BaBaStatusView;
    UIImageView *XuXuBaBaStatusView;
    UILabel *todayCount;
    UILabel *todayXuXu;
    UILabel *todayBaBa;
    UILabel *todayXuXuBaBa;
    UILabel *cutXuXu;
    UILabel *cutBaBa;
    UILabel *cutXuXuBaBa;
    AdviseScrollview *ad;
    
}
@property (strong, nonatomic)SummaryViewController *summary;
@property(strong,nonatomic)NSString *status;

+(id)shareViewController;
@end
