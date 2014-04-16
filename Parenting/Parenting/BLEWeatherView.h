//
//  BLEWeatherView.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-1-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEController.h"
@class AdviseData;
@class AdviseLevel;
@interface BLEWeatherView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    BOOL         isgetted;
    UITableView *table;
    //温度建议
    AdviseData  *mAdTemp;
    AdviseLevel *mAlTemp;
    
    //湿度建议
    AdviseData  *mAdHumi;
    AdviseLevel *mAlHumi;
    
    //光照建议
    AdviseData  *mAdLight;
    AdviseLevel *mAlLight;
    
    //噪音建议
    AdviseData  *mAdNoice;
    AdviseLevel *mAlNoice;
    
    //UV建议
    AdviseData  *mAdUV;
    AdviseLevel *mAlUV;
    
    //PM建议
    AdviseData  *mAdPM25;
    AdviseLevel *mAlPM25;
    BOOL isFistTime;
    NSTimer *gettimer;
    NSTimeInterval getDataTimeInterval;

}
+(id)weatherview;
@property (nonatomic,strong)  NSMutableArray  *dataarray;
@property (nonatomic, weak )id delete;
@property int chooseType;
-(void)makeview;
-(void)refreshweather;
@end
