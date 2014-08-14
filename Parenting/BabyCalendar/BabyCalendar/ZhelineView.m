//
//  ZhelineView.m
//  MySafedog
//
//  Created by will on 14-2-25.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "ZhelineView.h"
#import "Zheline.h"
//#import "NetworkDeramModel.h"
#import "XLabel.h"
#import "YLabel.h"

@implementation ZhelineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self initViews];
        
    }
    return self;
}

- (void)initViews
{
    _pSc = [[UIScrollView alloc] init];
    _pSc.showsHorizontalScrollIndicator = NO;
    _pSc.showsVerticalScrollIndicator = NO;
    [_pSc setDelegate:self];
    _pSc.backgroundColor = [UIColor clearColor];
    [_pSc setContentOffset:CGPointMake(0, 10000000)];
    _pSc.bounces = NO;
    
    
    
    _ySc = [[UIScrollView alloc] init];
    _ySc.scrollEnabled = NO;
    [_ySc setContentOffset:CGPointMake(0, 100000000)];
    
    
    _xSc = [[UIScrollView alloc] init];
    _xSc.scrollEnabled = NO;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _pSc.frame = CGRectMake(30, 0, self.width-40,self.height-50);
    [self addSubview:_pSc];
    
    _ySc.frame = CGRectMake(0, 0, 30, self.height-50);
    [self addSubview:_ySc];
    
    _xSc.frame = CGRectMake(30, _pSc.bottom, self.width-40, 30);
    [self addSubview:_xSc];
    
    
    
    // 无数据
    if (_points.count == 0) {
        return;
    }
    
    
    double  yMaxValue = 0.0;
    
    for (NSArray* arr in _points) {
        for (NSValue* value in arr) {
            CGPoint pointer = [value CGPointValue];
            double valueY = pointer.y;
            if (valueY > yMaxValue) {
                yMaxValue = valueY;
            }
            
        }
    }
    
    int h_count =  yMaxValue/10+1;
    if (h_count < 11) {
        h_count = 11;
    }
    
    //y轴刻度
    NSMutableArray *yArr = [[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<h_count; i++) {
        [yArr addObject:[NSString stringWithFormat:@"%d",i*10]];
    }
    
//    int dis_y = self.height/10;
    int y = h_count*kBy;
    
    for (int i=0; i<yArr.count; i++) {
        
        if (i % 2 !=0) {
            y -= kBy;
            continue;
        }
        
        YLabel *label = [[YLabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setCenter:CGPointMake(15, y)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor blackColor]];
        [label setText:[yArr objectAtIndex:i]];
        [_ySc addSubview:label];
        y -= kBy;
        
    }
    
    HeightSc = h_count*kBy;
    
    NSArray* point = _points[0];
    
    if (_bColorGreen) {
        [_pSc setContentSize:CGSizeMake(point.count*kConfigDisTime+kDis_right_width, HeightSc)];
    }else
    {
        [_pSc setContentSize:CGSizeMake(point.count*kDisTime+kDis_right_width, HeightSc)];
    }
    
    
    [_ySc setContentSize:CGSizeMake(_ySc.width, HeightSc)];
    [_pSc setContentOffset:CGPointMake(0, _pSc.contentSize.height-_pSc.height) animated:YES];
    
    
    // 折线图
    
    Zheline* lineView = [[Zheline alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-40, _pSc.height)];
    [_pSc addSubview:lineView];
    
    lineView.bColorGreen = _bColorGreen;
    [lineView setYDesc:yArr];
    [lineView setTimes:self.timeArr];
    [lineView setPoints:_points];
    
    
    
}
- (void)drawRect:(CGRect)rect
{
    
    // 绘坐标轴直线
    [self drawLine];
    
    if (self.points.count>0) {
        NSArray* point = self.points[0];
        if (point.count>0) {
            
            // x轴刻度
            CGPoint p2 = [[point objectAtIndex:point.count-1] CGPointValue];
            int i = point.count-1;

            for (; i<[point count]; i--)
            {
                p2 = [[point objectAtIndex:i] CGPointValue];
                
                CGPoint goPoint = CGPointMake(p2.x, 15);

//                int a = 1;
//                if (!_bColorGreen) {
//                    a = 3;
//                }
                
//               if (i%a == 0) {
                
                    
                    XLabel* timeLabel = [[XLabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
                    [timeLabel setFont:[UIFont systemFontOfSize:10]];
                    [timeLabel setBackgroundColor:[UIColor clearColor]];
                    [timeLabel setTextAlignment:NSTextAlignmentCenter];
                
                    [timeLabel setCenter:goPoint];
                    [_xSc addSubview:timeLabel];
                    timeLabel.text = self.timeArr[i];
//                    NSLog(@"%@",self.timeArr[i]);
                    
//                }
                
            }
        }
    }
    
    
}

- (void)drawLine
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kColor_Zheline_val).CGColor);
    // y轴
    CGPoint bPoint = CGPointMake(30, 0);
    CGPoint ePoint = CGPointMake(30, _pSc.height);
    CGContextMoveToPoint(context, bPoint.x, bPoint.y);
    CGContextAddLineToPoint(context, ePoint.x, ePoint.y);
    CGContextStrokePath(context);
    
//    // x轴
//    bPoint = CGPointMake(30, _pSc.height);
//    ePoint = CGPointMake(_pSc.width+30, _pSc.height);
//    CGContextMoveToPoint(context, bPoint.x, bPoint.y);
//    CGContextAddLineToPoint(context, ePoint.x, ePoint.y);
//    CGContextStrokePath(context);
    
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_ySc setContentOffset:CGPointMake(0, scrollView.contentOffset.y) animated:YES];
    [_xSc setContentOffset:CGPointMake(scrollView.contentOffset.x, 0) animated:YES];
    
}

@end
