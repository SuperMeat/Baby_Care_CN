//
//  CkCalendarTitleView.m
//  MBCalendarKit
//
//  Created by Will on 14-3-9.
//  Copyright (c) 2014年 Moshe Berman. All rights reserved.
//

#import "CkCalendarTitleView.h"

@implementation CkCalendarTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _labDate = [[UILabel alloc] init];
        [_labDate setBackgroundColor:[UIColor clearColor]];
        [_labDate setTextAlignment:NSTextAlignmentCenter];
        _labDate.font = [UIFont fontWithName:kFont size:15.0f];
        [_labDate setTextColor:[UIColor whiteColor]];
        
        
        _btnForward = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnForward setImage:[UIImage imageNamed:@"icon_forward"] forState:UIControlStateNormal];
        [_btnForward addTarget:self action:@selector(forwardAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        _btnBackward = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnBackward setImage:[UIImage imageNamed:@"icon_backward"] forState:UIControlStateNormal];
        [_btnBackward addTarget:self action:@selector(backwardAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _labDate.frame = CGRectMake((self.width-_labDate.width)/4+5, 12, 200, 44);
    [_labDate sizeToFit];
    [self addSubview:_labDate];
    
    [_btnForward setFrame:CGRectMake(_labDate.right+15, (self.height-15)/2, 10, 15)];
    [self addSubview:_btnForward];
    
    [_btnBackward setFrame:CGRectMake(_labDate.left-30, (self.height-15)/2, 10, 15)];
    [self addSubview:_btnBackward];

    
}

- (void)forwardAction
{
    if ([self.delegate respondsToSelector:@selector(forwardTapped)]) {
        [self.delegate forwardTapped];
    }
}

- (void)backwardAction
{
    if ([self.delegate respondsToSelector:@selector(backwardTapped)]) {
        [self.delegate backwardTapped];
    }
}


@end
