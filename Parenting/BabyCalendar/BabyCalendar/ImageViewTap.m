//
//  ImageViewTap.m
//  BabyCalendar
//
//  Created by will on 14-7-1.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "ImageViewTap.h"

@implementation ImageViewTap

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
}

- (void)tapAction
{
    if ([self.delegate respondsToSelector:@selector(tapAction:)]) {
        [self.delegate tapAction:self];
    }
}

@end
