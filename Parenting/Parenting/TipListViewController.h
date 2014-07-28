//
//  TipDetailViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-6-9.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipTableViewCell.h"
#import "TipsWebViewController.h"
#import "TipCategoryDB.h"
#import "SyncController.h"
#import "MBProgressHUD.h"

@interface TipListViewController : ACViewController<UIScrollViewDelegate>
{
    UIActivityIndicatorView *activityView;
    MBProgressHUD *hud;
    NSArray *arrDS;
    NSString *tipsIds;
//    int categoryId;
}

@property (strong, nonatomic) UIButton *buttonBack;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) int categoryId;
@property (strong, nonatomic) UIImageView *tipsNavigationImageView;

@end
