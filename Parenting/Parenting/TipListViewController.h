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

@interface TipListViewController : UIViewController<UIScrollViewDelegate>
{
    UIActivityIndicatorView *activityView;
    NSArray *arrDS;
}

@property (strong, nonatomic) UIButton *buttonBack;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSNumber* categoryId;
@property (strong, nonatomic) UIImageView *tipsNavigationImageView;

@end
