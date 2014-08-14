//
//  VaccineDetailView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "VaccineDetailView.h"
#import "VaccineDetailContentView.h"
#import "VaccineDetailHeaderView.h"
#import "VaccineModel.h"
@implementation VaccineDetailView

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
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"VaccineDetailHeaderView" owner:self options:nil] lastObject];
    _contentView = [[[NSBundle mainBundle] loadNibNamed:@"VaccineDetailContentView" owner:self options:nil] lastObject];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _headerView.frame = CGRectMake(10, 10, kDeviceWidth-20, _headerView.height);
    [self addSubview:_headerView];
    
    _contentView.top = _headerView.bottom+10;
    _contentView.height = kDeviceHeight-64-_headerView.height-20;
    [self addSubview:_contentView];
}

- (void)setModel:(VaccineModel *)model
{
    _model = model;
    
    _headerView.model = _model;
}

@end
