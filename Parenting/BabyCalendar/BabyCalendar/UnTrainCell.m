//
//  UnTrainCell.m
//  BabyCalendar
//
//  Created by will on 14-5-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "UnTrainCell.h"
#import "RTLabel.h"
#import "TrainModel.h"
@implementation UnTrainCell

- (void)awakeFromNib
{
    _rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(20, 5, kDeviceWidth-40, 10)];
    _rtLabel.backgroundColor = [UIColor clearColor];
    _rtLabel.textColor = UIColorFromRGB(kColor_val_infoText);
    _rtLabel.font = [UIFont fontWithName:kFont size:kFontsize_untrain_content];
    
    _labTitle.font = [UIFont fontWithName:kFont size:15];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [_bgView addSubview:_rtLabel];

}


- (void)setModel:(TrainModel *)model
{
    _model = model;
    
    _labTitle.text = _model.title;
    _rtLabel.text = _model.content;
    [_rtLabel sizeToFit];
    _rtLabel.height = _rtLabel.optimumSize.height+20;
    _bgView.height = _rtLabel.height;
    
    if ([_model.trained boolValue]) {
        _selectedView.image = [UIImage imageNamed:@"btn_selected"];
    }else
    {
        _selectedView.image = [UIImage imageNamed:@"btn_unselected"];
    }
    
    if ([_model.type isEqualToString:kKnowledge]) {
        _bg_title.image = [UIImage imageNamed:@"bg_train_green"];
    }
    if ([_model.type isEqualToString:kActive]) {
        _bg_title.image = [UIImage imageNamed:@"bg_train_red"];
    }
    if ([_model.type isEqualToString:kLive]) {
        _bg_title.image = [UIImage imageNamed:@"bg_train_orange"];
    }
    if ([_model.type isEqualToString:kSociety]) {
        _bg_title.image = [UIImage imageNamed:@"bg_train_blue"];
    }
    
}

@end
