//
//  MyCorePlot.m
//  bbtest
//
//  Created by 家明 on 13-5-28.
//  Copyright (c) 2013年 FengLi. All rights reserved.
//

#import "MyCorePlot.h"
#import "MyCPTTheme.h"

@implementation MyCorePlot
@synthesize graph;
@synthesize plotSpace;
@synthesize dataSource;
@synthesize barPlot, boundLinePlot,tablename;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andXplotRangeWithLocation:(float)Xrange andXlength:(float)Xlength andYplotRangeWithLocation:(float)Yrange andYlength:(float)Ylength andDataSource:(NSArray *)array andXAxisTag:(int)tag andMaxDay:(int)maxday
{
    if (self = [super initWithFrame:frame]) {
        moreLine = 0;
        recordTag = tag;
        first = 1;
        plotArray = [[NSMutableArray alloc] initWithCapacity:0];
        graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
        //指定主题
        MyCPTTheme *theme = [[MyCPTTheme alloc] init];
        [graph applyTheme:theme];
        
        //将CPTGraph放到画布上
        [self setHostedGraph:graph];
        dataSource = [[NSMutableArray alloc] initWithArray:array];
        [self makeHostingView:title andXplotRangeWithLocation:Xrange andXlength:Xlength andYplotRangeWithLocation:Yrange andYlength:Ylength andXAxisTag:tag andMaxDay:maxday];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCore) name:@"UPDATECOREPLOT" object:nil];
    }
    return self;
}

//设置画布
- (void)makeHostingView:(NSString *)title andXplotRangeWithLocation:(float)Xrange andXlength:(float)Xlength andYplotRangeWithLocation:(float)Yrange andYlength:(float)Ylength andXAxisTag:(int)tag andMaxDay:(int)maxday
{
    //CPTGraph边框：无
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.cornerRadius    = 0.0f;
    //CPTGraph四边不留白
    graph.paddingLeft   = 0.0f;
    graph.paddingRight  = 0.0f;
    graph.paddingTop    = 0.0f;
    graph.paddingBottom = 0.0f;
    //绘图区四边留白
    graph.plotAreaFrame.paddingLeft   = 50.0f;
    graph.plotAreaFrame.paddingRight  = 30.0f;
    graph.plotAreaFrame.paddingTop    = 30.0f;
    graph.plotAreaFrame.paddingBottom = 90.0f;
    //CPTGrath标题
    CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontSize = 16.0f;
    tablename=title;
    graph.titleTextStyle = textStyle;
    graph.titleDisplacement = CGPointMake(0.0f, -20.0f);
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    //绘图空间 plot space
    plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    //绘图空间
    if (Ylength < 2) {
        Ylength = 2.0f;
    }
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(Xrange) length:CPTDecimalFromFloat(Xlength + 1)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(Ylength)];
    //坐标系
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet;
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineColor = [CPTColor grayColor];
    lineStyle.lineWidth = 1.0f;
    //x轴
    CPTXYAxis *xAxis = axisSet.xAxis;
    xAxis.axisLineStyle = lineStyle;
    //隐藏默认刻度标识
    xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    // 加上这两句才能显示label
//    xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    //X轴大刻度线，线型设置
    xAxis.majorTickLineStyle = lineStyle;
    // 刻度线的长度
    xAxis.majorTickLength = 6;
    // 间隔单位,和xMin~xMax对应
    xAxis.majorIntervalLength = CPTDecimalFromInt(3);
    // 小刻度线minor...
    xAxis.minorTickLineStyle = lineStyle;
    xAxis.orthogonalCoordinateDecimal = CPTDecimalFromInt(0);
    [self setXaxisLable:xAxis andXAxisTag:tag andMaxMonthDay:maxday];
    //y轴
    yAxis = axisSet.yAxis;
    // 加上这两句才能显示label
//    yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
    //X轴大刻度线，线型设置
    yAxis.majorTickLineStyle = lineStyle;
    yAxis.majorIntervalLength = CPTDecimalFromCGFloat(0.1);
    // 刻度线的长度
    yAxis.majorTickLength = 0.1;
    
    if ([title isEqualToString:@"Diaper"]) {
        yAxis.title=NSLocalizedString(@"Count",nil);
    }
    else
    {
        yAxis.title=NSLocalizedString(@"Hours/h",nil);
    }

    yAxis.titleRotation=0;
    yAxis.titleLocation=CPTDecimalFromDouble(Ylength+0.1);

    yAxis.titleOffset=0.5;

    // 间隔单位,和xMin~xMax对应
    int i = 1;
    if (Ylength > 10) {
        i = Ylength / 10 + 1;
    }
    yAxis.majorIntervalLength = CPTDecimalFromInt(i);
    // 小刻度线minor...
    yAxis.minorTickLineStyle = nil;
    yAxis.orthogonalCoordinateDecimal = CPTDecimalFromInt(0);
    //NSLog(@"ta = %d", tag);
    if (0 == moreLine) {
        if ([title isEqualToString:@"All"]) {
            first = 1;
            [self drawMoreGraph:dataSource];
        }else{
            first = 0;
            if ([barPlot isKindOfClass:[CPTBarPlot class]]) {
                [graph reloadData];
            }else{
                NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
                if (0 == [db integerForKey:@"SHUIBIAN"]) {
                    [self drawHistogran];
                }else{
                    [self drawGraph:title];
                }
            }
        }
    }
    moreLine = 1;
}

// 设置X轴label
- (void)setXaxisLable:(CPTXYAxis *)xAxis andXAxisTag:(int)tag andMaxMonthDay:(int)maxday
{
    NSMutableArray *labelArray=[NSMutableArray arrayWithCapacity:7];
    
    NSArray *conArray;
    int labelLocation=1;
    if (0 == tag) {
        conArray = [NSArray arrayWithObjects:NSLocalizedString(@"Sun",nil),NSLocalizedString( @"Mon",nil), NSLocalizedString(@"Tue",nil), NSLocalizedString(@"Wed",nil), NSLocalizedString(@"Thu",nil), NSLocalizedString(@"Fri",nil), NSLocalizedString(@"Sat",nil), nil];
    }else{
        //NSCalendar *calendar = [NSCalendar currentCalendar];
        //NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
        //NSUInteger numberOfDaysInMonth = range.length;
        NSUInteger numberOfDaysInMonth = maxday;
        //NSLog(@"setXaisLabel: %d",numberOfDaysInMonth);
        NSString *timerYf = [NSString stringWithFormat:@"29-%i", numberOfDaysInMonth];
        if (numberOfDaysInMonth < 29) {
            conArray = [NSArray arrayWithObjects:@"01-07", @"08-14", @"15-21", @"21-28", nil];
        }
        else if (numberOfDaysInMonth < 30)
        {
             conArray = [NSArray arrayWithObjects:@"01-07", @"08-14", @"15-21", @"21-28", @"29", nil];
        }
        else
        {
            conArray = [NSArray arrayWithObjects:@"01-07", @"08-14", @"15-21", @"21-28", timerYf, nil];
        }
    }
    for(int i = 0; i < [conArray count]; i++){
        NSString *label = [conArray objectAtIndex:i];
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:label textStyle:xAxis.labelTextStyle];
        newLabel.tickLocation = [[NSNumber numberWithInt:i + 1] decimalValue];
        newLabel.offset = xAxis.labelOffset+xAxis.majorTickLength;
        newLabel.rotation = M_PI / 6;
        [labelArray addObject:newLabel];
        labelLocation++;
    }
    xAxis.axisLabels = [NSSet setWithArray:labelArray];
}

//画柱状图
- (void)drawHistogran{
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];

    lineStyle.lineWidth = 1.0f;

    yAxis.title=NSLocalizedString(@"Count",nil);
    
    CPTGradient *fillGradient;
    if ([self.tablename isEqualToString:NSLocalizedString(@"PlayTable",nil)]) {
        barPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0xF7/255.0 green:0x6E/255.0 blue:0x39/255.0 alpha:0xFF/255.0]];
        
          fillGradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithComponentRed:0xF7/255.0 green:0x6E/255.0 blue:0x39/255.0 alpha:0xFF/255.0] endingColor:[CPTColor colorWithComponentRed:0xF7/255.0 green:0x6E/255.0 blue:0x39/255.0 alpha:0xFF/255.0]];
        
        lineStyle.lineColor         = [CPTColor colorWithComponentRed:0xF7/255.0 green:0x6E/255.0 blue:0x39/255.0 alpha:0xFF/255.0];
    }else if([self.tablename isEqualToString:NSLocalizedString(@"BathTable",nil)]){
        barPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0x46/255.0 green:0x90/255.0 blue:0xCD/255.0 alpha:0xFF/255.0]];
        
          fillGradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithComponentRed:0x46/255.0 green:0x90/255.0 blue:0xCD/255.0 alpha:0xFF/255.0] endingColor:[CPTColor colorWithComponentRed:0x46/255.0 green:0x90/255.0 blue:0xCD/255.0 alpha:0xFF/255.0]];
        
        lineStyle.lineColor         = [CPTColor colorWithComponentRed:0x46/255.0 green:0x90/255.0 blue:0xCD/255.0 alpha:0xFF/255.0];
    }else if([self.tablename isEqualToString:NSLocalizedString(@"FeedTable",nil)]){
        barPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0x64/255.0 green:0xA7/255.0 blue:0x5B/255.0 alpha:0xFF/255.0]];
        
          fillGradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithComponentRed:0x64/255.0 green:0xA7/255.0 blue:0x5B/255.0 alpha:0xFF/255.0] endingColor:[CPTColor colorWithComponentRed:0x64/255.0 green:0xA7/255.0 blue:0x5B/255.0 alpha:0xFF/255.0]];
        
        lineStyle.lineColor         = [CPTColor colorWithComponentRed:0x64/255.0 green:0xA7/255.0 blue:0x5B/255.0 alpha:0xFF/255.0];
    }else if([self.tablename isEqualToString:NSLocalizedString(@"SleepTable",nil)]){
        barPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0xEA/255.0 green:0x6B/255.0 blue:0x72/255.0 alpha:0xFF/255.0]];
        
          fillGradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithComponentRed:0xEA/255.0 green:0x6B/255.0 blue:0x72/255.0 alpha:0xFF/255.0] endingColor:[CPTColor colorWithComponentRed:0xEA/255.0 green:0x6B/255.0 blue:0x72/255.0 alpha:0xFF/255.0]];
        
        lineStyle.lineColor         = [CPTColor colorWithComponentRed:0xEA/255.0 green:0x6B/255.0 blue:0x72/255.0 alpha:0xFF/255.0];
    }else{
        barPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0xDC/255.0 green:0xA8/255.0 blue:0x33/255.0 alpha:0xFF/255.0]];
        
          fillGradient = [CPTGradient gradientWithBeginningColor:[CPTColor colorWithComponentRed:0xDC/255.0 green:0xA8/255.0 blue:0x33/255.0 alpha:0xFF/255.0] endingColor:[CPTColor colorWithComponentRed:0xDC/255.0 green:0xA8/255.0 blue:0x33/255.0 alpha:0xFF/255.0]];
        
        lineStyle.lineColor         = [CPTColor colorWithComponentRed:0xDC/255.0 green:0xA8/255.0 blue:0x33/255.0 alpha:0xFF/255.0];
    }
    barPlot = [[CPTBarPlot alloc] init];
    barPlot.lineStyle = lineStyle;
  
    barPlot.fill = [CPTFill fillWithGradient:fillGradient];
    barPlot.baseValue = CPTDecimalFromString(@"0");
    barPlot.dataSource = self;
    barPlot.identifier = @"Bar Plot";
    barPlot.barWidth = CPTDecimalFromString(@"0.3");
    [graph addPlot:barPlot toPlotSpace:plotSpace];
}

//画曲线图
- (void)drawGraph:(NSString *)table {
    NSRange range = [table rangeOfString:@"("];
    
    if (range.length > 0) {
        table = [table substringToIndex:range.location];
    }
    yAxis.title=NSLocalizedString(@"Hours/h",nil);
    boundLinePlot  = [[CPTScatterPlot alloc] init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 1.0f;
    //曲线加点
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    if ([table isEqualToString:NSLocalizedString(@"PlayTable",nil)]) {
        lineStyle.lineColor         = [CPTColor colorWithComponentRed:0xF7/255.0 green:0x6E/255.0 blue:0x39/255.0 alpha:0xFF/255.0];
        plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0xF7/255.0 green:0x6E/255.0 blue:0x39/255.0 alpha:0xFF/255.0]];
    }else if([table isEqualToString:NSLocalizedString(@"BathTable",nil)]){
        lineStyle.lineColor         = [CPTColor colorWithComponentRed:0x46/255.0 green:0x90/255.0 blue:0xCD/255.0 alpha:0xFF/255.0];
        plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0x46/255.0 green:0x90/255.0 blue:0xCD/255.0 alpha:0xFF/255.0]];
    }else if([table isEqualToString:NSLocalizedString(@"FeedTable",nil)]){
        lineStyle.lineColor         = [CPTColor colorWithComponentRed:0x64/255.0 green:0xA7/255.0 blue:0x5B/255.0 alpha:0xFF/255.0];
        plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0x64/255.0 green:0xA7/255.0 blue:0x5B/255.0 alpha:0xFF/255.0]];
    }else if([table isEqualToString:NSLocalizedString(@"SleepTable",nil)]){
        lineStyle.lineColor         = [CPTColor colorWithComponentRed:0xEA/255.0 green:0x6B/255.0 blue:0x72/255.0 alpha:0xFF/255.0];
        plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0xEA/255.0 green:0x6B/255.0 blue:0x72/255.0 alpha:0xFF/255.0]];
    }else{
        lineStyle.lineColor         = [CPTColor colorWithComponentRed:0xDC/255.0 green:0xA8/255.0 blue:0x33/255.0 alpha:0xFF/255.0];
        plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0xDC/255.0 green:0xA8/255.0 blue:0x33/255.0 alpha:0xFF/255.0]];
            yAxis.title=NSLocalizedString(@"Count",nil);
    }
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.dataSource    = self;
    boundLinePlot.identifier = @"Single Plot";
    plotSymbol.size = CGSizeMake(2.0, 2.0);
    plotSymbol.lineStyle = lineStyle;
    boundLinePlot.plotSymbol = plotSymbol;
    [graph addPlot:boundLinePlot];
}

- (void)updateData:(NSString *)title andNewData:(NSArray *)data{
    dataSource = [NSMutableArray arrayWithArray:data];
    NSLog(@"updateData:%@",title);
    if ([plotArray count] > 0) {
        for (CPTScatterPlot *plot in plotArray) {
            [graph removePlot:plot];
        }
        [plotArray removeAllObjects];
        NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
        if (0 == [db integerForKey:@"SHUIBIAN"]) {
            [self drawHistogran];
        }else{
            [self drawGraph:title];
        }
    }else{
        [graph reloadData];
    }
}

- (void)reloadSpace:(float)Xrange andXlength:(float)Xlength andYplotRangeWithLocation:(float)Yrange andYlength:(float)Ylength andTableName:(NSString *)table andMaxDay:(int)maxday
{
    [self makeHostingView:table andXplotRangeWithLocation:Xrange andXlength:Xlength andYplotRangeWithLocation:Yrange andYlength:Ylength andXAxisTag:recordTag andMaxDay:maxday];
}

- (void)appearAllGraph:(NSString *)title andAllData:(NSArray *)data{
    [dataSource removeAllObjects];
    dataSource = [NSMutableArray arrayWithArray:data];
    if ([barPlot isKindOfClass:[CPTBarPlot class]]) {
        [graph removePlot:barPlot];
        self.barPlot = nil;
    }
    if ([boundLinePlot isKindOfClass:[CPTScatterPlot class]]) {
        [graph removePlot:boundLinePlot];
        self.boundLinePlot = nil;
    }
    [self drawMoreGraph:data];
}

//画多条曲线图
- (void)drawMoreGraph:(NSArray *)arr{
    if ([plotArray count] > 0) {
        for (CPTScatterPlot *plot in plotArray) {
            [graph removePlot:plot];
        }
        [plotArray removeAllObjects];
    }
    first = 0;
    for (int countIndex = 0; countIndex < [dataSource count]; countIndex++) {
        CPTScatterPlot *linePlot = [[CPTScatterPlot alloc] init];
        linePlot.dataSource = self;
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.miterLimit        = 1.0f;
        lineStyle.lineWidth         = 1.0f;
        //曲线加点
        CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
        switch (countIndex) {
            case 0:
                linePlot.identifier = @"Blue Plot";
                lineStyle.lineColor         = [CPTColor colorWithComponentRed:0xF7/255.0 green:0x6E/255.0 blue:0x39/255.0 alpha:0xFF/255.0];
                plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0xF7/255.0 green:0x6E/255.0 blue:0x39/255.0 alpha:0xFF/255.0]];
                break;
            case 1:
                linePlot.identifier = @"Yellow Plot";
                lineStyle.lineColor         = [CPTColor colorWithComponentRed:0x46/255.0 green:0x90/255.0 blue:0xCD/255.0 alpha:0xFF/255.0];
                plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0x46/255.0 green:0x90/255.0 blue:0xCD/255.0 alpha:0xFF/255.0]];
                break;
            case 2:
                linePlot.identifier = @"Red Plot";
                lineStyle.lineColor         = [CPTColor colorWithComponentRed:0x64/255.0 green:0xA7/255.0 blue:0x5B/255.0 alpha:0xFF/255.0];
                plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0x64/255.0 green:0xA7/255.0 blue:0x5B/255.0 alpha:0xFF/255.0]];
                break;
            case 3:
                linePlot.identifier = @"Purple Plot";
                lineStyle.lineColor         = [CPTColor colorWithComponentRed:0xEA/255.0 green:0x6B/255.0 blue:0x72/255.0 alpha:0xFF/255.0];
                plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0xEA/255.0 green:0x6B/255.0 blue:0x72/255.0 alpha:0xFF/255.0]];
                break;
            case 4:
                linePlot.identifier = @"Green Plot";
                lineStyle.lineColor         = [CPTColor colorWithComponentRed:0xDC/255.0 green:0xA8/255.0 blue:0x33/255.0 alpha:0xFF/255.0];
                plotSymbol.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0xDC/255.0 green:0xA8/255.0 blue:0x33/255.0 alpha:0xFF/255.0]];
                break;
        }
        linePlot.dataLineStyle = lineStyle;
        plotSymbol.size        = CGSizeMake(2.0, 2.0);
        plotSymbol.lineStyle   = lineStyle;
        linePlot.plotSymbol    = plotSymbol;
        [graph addPlot:linePlot];
        [plotArray addObject:linePlot];
    }
}

//协议回调方法
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    if ([plot.identifier isEqual:@"Single Plot"]) {
         return [[dataSource objectAtIndex:1] count];
    }else if ([plot.identifier isEqual:@"Bar Plot"]){
        return [[dataSource objectAtIndex:0] count];
    }else if([plot.identifier isEqual:@"Blue Plot"]){
        return [[dataSource objectAtIndex:0] count];
    }else if([plot.identifier isEqual:@"Yellow Plot"]){
        return [[dataSource objectAtIndex:1] count];
    }else if([plot.identifier isEqual:@"Red Plot"]){
        return [[dataSource objectAtIndex:2] count];
    }else if([plot.identifier isEqual:@"Purple Plot"]){
        return [[dataSource objectAtIndex:3] count];
    }else{
        return [[dataSource objectAtIndex:4] count];
    }
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = nil;
    if ([dataSource count] > 0) {
        id x = nil;
        id y = nil;
        switch (fieldEnum) {
            case CPTBarPlotFieldBarLocation:
                x = [NSNumber numberWithInt:index + 1];
                num = x;
                break;
            case CPTBarPlotFieldBarTip:
                if ([plot.identifier isEqual:@"Single Plot"] || [plot.identifier isEqual:@"Yellow Plot"]) {
                    y = [NSNumber numberWithFloat:[[[dataSource objectAtIndex:1] objectAtIndex:index] floatValue]];
                    num = y;
                }else if ([plot.identifier isEqual:@"Bar Plot"] || [plot.identifier isEqual:@"Blue Plot"]){
                    y = [NSNumber numberWithFloat:[[[dataSource objectAtIndex:0] objectAtIndex:index] floatValue]];
                    num = y;
                }else if([plot.identifier isEqual:@"Red Plot"]){
                    y = [NSNumber numberWithFloat:[[[dataSource objectAtIndex:2] objectAtIndex:index] floatValue]];
                    num = y;
                }else if([plot.identifier isEqual:@"Purple Plot"]){
                    y = [NSNumber numberWithFloat:[[[dataSource objectAtIndex:3] objectAtIndex:index] floatValue]];
                    num = y;
                }else{
                    y = [NSNumber numberWithFloat:[[[dataSource objectAtIndex:4] objectAtIndex:index] floatValue]];
                    num = y;
                }
                break;
        }
    }
    return num;
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index{
    if ([plot isKindOfClass:[CPTScatterPlot class]]) {
        CPTMutableTextStyle *textLineStyle = [CPTMutableTextStyle textStyle];
        textLineStyle.fontSize = 14;
        textLineStyle.color = [CPTColor blackColor];
        CPTTextLayer *label;
        if ([plot.identifier isEqual:@"Single Plot"] || [plot.identifier isEqual:@"Yellow Plot"]) {
            if ([[[dataSource objectAtIndex:1] objectAtIndex:index] floatValue] == 0) {
                label = [[CPTTextLayer alloc] initWithText:@""];
            }else{
                label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%0.1f", [[[dataSource objectAtIndex:1] objectAtIndex:index] floatValue]]];
            }
        }else if([plot.identifier isEqual:@"Blue Plot"]){
            if ([[[dataSource objectAtIndex:0] objectAtIndex:index] floatValue] == 0) {
                label = [[CPTTextLayer alloc] initWithText:@""];
            }else{
                label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%0.1f", [[[dataSource objectAtIndex:0] objectAtIndex:index] floatValue]]];
            }
        }else if([plot.identifier isEqual:@"Red Plot"]){
            if ([[[dataSource objectAtIndex:2] objectAtIndex:index] floatValue] == 0) {
                label = [[CPTTextLayer alloc] initWithText:@""];
            }else{
                label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%0.1f", [[[dataSource objectAtIndex:2] objectAtIndex:index] floatValue]]];
            }
        }else if([plot.identifier isEqual:@"Purple Plot"]){
            if ([[[dataSource objectAtIndex:3] objectAtIndex:index] floatValue] == 0) {
                label = [[CPTTextLayer alloc] initWithText:@""];
            }else{
                label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%0.1f", [[[dataSource objectAtIndex:3] objectAtIndex:index] floatValue]]];
            }
        }else{
            if ([[[dataSource objectAtIndex:4] objectAtIndex:index] floatValue] == 0) {
                label = [[CPTTextLayer alloc] initWithText:@""];
            }else{
                label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%0.1f", [[[dataSource objectAtIndex:4] objectAtIndex:index] floatValue]]];
            }
        }
        return label;
    }else{
        return nil;
    }
}

- (void)setCorePlotName:(NSString *)name{
    graph.title = name;
}

- (void)reloadCore{
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
    if (0 == [db integerForKey:@"SHUIBIAN"]) {
        if ([boundLinePlot isKindOfClass:[CPTScatterPlot class]]) {
            [graph removePlot:boundLinePlot];
            self.boundLinePlot = nil;
        }
        [self drawHistogran];
    }else{
        if ([barPlot isKindOfClass:[CPTBarPlot class]]) {
            [graph removePlot:barPlot];
            self.barPlot = nil;
        }
        NSString *title;
        NSString *comtitle;
        NSRange range = [graph.title rangeOfString:@"("];
        
        if (range.length > 0) {
            comtitle = [graph.title substringToIndex:range.location];
        }
        if ([comtitle isEqualToString:NSLocalizedString(@"Play", nil)])
        {
            title = @"Play";
        }
        if ([comtitle isEqualToString:NSLocalizedString(@"Diaper", nil)])
        {
            title = @"Diaper";
        }
        if ([comtitle isEqualToString:NSLocalizedString(@"Bath", nil)])
        {
            title = @"Bath";
        }
        if ([comtitle isEqualToString:NSLocalizedString(@"Sleep", nil)])
        {
            title = @"Sleep";
        }
        if ([comtitle isEqualToString:NSLocalizedString(@"Feed", nil)])
        {
            title = @"Feed";
        }
        [self drawGraph:title];
    }
}

@end
