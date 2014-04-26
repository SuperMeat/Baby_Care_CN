//
//  PhysiologyViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-24.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHYDetailViewController.h"

@interface PhysiologyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *arrayPhyItems;
    PHYDetailViewController *pHYDetailViewController;
}

@property (strong, nonatomic) UITableView *scorllView;
@property (strong, nonatomic) UIImageView *physiologyImageView;
@end
