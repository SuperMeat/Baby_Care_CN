//
//  TrainListCell.m
//  BabyCalendar
//
//  Created by will on 14-5-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TrainListCell.h"
#import "TrainListModel.h"
@implementation TrainListCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(TrainListModel *)model
{
    _model = model;
    
    _iconView.image = [UIImage imageNamed:_model.image];
    
    _labTitle.text = _model.title;
    _labTitle.font = [UIFont fontWithName:kFont size:15];
    _labTitle.textColor = UIColorFromRGB(kColor_train_cell_title);
}
@end
