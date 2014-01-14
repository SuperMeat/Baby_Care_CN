//
//  LocalNotifyCell.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-17.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalNotify.h"

@interface LocalNotifyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *notifycontent;
@property (strong, nonatomic) IBOutlet UILabel *timedetail;
@property (strong, nonatomic) IBOutlet UISwitch *notifyswitch;
@property (strong, nonatomic) LocalNotify *ln;
- (IBAction)changeValue:(UISwitch *)sender;
@end
