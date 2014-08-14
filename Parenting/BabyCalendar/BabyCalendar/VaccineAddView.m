//
//  VaccineAddView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "VaccineAddView.h"
#import "VaccineAddHeaderView.h"
#import "VaccineAddContentView.h"
@implementation VaccineAddView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews
{
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"VaccineAddHeaderView" owner:self options:nil] lastObject];
    _contentView = [[[NSBundle mainBundle] loadNibNamed:@"VaccineAddContentView" owner:self options:nil] lastObject];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:_headerView];
    
    _contentView.top = _headerView.bottom;
    _contentView.height = kDeviceHeight - 64 - _headerView.height;
    [self addSubview:_contentView];
}

@end
