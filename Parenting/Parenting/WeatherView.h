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
    
    UILabel *tempDetail;
    UILabel *weatherStatus;
    UILabel *airDetail;
    UILabel *humiDetail;
    UILabel *smallStatus;
    UILabel *tomorrowStatus;
    UILabel *aftertomorrowStatus;
    
    //温度最高最低今天
    UILabel *temp1;
    UILabel *temp2;
    
    //温度最高最低明天
    UILabel *temp21;
    UILabel *temp22;
    
    //温度最高最低后天
    UILabel *temp31;
    UILabel *temp32;
    
    UIImageView *statusBigImageView;
    UIImageView *statusSmallImageView;
    UIImageView *statusTomorrowImageView;
    UIImageView *statusAfterTomorrowImageView;
    UIImageView *cutlineToday;
    UIImageView *cutlineTomorrow;
    UIImageView *cutlineAfterTomorrow;
    UIView *todayView;
    UIView *tomorrowView;
    UIView *aftertomorrowView;
}

+(id)weatherview;
@property (nonatomic,strong)  NSMutableArray  *dataarray;
@property (nonatomic, weak )id delete;
@property int chooseType;
-(void)makeview;
-(void)refreshweather;
@end
