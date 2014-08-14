//
//  ZhelineView.m
//  MySafedog
//
//  Created by will on 14-2-8.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "Zheline.h"

#define kHeight  700
@implementation Zheline

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_points.count > 0) {
        NSArray* point = _points[0];
        int x = 0;
        if (_bColorGreen) {
            x = point.count*kConfigDisTime+kDis_right_width;
        }else
        {
            x = point.count*kDisTime+kDis_right_width;
        }
        if (x < 290) {
            x = 290;
        }
        
        self.frame = CGRectMake(0, 0, x, _yDesc.count*40);
        
    }
    
}

- (void)drawRect:(CGRect)rect
{
    // 画直线
    [self drawLine];
    

    // 折线图
    for (int i = 0; i < _points.count; i++) {
        [self drawZheLine:_points[i]];
    
    }
    
}

- (void)drawLine
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
//    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kColor_Zheline_val).CGColor);
    int x = 0;
    // 绘横线
    if (_points.count>0) {
        NSArray* point = _points[0];
        if (_bColorGreen) {
            x = point.count*kConfigDisTime+kDis_right_width;
        }else
        {
            x = point.count*kDisTime+kDis_right_width;
        }
        
        if (x < 290) {
            x = 290;
        }
    }
    
    int y = _yDesc.count*kBy;
    
    for (int i=0; i<_yDesc.count; i++) {
        
        if (i %2 != 0) {
            y -= kBy;
            continue;
        }
        
        CGPoint bPoint = CGPointMake(0, y);
        CGPoint ePoint = CGPointMake(x, y);
        
        CGContextMoveToPoint(context, bPoint.x, bPoint.y);
        CGContextAddLineToPoint(context, ePoint.x, ePoint.y);

        CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kColor_Zheline_val).CGColor);
        CGContextStrokePath(context);
        
        y -= kBy;
        
    }

    
}

- (void)drawZheLine:(NSArray*)points
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float poy = _yDesc.count*kBy;
    
    if (points.count == 0 || points == nil) {
        NSLog(@"没可画的点");
        return;
    }
    
    
	CGPoint p = [[points objectAtIndex:points.count-1] CGPointValue];
    CGPoint p2 = p;
    
    
	int i = points.count-1;
	CGContextMoveToPoint(context, p.x, poy-p.y*kBy/10);

	for (; i<[points count]; i--)
	{
		p = [[points objectAtIndex:i] CGPointValue];
        
        CGPoint goPoint = CGPointMake(p.x, poy-p.y*kBy/10);
        
		CGContextAddLineToPoint(context, goPoint.x, goPoint.y);
        CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kColor_testReport_month).CGColor);

	}
    
    CGContextStrokePath(context);
    
    // 相关标注
    
    i = points.count-1;
	for (; i<[points count]; i--)
	{
        p2 = [[points objectAtIndex:i] CGPointValue];
        
        CGPoint goPoint = CGPointMake(p2.x, poy-p2.y*kBy/10);
        
        UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setFont:[UIFont fontWithName:kFont size:8]];
        [textLabel setTextColor:UIColorFromRGB(kColor_testReport_month)];
        CGPoint point = goPoint;
        point.y -= 8.0;
        [textLabel setCenter:point];
        [self addSubview:textLabel];
        textLabel.text = [NSString stringWithFormat:@"%.f",p2.y];
            
          
            //画圆圈
        CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kColor_testReport_month).CGColor);
        CGContextAddArc(context, goPoint.x, goPoint.y, 3, 0, 6.3, 0);
        CGContextStrokePath(context);
        
//        }
        
    }
}


@end
