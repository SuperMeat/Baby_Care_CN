//
//  TestReportMiddleView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TestReportMiddleView.h"
#import "ZhelineView.h"
#import "TestModel.h"
@implementation TestReportMiddleView

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
    if (_zhelineView == nil) {
        _zhelineView = [[ZhelineView alloc] init];
        _zhelineView.bColorGreen = YES;
    
    }
    
    UILabel* scoreLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 20)];
    [scoreLab setBackgroundColor:[UIColor clearColor]];
    [scoreLab setText:@"分数"];
    [scoreLab setFont:[UIFont fontWithName:kFont size:15.0f]];
    [scoreLab setTextColor:UIColorFromRGB(kColor_Zheline)];
    [self addSubview:scoreLab];
}

- (void)setDatas:(NSMutableArray *)datas
{
    _datas = datas;
    NSMutableArray* months = [NSMutableArray array];
    NSMutableArray* scores = [NSMutableArray array];
    int index = 0;
    for (TestModel* model in _datas) {
        if ([model.completed boolValue]) {
            
            [scores addObject:[NSValue valueWithCGPoint:CGPointMake(kConfigDisTime*(index+1), [model.score intValue])]];
            
            NSString* month = [NSString stringWithFormat:@"%@月",model.month];
            [months addObject:month];
            index++;
        }
    }
    _zhelineView.points = [NSMutableArray arrayWithObjects:scores, nil];
    _zhelineView.timeArr = months;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [_zhelineView setFrame:CGRectMake(0, 20, kDeviceWidth, self.height)];
     [self addSubview:_zhelineView];
}

@end
