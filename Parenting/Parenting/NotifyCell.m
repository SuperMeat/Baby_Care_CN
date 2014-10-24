//
//  NotifyCell.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-10-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "NotifyCell.h"
#import "NotifyItem.h"

@implementation NotifyCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 57)];
    v.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = v;
    
    _notifyTextView.textColor = [UIColor lightGrayColor];
    _notifyTextView.font = [UIFont fontWithName:kFont size:14];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNotifymodel:(NotifyModel *)notifymodel
{
    _notifymodel = notifymodel;
    _notifyTextView.text = notifymodel.content;
}

@end
