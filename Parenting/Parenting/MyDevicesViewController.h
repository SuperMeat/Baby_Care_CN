//
//  MyDevicesViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-1-17.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDevicesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray *arrMyDevices;
    NSArray *arrAdd;
    NSMutableArray *arrData;
}

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
