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

@interface HomeViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,InitBabyInfoDelegate>{
    
    __weak IBOutlet UITableView *_timeLineTableView;
    __weak IBOutlet UIScrollView *_mainScrollView;
    
    PhotoAreaView *_photoAreaView;
    MBProgressHUD *_hud;
    UIActivityIndicatorView *_activityView;
    
    NSArray* _data;
     
}



@end
