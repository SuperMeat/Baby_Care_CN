//
//  MyCPTTheme.m
//  Parenting
//
//  Created by 家明 on 13-6-6.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "MyCPTTheme.h"

@implementation MyCPTTheme

- (void)applyThemeToBackground:(CPTGraph *)graph{
    // 终点色： 20 ％的灰度
    CPTColor *endColor = [CPTColor grayColor];
    // 创建一个渐变区：起点、终点都是 0.2 的灰度
    CPTGradient *graphGradient = [ CPTGradient gradientWithBeginningColor :endColor endingColor :endColor];
    // 设置中间渐变色 1 ，位置在 30 ％处，颜色为 3 0 ％的灰
    graphGradient = [graphGradient addColorStop :[CPTColor colorWithGenericGray : 0.3f ] atPosition : 0.3f ];
    // 设置中间渐变色 2 ，位置在 50 ％处，颜色为 5 0 ％的灰
    graphGradient = [graphGradient addColorStop :[CPTColor colorWithGenericGray : 0.5f ] atPosition : 0.5f ];
    // 设置中间渐变色 3 ，位置在 60 ％处，颜色为 3 0 ％的灰
    graphGradient = [graphGradient addColorStop :[CPTColor colorWithGenericGray : 0.3f ] atPosition : 0.6f ];
    // 渐变角度：垂直 90 度（逆时针）
    graphGradient. angle = 90.0f ;
    // 渐变填充
    graph. fill = [CPTFill fillWithGradient :graphGradient];
}

- (void)applyThemeToAxisSet:(CPTXYAxisSet *)axisSet{
    // 设置网格线线型
//    CPTMutableLineStyle *majorGridLineStyle = [CPTLineStyle lineStyle];
////    CPTLineStyle *majorGridLineStyle = [CPTLineStyle lineStyle];
//    majorGridLineStyle.lineWidth = 1.0f ;
//    majorGridLineStyle.lineColor = [CPTColor lightGrayColor ];
//    CPTXYAxis *axis = axisSet.yAxis;
//    // 轴标签方向： CPSignNone －无，同 CPSignNegative ， CPSignPositive －反向 , 在 y 轴的右边， CPSignNegative －正向，在 y 轴的左边
//    axis. tickDirection = CPTSignNegative ;
//    // 设置平行线，默认是以大刻度线为平行线位置
//    axis. majorGridLineStyle = majorGridLineStyle ;
    
    // 如果 labelingPolicy 设置为 CPAxisLabelingPolicyNone ， majorGridLineStyle 将不起作用
    //axis.labelingPolicy = CPAxisLabelingPolicyNone ;
}

- (void)applyThemeToPlotArea:(CPTPlotAreaFrame *)plotAreaFrame{
    // 创建一个 20 ％ -50 ％的灰色渐变区，用于设置绘图区。
    CPTGradient *gradient = [ CPTGradient gradientWithBeginningColor :[CPTColor colorWithComponentRed:0xEF/255.0 green:0xEF/255.0 blue:0xEF/255.0 alpha:0xFF/255.0] endingColor :[CPTColor colorWithComponentRed:0xEF/255.0 green:0xEF/255.0 blue:0xEF/255.0 alpha:0xFF/255.0]];
    gradient. angle = 45.0f ;
    // 渐变填充
    plotAreaFrame. fill = [ CPTFill fillWithGradient :gradient];
}

@end
