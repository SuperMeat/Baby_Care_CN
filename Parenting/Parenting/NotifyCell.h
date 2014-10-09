//
//  NotifyCell.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-10-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotifyModel;
@interface NotifyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *notifyTextView;
@property(nonatomic,retain)NotifyModel* notifymodel;
@end
