//
//  ActiveTipsView.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-18.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipTableViewCell.h"
#import "TipsWebViewController.h"
#import "TipCategoryDB.h"
#import "SyncController.h"
#import "MBProgressHUD.h"

@interface ActiveTipsView : UIView<UIScrollViewDelegate>
{
    UIActivityIndicatorView *activityView;
    MBProgressHUD *hud;
    NSArray *arrDS;
    NSString *tipsIds; 
    //    int categoryId;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) int categoryId;
@property (nonatomic,assign) NSString* categoryName;
@property (nonatomic,assign) UIViewController *parentViewController;

- (id)initWithFrame:(CGRect)frame ParentViewController:(UIViewController*)parentViewController;
-(void)showTipsView:(int)CategoryId;
@end
