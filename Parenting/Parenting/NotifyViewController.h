//
//  NotifyViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-11-12.
//  Copyright (c) 2013年 爱摩信息科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifyViewController : ACViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView        *_notifytableview;
    NSMutableArray     *notifyArray;
}
@end
