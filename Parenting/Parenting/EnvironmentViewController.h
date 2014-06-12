//
//  EnvironmentViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-4-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "ACViewController.h"

@interface EnvironmentViewController : ACViewController<BLEWeatherViewDelegate>
{
    UIButton * chooseIndoor;
    UIButton * chooseOutdoor;
    UILabel  * pmintro;
    UIImageView *adviseImageView;
    AdviseScrollview *adindoor;
    AdviseScrollview *adoutdoor;
}
@property(weak,nonatomic)WeatherView *weather;
@property(weak,nonatomic)BLEWeatherView *bleweather;
@end
