
//
//  ZhuView.m
//  BabyCalendar
//
//  Created by Will on 14-6-14.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "ZhuView.h"
#import "ZhuModel.h"
@implementation ZhuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _bgView = [[UIImageView alloc] init];
    [_bgView setImage:[UIImage imageNamed:@"Coordinate"]];
    
    _labTitle.font = [UIFont fontWithName:kFont size:12];
    _labValue.font = [UIFont fontWithName:kFont size:12];
    
}

- (void)setModel:(ZhuModel *)model
{
    _model = model;
    
    _labTitle.text = _model.title;
    _labValue.text = [NSString stringWithFormat:@"%@",_model.value];
    _valueView.backgroundColor = _model.color;
    _labTitle.textColor = _model.color;
    _labValue.textColor = _model.color;
    
   

    
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _valueView.height = [_model.value floatValue]*[_model.num floatValue];
    _labValue.top = 0;
    _valueView.top = _labValue.bottom;
    _labTitle.top = _valueView.bottom;
    
    
    self.height = _labTitle.bottom;
    self.top = (_superViewHeight-50)-_valueView.height;
    
    
    _bgView.top = 13;
    _bgView.size = CGSizeMake(290, 150);
    _bgView.left = 4;
    _bgView.height = self.height+self.top-20-14;
    
    [self.superview addSubview:_bgView];
}

@end
