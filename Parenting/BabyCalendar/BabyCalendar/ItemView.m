//
//  ItemView.m
//  WXMovie
//
//  Created by 周泉 on 13-5-22.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G开发培训中心. All rights reserved.
//

#import "ItemView.h"

@implementation ItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
        
        [self addGesture];
    }
    return self;
}

- (void)initSubviews
{
    
    // 小图片
    _item = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2.0-11, 5, 22, 22)];
    _item.contentMode = UIViewContentModeScaleAspectFit;
    _item.userInteractionEnabled = YES;
    [self addSubview:_item];
    
    // 小标题
    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, _item.bottom+5, self.width, 10)];
    _title.backgroundColor = [UIColor clearColor];
    _title.textColor = [UIColor whiteColor];
    _title.font = [UIFont boldSystemFontOfSize:10];
    _title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title];
}



- (void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didItemView:)];
    [self addGestureRecognizer:tap];
    [tap release];
}

- (void)dealloc
{
    [_item release], _item = nil;
    [_title release], _title = nil;
    [super dealloc];
}

#pragma mark - Target Actions
- (void)didItemView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didItemView:atIndex:)]) {
        
        [self.delegate didItemView:self atIndex:self.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
