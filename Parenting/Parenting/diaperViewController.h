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
@interface diaperViewController : ACViewController
{

    UIButton * startButton;
    NSTimer *timer;
    UILabel *timeLable;
    UIImageView *timerImage;
    UIImageView *timerImageView;
    UIImageView *adviseImageView;
     save_diaperview *saveView;

}
@property (strong, nonatomic)SummaryViewController *summary;
@property(strong,nonatomic)NSString *status;

+(id)shareViewController;
@end
