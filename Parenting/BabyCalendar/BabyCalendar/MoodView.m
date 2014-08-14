//
//  MoodView.m
//  BabyCalendar
//
//  Created by will on 14-5-26.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "MoodView.h"

@implementation MoodView

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
    
    [_btnHappy addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnActive addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnTiaopi addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnQuite addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnUnsafe addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _markView = [[UIImageView alloc] initWithFrame:CGRectMake(-50, 20, 17, 16)];
    [_markView setImage:[UIImage imageNamed:@"icon_mark"]];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [self addSubview:_markView];
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    if (_index == 0) {
        _markView.left = -50;
    }else
    {
        _markView.left = _index*50;
    }
    
    if ([self.delegate respondsToSelector:@selector(moodViewDidselected:)]) {
        [self.delegate moodViewDidselected:_index];
    }
}

- (void)selectAction:(UIButton*)btn
{
    self.index = btn.tag;
    
    
}

@end
