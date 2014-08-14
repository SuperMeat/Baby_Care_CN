//
//  TestReportFootView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TestReportFootView.h"
#import "TestModel.h"
#import "ZhuView.h"
#import "ZhuModel.h"
@implementation TestReportFootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _knowledge_zhuView = [[[NSBundle mainBundle] loadNibNamed:@"ZhuView" owner:self options:nil] lastObject];
        _active_zhuView = [[[NSBundle mainBundle] loadNibNamed:@"ZhuView" owner:self options:nil] lastObject];
        _language_zhuView = [[[NSBundle mainBundle] loadNibNamed:@"ZhuView" owner:self options:nil] lastObject];
        _society_zhuView = [[[NSBundle mainBundle] loadNibNamed:@"ZhuView" owner:self options:nil] lastObject];
        
        for (int index = 0; index < 6; index++) {
            UILabel* vLabel = [[UILabel alloc] initWithFrame:CGRectMake(-30, index*27, 50, 30)];
            [vLabel setBackgroundColor:[UIColor clearColor]];
            [vLabel setFont:[UIFont fontWithName:kFont size:9]];
            [vLabel setTextColor:UIColorFromRGB(kColor_Zheline_val)];
            [vLabel setTextAlignment:NSTextAlignmentCenter];
            vLabel.text = [NSString stringWithFormat:@"%d",(5-index)*20];
            [self addSubview:vLabel];
            
        }
        
        
        
    }
    return self;
}


- (void)setModel:(TestModel *)model
{
    _model = model;
    
    NSArray* titles = @[kTest_type_knowledge,kTest_type_active,kTest_type_language,kTest_type_society];
    NSArray* values = @[_model.knowledge_score,_model.active_score,_model.language_score,_model.society_score];
    NSArray* colors = @[UIColorFromRGB(kColor_test_knowledge),UIColorFromRGB(kColor_test_active),UIColorFromRGB(kColor_test_mood),UIColorFromRGB(kColor_test_society)];
    int width = 30;
    NSArray* zhuViews = @[_knowledge_zhuView,_active_zhuView,_language_zhuView,_society_zhuView];
    for (int index = 0; index < titles.count; index++) {
        ZhuView* zhuView = zhuViews[index];
        zhuView.frame = CGRectMake(index*(width+40)+30, 20, width, 10);
        ZhuModel* zhuModel = [[ZhuModel alloc] init];
        zhuModel.title = titles[index];
        zhuModel.value = values[index];
        zhuModel.color = colors[index];
        zhuView.model = zhuModel;
        
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    _knowledge_zhuView.superViewHeight = self.height;
    _active_zhuView.superViewHeight = self.height;
    _language_zhuView.superViewHeight = self.height;
    _society_zhuView.superViewHeight = self.height;
    _knowledge_zhuView.model.num = [NSNumber numberWithFloat:(self.height-50.0)/100.0];
    _active_zhuView.model.num = [NSNumber numberWithFloat:(self.height-50.0)/100.0];
    _language_zhuView.model.num = [NSNumber numberWithFloat:(self.height-50.0)/100.0];
    _society_zhuView.model.num = [NSNumber numberWithFloat:(self.height-50.0)/100.0];
    [self addSubview:_knowledge_zhuView];
    [self addSubview:_active_zhuView];
    [self addSubview:_language_zhuView];
    [self addSubview:_society_zhuView];
}

@end
