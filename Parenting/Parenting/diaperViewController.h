//
//  diaperViewController.h
//  Parenting
//
//  Created by user on 13-5-23.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryViewController.h"
@class WeatherView;
@class save_diaperview;
@interface diaperViewController : UIViewController
{

    UIButton * startButton;
    NSTimer *timer;
    UILabel *timeLable;
     save_diaperview *saveView;

}
@property (strong, nonatomic)SummaryViewController *summary;
@property(weak,nonatomic)WeatherView *weather;
@property(strong,nonatomic)NSString *status;

+(id)shareViewController;
@end
