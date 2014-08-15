//
//  PHYTableViewCell.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-15.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHYTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelType;
@property (weak, nonatomic) IBOutlet UILabel *labelValue;
@property (weak, nonatomic) IBOutlet UILabel *labelUnit;

@end
