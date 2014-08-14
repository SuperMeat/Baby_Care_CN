//
//  TestReportHeaderView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TestReportHeaderView.h"
#import "TestModel.h"
#import "TestReportScoreView.h"
@implementation TestReportHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _scoreView = [[TestReportScoreView alloc] init];
    _labMonth.font = [UIFont fontWithName:kFont size:25];
    _labMonth.textColor = UIColorFromRGB(kColor_testReport_month);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _scoreView.frame = CGRectMake((self.width-self.height), 5, self.height-10, self.height-10);
    [self addSubview:_scoreView];
}
- (void)setModel:(TestModel *)model
{
    _model = model;
    
    _labMonth.text = [NSString stringWithFormat:@"%@",_model.month];
    _scoreView.model = _model;

}


@end
