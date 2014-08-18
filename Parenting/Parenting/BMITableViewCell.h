//
//  BMITableViewCell.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-15.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMITableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *labelBMIValue;
@property (weak, nonatomic) IBOutlet UILabel *labelHeightDate;
@property (weak, nonatomic) IBOutlet UILabel *labelHeightValue;
@property (weak, nonatomic) IBOutlet UILabel *labelWeightDate;
@property (weak, nonatomic) IBOutlet UILabel *labelWeightValue;


@end
