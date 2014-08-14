//
//  TrainView.m
//  BabyCalendar
//
//  Created by will on 14-5-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TrainView.h"
#import "TrainHeaderView.h"
#import "TrainList.h"
@implementation TrainView

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
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TrainHeaderView" owner:self options:nil] lastObject];
    _list = [[[NSBundle mainBundle] loadNibNamed:@"TrainList" owner:self options:nil] lastObject];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [self addSubview:_headerView];
    
    _list.top = _headerView.bottom;
    _list.height = kDeviceHeight-64-_headerView.bottom;
    [self addSubview:_list];
}
@end
