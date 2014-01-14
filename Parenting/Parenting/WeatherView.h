//
//  WeatherView.h
//  Parenting
//
//  Created by user on 13-5-30.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdviseData;
@class AdviseLevel;
@interface WeatherView : UIView <UITableViewDataSource,UITableViewDelegate>
{

    BOOL         isgetted;
    UITableView *table;
    NSString    *tempcontent;
    int          templevel;
    //温度建议
    AdviseData  *mAdTemp;
    AdviseLevel *mAlTemp;
    
    //湿度建议
    AdviseData  *mAdHumi;
    AdviseLevel *mAlHumi;
    
}

+(id)weatherview;
@property (nonatomic,strong)  NSMutableArray  *dataarray;
@property (nonatomic, weak )id delete;
@property int chooseType;
-(void)makeview;
-(void)refreshweather;
@end
