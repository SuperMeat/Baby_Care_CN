//
//  TempCorePlot.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-11.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "TempCorePlot.h"
#import "PhyCPTTheme.h"

@implementation TempCorePlot

#pragma 参数:
-(id)initWithFrame:(CGRect)frame XasixAndValue:(NSArray*)arr{
    if (self = [super initWithFrame:frame]) {
        //静态数据
        yBaseValue  = 1;
        ySizeInterval  = 1;
        Yaxis = @[@35,@36,@37,@38,@39,@40];
        yBaseValue  = 35;
        ySizeInterval  = 1;
        
        XaxisAndValue = arr;
        
        //Step1:配置Graph画布
        [self configureGraph];
        //Step2:配置Plots绘制
        [self configurePlots];
        //Step3:配置Axes弧线
        [self configureAxes];
    }
    return self;
}

-(void)configureGraph {
    // 1 - 创建画布
    _graph = [[CPTXYGraph alloc] initWithFrame:self.bounds];
    PhyCPTTheme *theme = [[PhyCPTTheme alloc] init];
    [_graph applyTheme:theme];
    self.hostedGraph = _graph;
    // 2 - 设置画布标题
    _graph.title = @"";
    // 3 - 创建且设置文字样式
    // 4 - 设置画布留空
    _graph.plotAreaFrame.borderLineStyle = nil;
    _graph.plotAreaFrame.cornerRadius    = 0.0f;
    //CPTGraph四边不留白
    _graph.paddingLeft   = 0.0f;
    _graph.paddingRight  = 0.0f;
    _graph.paddingTop    = 0.0f;
    _graph.paddingBottom = 0.0f;
    //绘图区四边留白
    _graph.plotAreaFrame.paddingLeft   = 25.0f;
    _graph.plotAreaFrame.paddingRight  = 25.0f;
    _graph.plotAreaFrame.paddingTop    = 25.0f;
    _graph.plotAreaFrame.paddingBottom = 25.0f;
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) _graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots {
    // 1 - 建立绘制区域
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) _graph.defaultPlotSpace;
    // 2 - 判断绘制曲线数量并绘制区域
    CPTScatterPlot *baseTempPlot = [[CPTScatterPlot alloc] init];    //Temp参考线
    baseTempPlot.dataSource = self;
    baseTempPlot.identifier = @"Temp";
    CPTColor *baseTempColor = [CPTColor blueColor];
    [_graph addPlot:baseTempPlot toPlotSpace:plotSpace];
    
    // 3 - 设置绘制控件
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:baseTempPlot,nil]];
    /*
     *  设置视图范围内的现实长度
     */
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(6)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(5)];
    // 4 - 设置绘制样式 style symbol
    CPTMutableLineStyle *baseTempLineStyle = [baseTempPlot.dataLineStyle mutableCopy];
    baseTempLineStyle.lineWidth = 1.0;
    baseTempLineStyle.lineColor = baseTempColor;
    baseTempPlot.dataLineStyle = baseTempLineStyle;
    
    // 5 - 描点样式
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    // 圆圈用黑色绘制
    symbolLineStyle.lineColor = [CPTColor greenColor];
    CPTPlotSymbol *baseTempSymbol =  [CPTPlotSymbol ellipsePlotSymbol];
    baseTempSymbol.fill = [CPTFill fillWithColor:[CPTColor greenColor]];
    //    baseTempSymbol.lineStyle = symbolLineStyle;
    baseTempSymbol.size = CGSizeMake(3.0, 3.0);
    baseTempPlot.plotSymbol = baseTempSymbol;
    
    //设置x、y轴的滚动范围，如果不设置，默认是无线长的
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat([XaxisAndValue count])];
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(5)];
}

-(void)configureAxes {
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 1.0f;
    axisLineStyle.lineColor = [CPTColor blackColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor blackColor];
    axisTextStyle.fontSize = 9.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0f;
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostedGraph.axisSet;
    axisSet.xAxis.axisConstraints = [CPTConstraints constraintWithRelativeOffset:0.0];
    axisSet.yAxis.axisConstraints = [CPTConstraints constraintWithRelativeOffset:0.0];
    
    // 3 - 配置X轴
    CPTAxis *x = axisSet.xAxis;
    //    x.title = [CxyTitle objectAtIndex:0];
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 20.0f; //20
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorIntervalLength = CPTDecimalFromInt(3);
    x.tickDirection = CPTSignNegative;
    CGFloat dateCount = [XaxisAndValue count];
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    NSInteger i = 0;
    //TODO:画X轴label
    
    for ( NSInteger j = 0; j < [XaxisAndValue count]; j++) {
        NSString *xLabel;
        xLabel = [NSString stringWithFormat:@"%@", [[XaxisAndValue objectAtIndex:j] objectAtIndex:1]];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:xLabel textStyle:x.labelTextStyle];
        label.rotation = 0.5f; //设置倾斜角度
        CGFloat location = i++;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    
    
    x.axisLabels = xLabels;
    // 4 - Configure y-axis
    CPTAxis *y = axisSet.yAxis;
    y.titleTextStyle = axisTitleStyle;
    y.titleRotation=0;
    y.titleLocation=CPTDecimalFromDouble(6.0);
    y.titleOffset=0.5;
    
    y.axisLineStyle = axisLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 10.0f;
    y.tickDirection = CPTSignPositive;
    //TODO:画Y轴label
    CGFloat yDateCount = [Yaxis count];
    NSMutableSet *yLabels = [NSMutableSet setWithCapacity:yDateCount];
    NSMutableSet *yLocations = [NSMutableSet setWithCapacity:yDateCount];
    NSInteger k = 0;
    //TODO:画X轴label
    for ( NSInteger l = 0; l < [Yaxis count]; l++) {
        NSString *yLabel;
        yLabel = [NSString stringWithFormat:@"%@°", [Yaxis objectAtIndex:l]];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:yLabel textStyle:y.labelTextStyle];
        
        CGFloat location = k++;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = -18.0f;
        label.alignment = NSTextAlignmentCenter;
        if (label) {
            [yLabels addObject:label];
            [yLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    
    y.axisLabels = yLabels;
}



-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [XaxisAndValue count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    NSInteger valueCount = [XaxisAndValue count];
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (index < valueCount) {
                return [NSNumber numberWithInt:index];
            }
            break;
        case CPTScatterPlotFieldY:
            if ([plot.identifier isEqual:@"Temp"] == YES) {
                //                [NSNumber numberWithFloat:]
                NSNumber *tempNum = [[XaxisAndValue objectAtIndex:index] objectAtIndex:2];
                return [self getYAxisValue:tempNum];
            }
            break;
    }
    return [NSDecimalNumber zero];
}

-(NSNumber *)getYAxisValue:(NSNumber*)value
{
    //如果小于最基础值
    if ([value floatValue] <= yBaseValue) {
        return [NSNumber numberWithFloat:[value floatValue]/yBaseValue];
    }
    else {
        float newValue = [value floatValue] - yBaseValue;
        return [NSNumber numberWithFloat:(newValue / ySizeInterval)];
    }
}

+(void) setTransform:(float) radians forLable:(UILabel *) label
{
    label.transform = CGAffineTransformMakeRotation(M_PI*radians);
}
@end