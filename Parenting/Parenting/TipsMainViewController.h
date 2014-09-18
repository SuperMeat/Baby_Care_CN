//
//  TipsMainViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-5-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncController.h"
#import "MBProgressHUD.h"

@interface TipsMainViewController : ACViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *tipArray;
    NSArray *subArray;
    MBProgressHUD *hud;
    NSString *category_ids;
    
    int _tempOffset;
    
    UIView *_v1;
    UIView *_v2;
    
    UIScrollView *_scrollView;
}

@property (nonatomic,strong) UITableView    *tTableView;
@property (nonatomic,strong) UITableView    *sTableView;
@property (strong, nonatomic) UIButton *buttonBack;
@property (nonatomic,strong) UIButton *buttonSubscribe;


@end
