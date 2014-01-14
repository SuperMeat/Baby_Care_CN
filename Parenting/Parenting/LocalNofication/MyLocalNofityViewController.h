//
//  MyLocalNofityViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-6.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLocalNofityViewController : UIViewController<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSDate* notifyDate;
    
    UITableView *notifytableview;
    
    NSArray *notifylist;

}


@end
