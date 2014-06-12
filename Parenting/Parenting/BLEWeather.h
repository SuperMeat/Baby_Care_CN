//
//  BLEWeather.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-1-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^GetBLEweather)(NSDictionary *weatherDict);

@interface BLEWeather : NSObject
{
    GetBLEweather getbleweatherBlock;
}

@property (nonatomic, strong) GetBLEweather getbleweatherBlock;
+(id)bleweather;
-(NSDictionary*)getbleweather;
-(void)getbleweather:(GetBLEweather) getbleweather;

+(void)setweatherfrombluetooth:(long)temp Humidity:(long)humi;
+(void)setlightfrombluetooth:(long)light;
+(void)setsoundfrombluetooth:(long)sound andmaxsound:(long)maxsound;
+(void)setuvfrombluetooth:(long)uv;
+(void)setpm25frombluetooth:(long)pm25;
+(long)gettemperature;
+(long)gethumidity;
+(double)getlight;
+(double)getsound;
+(long)getuv;
+(long)getpm25;

@end
