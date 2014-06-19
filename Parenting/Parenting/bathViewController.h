//
//  bathViewController.h
//  Parenting
//
//  Created by user on 13-5-23.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryViewController.h"
@class save_bathview;
@interface bathViewController : ACViewController
{

    UIButton * startButton;
    UIButton * addRecordBtn;
    NSTimer *timer;
    UILabel *timeLable;
    UIImageView *timerImage;
    UIImageView *timerImageView;
    UIImageView *adviseImageView;
    save_bathview *saveView;
    UILabel *labletip;
    AdviseScrollview *ad;
}
@property (strong, nonatomic)SummaryViewController *summary;
+(id)shareViewController;
@end
