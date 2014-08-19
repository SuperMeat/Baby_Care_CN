//
//  TestReportScoreView.m
//  BabyCalendar
//
//  Created by Will on 14-7-17.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TestReportScoreView.h"
#import "TestModel.h"
@implementation TestReportScoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _zeroLab = [[UILabel alloc] init];
        _zeroLab.backgroundColor = [UIColor clearColor];
        _zeroLab.textAlignment = NSTextAlignmentCenter;
        _zeroLab.font = [UIFont systemFontOfSize:12.0f];
        _zeroLab.textColor = [UIColor lightGrayColor];
        
        _scoreLab = [[UILabel alloc] init];
        _scoreLab.backgroundColor = [UIColor clearColor];
        _scoreLab.textAlignment = NSTextAlignmentCenter;
        _scoreLab.font = [UIFont systemFontOfSize:12.0f];
        _scoreLab.textColor = [UIColor lightGrayColor];
        
        _levTitleLab = [[UILabel alloc] init];
        _levTitleLab.backgroundColor = [UIColor clearColor];
        _levTitleLab.textAlignment = NSTextAlignmentCenter;
        _levTitleLab.textColor = UIColorFromRGB(kColor_Zheline_val);
        _levTitleLab.font = [UIFont fontWithName:kFont size:15.0f];
        
        _levLab = [[UILabel alloc] init];
        _levLab.backgroundColor = [UIColor clearColor];
        _levLab.textAlignment = NSTextAlignmentCenter;
        _levLab.font = [UIFont fontWithName:kFont size:20];
        _levLab.textColor = UIColorFromRGB(kColor_testReport_score);
        
        _levTitleLab.text = @"得分";
        _zeroLab.text = @"0";
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _zeroLab.frame = CGRectMake(5, 75, 30, 20);
    _scoreLab.frame = CGRectMake(85,75, 30, 20);
    _levTitleLab.frame = CGRectMake((self.width-50)/2, (self.height-20)/2-10, 50, 20);
    _levLab.frame = CGRectMake(_levTitleLab.left, _levTitleLab.bottom, 50, 20);
    
    
    [self addSubview:_zeroLab];
    [self addSubview:_scoreLab];
    [self addSubview:_levLab];
    [self addSubview:_levTitleLab];
}
- (void)setModel:(TestModel *)model
{
    _model = model;
    
//    _scoreLab.text = [_model.score stringValue];
    _scoreLab.text = @"100";
    _levLab.text = [self leavlFromScore:[_model.score integerValue]];
    
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float center_x = self.width/2;
    float center_y = self.height/2;
    
    // 白色圆圈
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextAddArc(context, center_x, center_y, self.width/2, 0*M_PI/180, 360*M_PI/180, 0);
    CGContextFillPath(context);
    
    // 灰色圆圈
    CGContextSetRGBFillColor(context, 211.0/255.0, 211.0/255.0, 211.0/255.0, 1.0);
    CGContextAddArc(context, center_x, center_y, 30, 0*M_PI/180, 360*M_PI/180, 0);
    CGContextFillPath(context);
    
    // 分数圈
    CGContextSetLineWidth(context, 15);
    
    float score = [_model.score floatValue];
    
    float startAngle = 160.0f;
    float endAngle = 160.0+(score/100.0*220.0);
    
    for (int index = 0; index < 2; index++) {
        
        CGContextAddArc(context, center_x, center_y, 45, startAngle*M_PI/180, endAngle*M_PI/180, 0);
        if (index == 0) {
            CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kColor_testReport_month).CGColor);
        }
        if (index == 1) {
            CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kColor_testReport_PIBg).CGColor);
        }
        startAngle = endAngle;
        endAngle = 380.0f;
        
        CGContextStrokePath(context);
    }
    
    
}

/*
 测评结果分为A\B\C\D\E五个档次，分别对应测评得分为100-90\89-75\74-60\59-45\45以下。
 */
- (NSString*)leavlFromScore:(NSInteger)score
{
    NSString* leavl = @"";
    if (score>89) {
        leavl = @"A";
    }else if(score>74)
    {
        leavl = @"B";
    }else if(score>59)
    {
        leavl = @"C";
    }else if(score>44)
    {
        leavl = @"D";
    }else
    {
        leavl = @"E";
    }
    return leavl;
}

@end
