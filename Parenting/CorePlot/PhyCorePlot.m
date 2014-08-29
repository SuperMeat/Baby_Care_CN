/******************************
 *          X轴:控制可显示范围为11个坐标点(包括原点)且不可拉升    实际显示11个坐标点
 *  开始坐标点(原点):   (第一次记录时间 / 10) * 10
 *  结束坐标点:        (最后一次记录时间 / 10 + 1 ) * 10 (增加1格以查看趋势)
 *  间隔:             结束值-开始值 / 10 段
 
 *          Y轴:控制可显示范围7个坐标点(包括原点)且可拉升       实际显示5个坐标点
 *  开始坐标点:      WHO最小值取整
 *  结束坐标点:      WHO与用户最大值取整 + 1
 *  间隔:           (WHO与用户最大值取整 + 1) - WHO最小值取整 / 4
 *
 *          用户数据:数据集@[日龄,数值]
 *
 *
 *
 *
 ******************************/

#import "PhyCorePlot.h"
#import "PhyCPTTheme.h"

@implementation PhyCorePlot

-(id)initWithFrame:(CGRect)frame
          UserAxis:(NSArray*)userAxis
        HeightAxis:(NSArray*)heightAxis
           LowAxis:(NSArray*)lowAxis
             XAxis:(NSArray*)x
             YAxis:(NSArray*)y
            XTitle:(NSString*)tX
            YTitle:(NSString*)tY{
    if (self = [super initWithFrame:frame]) {
        //用户数据
        arrUser = userAxis;
        //参考线
        arrP25 = lowAxis;
        arrP75 = heightAxis;
        //画布标题
        titleG = @"";
        //XY轴刻度值
        xAxis = x;
        yAxis = y;
        
        xInterval = [[xAxis objectAtIndex:1] intValue] - [[xAxis objectAtIndex:0] intValue];
        yInterval = [[yAxis objectAtIndex:1] doubleValue] - [[yAxis objectAtIndex:0] doubleValue];
        
        yBase = [[yAxis firstObject]doubleValue];
        xBase = [[xAxis firstObject]doubleValue];
        
        //XY轴标题
        titleX = tX;
        titleY = tY;
        xLen = [xAxis count]; //XY轴默认显示长度
        yLen = [yAxis count] + 1;   //Y轴由于要跳过原点,需要+1
        //XY轴显示范围
        xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(xLen)];
        yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(yLen)];
        
        colorUser = [CPTColor colorWithCGColor:[[ACFunction colorWithHexString:@"#f39998"] CGColor]];
        
        colorP25 = [CPTColor blueColor];
        colorP75 = [CPTColor blueColor];
        
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
    _graph.title = titleG;
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
    plotSpace.allowsUserInteraction = NO;
}

-(void)configurePlots {
    // 1 - 建立绘制区域
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) _graph.defaultPlotSpace;
    // 2 - 判断绘制曲线数量并绘制区域
    
    /**  P75  **/
    CPTScatterPlot *baseP75Plot = [[CPTScatterPlot alloc] init];    //P25参考线
    baseP75Plot.dataSource = self;
    baseP75Plot.identifier = @"P75";
    CPTColor *baseP75Color = colorP75;
    [_graph addPlot:baseP75Plot toPlotSpace:plotSpace];
    
    //P75填充区域
    CPTFill * P75areaGradientFill = [CPTFill fillWithImage:[CPTImage imageWithCGImage:[[UIImage imageNamed:@"phy_shadow"] CGImage]]];
    baseP75Plot.areaFill = P75areaGradientFill;
    //0.1是为了避免填充区域覆盖XY轴
    baseP75Plot.areaBaseValue = [[NSDecimalNumber numberWithFloat:0.1] decimalValue];
    
    /**  P25  **/
    CPTScatterPlot *baseP25Plot = [[CPTScatterPlot alloc] init];    //P25参考线
    baseP25Plot.dataSource = self;
    baseP25Plot.identifier = @"P25";
    CPTColor *baseP25Color = colorP25;
    [_graph addPlot:baseP25Plot toPlotSpace:plotSpace];
    
    //P25填充区域
    CPTFill * areaGradientFill  = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0]];
    baseP25Plot.areaFill      = areaGradientFill;
    //0.1是为了避免填充区域覆盖XY轴
    baseP25Plot.areaBaseValue = [[NSDecimalNumber numberWithFloat:0.1] decimalValue];
    
    CPTScatterPlot *targetUserPlot = [[CPTScatterPlot alloc] init];    //用户参考线
    targetUserPlot.dataSource = self;
    targetUserPlot.identifier = @"targetUser";
    CPTColor *targetUserColor = colorUser;
    [_graph addPlot:targetUserPlot toPlotSpace:plotSpace];
    
    /* 用户参考线描点 */
    CPTMutableLineStyle * symbolUserLineStyle = [CPTMutableLineStyle lineStyle];
    symbolUserLineStyle.lineColor = colorUser;
    symbolUserLineStyle.lineWidth = 2;
    
    CPTPlotSymbol * plotSymbolUser = [CPTPlotSymbol ellipsePlotSymbol];
    //    plotSymbolUser.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbolUser.lineStyle     = symbolUserLineStyle;
    plotSymbolUser.size          = CGSizeMake(3.0, 3.0);
    targetUserPlot.plotSymbol = plotSymbolUser;
    
    
    // 3 - 设置绘制控件
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:baseP25Plot,baseP75Plot,targetUserPlot,nil]];
    //TODO:XY轴起始刻度根据时间情况判断
    plotSpace.xRange = xRange;
    plotSpace.yRange = yRange;
    // 4 - 设置绘制样式和描点样式 style symbol
    CPTMutableLineStyle *baseP25LineStyle = [baseP25Plot.dataLineStyle mutableCopy];
    baseP25LineStyle.lineWidth = 0.2;
    baseP25LineStyle.lineColor = baseP25Color;
    baseP25Plot.dataLineStyle = baseP25LineStyle;
    
    CPTMutableLineStyle *baseP75LineStyle = [baseP75Plot.dataLineStyle mutableCopy];
    baseP75LineStyle.lineWidth = 0.2;
    baseP75LineStyle.lineColor = baseP75Color;
    baseP75Plot.dataLineStyle = baseP75LineStyle;
    
    CPTMutableLineStyle *targetUserLineStyle = [targetUserPlot.dataLineStyle mutableCopy];
    targetUserLineStyle.lineWidth = 1.5;
    targetUserLineStyle.lineColor = targetUserColor;
    targetUserPlot.dataLineStyle = targetUserLineStyle;
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
    axisTextStyle.textAlignment = NSTextAlignmentRight;
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
    x.title = titleX;
    x.titleLocation = CPTDecimalFromDouble(xLen); //标题所在的刻度值
    x.titleOffset = -19.5f;
    x.titleTextStyle = axisTitleStyle;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.tickDirection = CPTSignNegative;
    
    //画X轴label
    CGFloat dateCount = [xAxis count];
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    NSInteger i = 0;
    for ( NSInteger j = 0; j < [xAxis count]; j++) {
        NSString *xLabel;
        xLabel = [NSString stringWithFormat:@"%d", [[xAxis objectAtIndex:j] intValue]];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:xLabel textStyle:x.labelTextStyle];
        
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
    y.title = titleY;
    y.titleTextStyle = axisTitleStyle;
    y.titleRotation=0;  //标题旋转度
    y.titleLocation=CPTDecimalFromDouble(yLen + 0.8);   //y轴标题微调
    y.titleOffset=0.1;
    y.axisLineStyle = axisLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 10.0f;
    y.tickDirection = CPTSignPositive;
    
    //画Y轴label
    CGFloat yDateCount = [yAxis count];
    NSMutableSet *yLabels = [NSMutableSet setWithCapacity:yDateCount];
    NSMutableSet *yLocations = [NSMutableSet setWithCapacity:yDateCount];
    NSInteger k = 0;
    for ( NSInteger l = 0; l < [yAxis count]; l++) {
        NSString *yLabel;
        yLabel = [NSString stringWithFormat:@"%.1f", [[yAxis objectAtIndex:l] doubleValue]];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:yLabel textStyle:y.labelTextStyle];
        CGFloat location = k++;
        label.tickLocation = CPTDecimalFromCGFloat(location + 1);   //原点不显示y轴刻度 +1
        label.offset = -21.0f;
        
        if (label) {
            [yLabels addObject:label];
            [yLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    
    y.axisLabels = yLabels;
}



-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    if ([plot.identifier  isEqual: @"targetUser"]) {
        return [arrUser count];
    }
    else{
        return [xAxis count];
    }
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSInteger valueCount = [xAxis count];
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (index < valueCount) {
                //+0.1是为了避免填充区域覆盖XY轴
                if ([plot.identifier  isEqual: @"targetUser"]) {
                    double dXnum = [[[arrUser objectAtIndex:index] objectAtIndex:0] doubleValue];
                    return [NSNumber numberWithDouble:([self getXAxisValue:dXnum] + 0.05)];
                }
                else{
                    return [NSNumber numberWithDouble:index + 0.05]; //微调0.05
                }
            }
            break;
        case CPTScatterPlotFieldY:
            if ([plot.identifier isEqual:@"P25"] == YES) {
                double dYnum = [[arrP25 objectAtIndex:index] doubleValue];
                return [NSNumber numberWithDouble:[self getYAxisValue:dYnum]];
            } else if ([plot.identifier isEqual:@"P75"] == YES) {
                double dYnum = [[arrP75 objectAtIndex:index] doubleValue];
                return [NSNumber numberWithDouble:[self getYAxisValue:dYnum]];
            } else if ([plot.identifier isEqual:@"targetUser"] == YES) {
                double dYnum = [[[arrUser objectAtIndex:index] objectAtIndex:1] doubleValue];
                return [NSNumber numberWithDouble:[self getYAxisValue:dYnum]];
            }
            else {
                return [NSNumber numberWithDouble:-1];
            }
            break;
    }
    return [NSDecimalNumber zero];
}


#pragma 求出Y轴对应值
/*
 *  Y轴值等于
 *  case:   如果输入值 <= Y轴基础值
 *          返回 输入值 / 基础值
 */
-(double)getYAxisValue:(double)yValue
{
    //如果小于最基础值
    if (yValue <= yBase) {
        return yValue / yBase;
    }
    else {
        double newValue = yValue - yBase;
        return newValue / yInterval + 1;
    }
}

-(double)getXAxisValue:(double)xValue
{
    //如果小于最基础值
    if  (xValue == 0){
        return 0.0;
    }
    else if (xValue <= xBase) {
        return xValue / xBase;
    }
    else {
        double newValue = xValue - xBase;
        return newValue / xInterval;
    }
}

@end
