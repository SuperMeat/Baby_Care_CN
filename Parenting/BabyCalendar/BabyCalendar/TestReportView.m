//
//  TestReportView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TestReportView.h"
#import "TestReportHeaderView.h"
#import "TestReportMiddleView.h"
#import "TestReportFootView.h"
@implementation TestReportView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
        
        [self _initDatas];
        
    }
    return self;
}

- (void)_initViews
{
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"TestReportHeaderView" owner:self options:nil] lastObject];
    _middleView = [[TestReportMiddleView alloc] init];
    _footView = [[TestReportFootView alloc] init];
    
    
}

- (void)_initDatas
{
    self.datas = [BaseSQL queryData_test];
    
}

- (void)setMonth:(NSInteger)month
{
    _month = month;
    _middleView.datas = self.datas;
    _headerView.model = self.datas[_month];
    _footView.model = self.datas[_month];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:_headerView];
    
    _middleView.frame = CGRectMake(0, _headerView.bottom, kDeviceWidth, 26*7+11);
    [self addSubview:_middleView];
    

    _footView.frame = CGRectMake(20, _middleView.bottom, kDeviceWidth, 26*7);
    [self addSubview:_footView];
    
    self.contentSize = CGSizeMake(0, _footView.bottom);
    
    self.contentheight = _headerView.size.height + _middleView.size.height + _footView.size.height;
    
}
@end
