//
//  CustomUISwitchView.m
//  BabyCalendar
//
//  Created by Will on 14-8-2.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "CustomUISwitchView.h"

@implementation CustomUISwitchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithImageYES:(UIImage*)imageYES WithImageNO:(UIImage*)imageNO
{
    self = [super init];
    if (self) {
        _imageYES = imageYES;
        _imageNO = imageNO;
        
        [self addTap];
    }
    
    return self;
}

- (void)setOn:(BOOL)on
{
    _on = on;
    if (_on) {
        self.image = _imageYES;
    }else
    {
        self.image = _imageNO;
    }
}

- (void)addTap
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction
{
    self.on = !self.on;
    if ([self.delegate respondsToSelector:@selector(customUISwitchViewTap:)]) {
        [self.delegate customUISwitchViewTap:self];
    }
}
@end
