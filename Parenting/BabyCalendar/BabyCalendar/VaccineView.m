//
//  VaccineView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "VaccineView.h"
#import "VaccineHeaderView.h"
#import "VaccineListView.h"
@implementation VaccineView

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
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"VaccineHeaderView" owner:self options:nil] lastObject];
    _listView = [[[NSBundle mainBundle] loadNibNamed:@"VaccineListView" owner:self options:nil] lastObject];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:_headerView];
    
    _listView.top = _headerView.bottom;
    _listView.height = kDeviceHeight - 64-_headerView.height;
    [self addSubview:_listView];
}

@end
