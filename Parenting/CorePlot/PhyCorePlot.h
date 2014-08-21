//
//  PhyCorePlot.h
//  Physiological
//
//  Created by CHEN WEIBIN on 14-1-22.
//  Copyright (c) 2014年 CHEN WEIBIN. All rights reserved.
//

#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"

@interface PhyCorePlot : CPTGraphHostingView<CPTPlotDataSource>{
    NSArray *xAxis,*yAxis;          //XY轴刻度值
    double yBase,xBase;             //XY轴基础值
    double yInterval,xInterval;     //XY轴单位度量
    NSString *titleG;               //画布标题
    NSString *titleX,*titleY;       //XY轴标题
    int xLen,yLen;                  //XY轴数据长度
    CPTPlotRange *xRange,*yRange;   //XY轴显示范围
    
    NSArray *arrUser,*arrP75,*arrP25;               //用户数据
    CPTColor *colorUser,*colorP25,*colorP75;             //用户数据线颜色
}
@property (retain, nonatomic)CPTGraph *graph;

-(id)initWithFrame:(CGRect)frame
          UserAxis:(NSArray*)userAxis
        HeightAxis:(NSArray*)heightAxis
           LowAxis:(NSArray*)lowAxis
             XAxis:(NSArray*)x
             YAxis:(NSArray*)y
            XTitle:(NSString*)tX
            YTitle:(NSString*)tY;

@end
