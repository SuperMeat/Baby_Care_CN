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
    NSString    *   Ctitle;
    NSArray     *   CxyRange;
    NSArray     *   CxyTitle;
    NSArray     *   Caxis;
    float   yBaseValue;
    float   ySizeInterval;
}
@property (retain, nonatomic)CPTGraph *graph;
 
-(id)initWithFrame:(CGRect)frame Title:(NSString*)title XYPlotRange:(NSArray*)xyRange XYTitle:(NSArray*)xyTitle Axis:(NSArray*)axis YBaseV:(float)yBaseV YSizeInterval:(float)ySizeInterval;

@end
