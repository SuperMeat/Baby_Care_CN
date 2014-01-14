//
//  BindingDeviceViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-17.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindingDeviceViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *arrayData;
}

@property (strong, nonatomic) IBOutlet UITableView *deviceTableView;


@end
