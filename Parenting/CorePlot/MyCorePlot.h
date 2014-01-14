//
//  MyCorePlot.h
//  bbtest
//
//  Created by 家明 on 13-5-28.
//  Copyright (c) 2013年 FengLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"


@interface MyCorePlot : CPTGraphHostingView<CPTPlotDataSource>{
    NSMutableArray *plotArray;
    int first;
    int recordTag;
    int moreLine;
    CPTXYAxis *yAxis;
}

@property (retain, nonatomic)CPTXYGraph *graph;
@property (retain, nonatomic)CPTXYPlotSpace *plotSpace;
@property (retain, nonatomic)NSMutableArray *dataSource;
@property (retain, nonatomic)CPTBarPlot     *barPlot;
@property (retain, nonatomic)CPTScatterPlot *boundLinePlot;
@property(nonatomic,strong)NSString *tablename;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andXplotRangeWithLocation:(float)Xrange andXlength:(float)Xlength andYplotRangeWithLocation:(float)Yrange andYlength:(float)Ylength andDataSource:(NSArray*)data andXAxisTag:(int)tag andMaxDay:(int)maxday;
//更新数据
- (void)updateData:(NSString *)title andNewData:(NSArray*)data;
//显示全部持续时间曲线图
- (void)appearAllGraph:(NSString *)title andAllData:(NSArray *)data;

- (void)setCorePlotName:(NSString *)name;
- (void)reloadSpace:(float)Xrange andXlength:(float)Xlength andYplotRangeWithLocation:(float)Yrange andYlength:(float)Ylength andTableName:(NSString *)table andMaxDay:(int)maxday;

@end
