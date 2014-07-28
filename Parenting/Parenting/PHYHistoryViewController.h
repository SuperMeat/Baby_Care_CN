//
//  PHYHistoryViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-7-16.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHYHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrDS;
}

@property (strong, nonatomic) UIImageView *phyDetailImageView;
@property (strong, nonatomic) UIButton *buttonBack;  

@property (strong, nonatomic) UITableView *tableView;
@end
