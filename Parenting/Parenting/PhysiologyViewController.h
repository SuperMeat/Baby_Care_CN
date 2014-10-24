//
//  PhysiologyViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-24.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHYDetailViewController.h"
#import "TempDetailViewController.h"

@interface PhysiologyViewController : ACViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *arrayPhyItems;
    PHYDetailViewController *pHYDetailViewController;
    TempDetailViewController *tempDetailViewController;
}

@property (strong, nonatomic) UITableView *scorllView;
@property (strong, nonatomic) UIImageView *physiologyImageView;
 
@end
