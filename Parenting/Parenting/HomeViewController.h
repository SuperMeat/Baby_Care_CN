//
//  HomeViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-25.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAreaView.h"
#import "MBProgressHUD.h"
#import "InitBabyInfoViewController.h"
#import "InitTimeLineData.h"

@interface HomeViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,InitBabyInfoDelegate>{
    
//    __weak IBOutlet UITableView *_timeLineTableView;
//    __weak IBOutlet UIScrollView *_mainScrollView;
    
    UITableView *_timeLineTableView;
    UIScrollView *_mainScrollView;
    UIView *_loginView;
    
    PhotoAreaView *_photoAreaView;
    MBProgressHUD *_hud;
    
    InitTimeLineData *_initTimeLineData;
    UIActivityIndicatorView *_activityView;
    
    NSArray* _data;
    
    int _timeLineShowCount;
    
    BOOL isPushSocialView;
}

-(void)initTimeLineData;

@end
