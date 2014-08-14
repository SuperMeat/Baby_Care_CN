//
//  TempCorePlot.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-11.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"
@interface TempCorePlot : CPTGraphHostingView<CPTPlotDataSource>{
    float   yBaseValue;     // y轴坐标基础
    float   ySizeInterval;  // y轴坐标间隔
    
    
    /*
     *  y轴内容静态数组:温度
     *  Yaxis = @[@36,@36.5,@37,...]
     */
    NSArray * Yaxis;
    
    /*
     *  x轴内容数组: 序号   标题(时间)
     *  XaxisAndValue = @[@[@1,@"标题1",value],@[@2,@"标题2",45]]
     */
    NSArray * XaxisAndValue;
}
@property (retain, nonatomic)CPTGraph *graph;
-(id)initWithFrame:(CGRect)frame XasixAndValue:(NSArray*)arr;

@end
