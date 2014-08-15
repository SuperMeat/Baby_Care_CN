//
//  AddMilestoneCell.m
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "AddMilestoneCell.h"
#import "MilestoneModel.h"
#import "PublicDefine.h"

@implementation AddMilestoneCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //_labMonth.textColor = UIColorFromRGB(kColor_milestone_detailText);
}

- (void)setModel:(MilestoneModel *)model
{
    _model = model;
    
    _labTitle.text = _model.title;
    //_labMonth.text = _model.month;
    _labDate.text  = _model.date;
    if ([_model.completed boolValue]) {
        _labCompleted.hidden = NO;
        _labDate.hidden = NO;
    }else
    {
        _labCompleted.hidden = YES;
        _labDate.hidden = YES;
    }
    
}
- (void)setRow:(NSInteger)row
{
    _row = row;
    
    if (_row%2 == 0) {
        _iconImgView.image = [UIImage imageNamed:@"foot_left"];
    }else
    {
        _iconImgView.image = [UIImage imageNamed:@"foot_right"];
    }
}
@end
