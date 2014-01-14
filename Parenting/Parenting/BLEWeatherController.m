//
//  BLEWeatherController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-1-13.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "BLEWeatherController.h"

@implementation BLEWeatherController
+(id)bleweathercontroller
{
    static dispatch_once_t pred;
    static BLEWeatherController *_sharedObject;
    dispatch_once(&pred, ^{
        _sharedObject = [[BLEWeatherController alloc] init];
    });
    return _sharedObject;
}

-(id)init
{
    self=[super init];
    if (self) {
        [self setbluetooth];
    }
    
    return self;
}

-(BOOL)isConnected
{
    return isBLEConnected;
}

-(void)checkbluetooth
{
    if (!isBLEConnected) {
        isFistTime = YES;
        isTimeOut = NO;
        isFound = NO;
        checktimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
        [self.blecontroller startscan];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"weatherbluetooth"];
    }
    else
    {
        NSLog(@"ble is connected!");
    }
}

-(void)setbluetooth
{
    self.blecontroller = [[BLEController alloc] init];
    self.blecontroller.bleControllerDelegate = self;
    getDataTimeInterval = 1.0;
    
    [self checkbluetooth];
}

-(void)timeGo
{
    if (isTimeOut && !isFound) {
        //连接失败,提醒距离
        [self.blecontroller stopscan];
        [checktimer invalidate];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"同步失败,请确定\n①手机蓝牙已开启\n②配件已开启并在手机附近" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        isFound = NO;
    }
}

#pragma -mark bluetooth delegate
-(void)BLEPowerOff:(BOOL)isPowerOff
{
    isBLEConnected = NO;
}

-(void)DidConnected:(BOOL)isConnected
{
    isBLEConnected = isConnected;
    [self sendData];
}

-(void)DisConnected:(BOOL)isConnected
{
    isBLEConnected = isConnected;
}

-(void)scanResult:(BOOL)result with:(NSMutableArray  *)foundPeripherals
{
    if (!result) {
        isTimeOut=YES;
    }
    else
    {
        //Peripherals的名字跟配件名字匹配 如果不匹配还是提示错误
        if (!isFound) {
            //NSString *sysPeripheralsName =[[NSUserDefaults standardUserDefaults] objectForKey:@"BLEPERIPHERAL_ACTIVITY"];
            //if ([sysPeripheralsName isEqualToString:[[foundPeripherals objectAtIndex:0] name]])
            {
                //同步数据
                [checktimer invalidate];
                [self.blecontroller bleconnect];
            }
            //            else
            //            {
            //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"同步失败,请确定\n①手机蓝牙已开启\n②配件已开启并在手机附近" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            //                [alert show];
            //            }
            isFound = YES;
            [self.blecontroller stopscan];
        }
    }
    
}

-(void)RecvHumiAndTempDada:(NSData*)data
{
    NSString *hexStr=@"";
    
    Byte *hexData = (Byte *)[data bytes];
    errorCode = 0;
    for(int i = 0; i<=[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",hexData[i]&0xff];
        int recv = [BLEController hexStringToInt:newHexStr];
        if (i == 0) {
            if (recv == 0) {
                errorCode = recv;
            }
            else{
                NSLog(@"error code : %d", recv);
            }
        }
        if (errorCode == 0)
        {
            ///16进制数
            if (i == 1) {
                humidityHigh = [BLEController hexStringHighToInt:newHexStr];
            }
            else if (i == 2)
            {
                humidityLow = [BLEController hexStringToInt:newHexStr];
            }
            else if (i == 3)
            {
                temperatureHigh = [BLEController hexStringHighToInt:newHexStr];
            }
            else if (i == 4)
            {
                temperatureLow = [BLEController hexStringToInt:newHexStr];
            }
            
            if (i == 5)
            {
                NSDateFormatter *dateFormator = [[NSDateFormatter alloc] init];
                dateFormator.dateFormat = @"yyyy-MM-dd  HH:mm:ss";
                NSString *date = [dateFormator stringFromDate:[NSDate date]];
                humidity    = ((humidityHigh+humidityLow) * 1.0 )/ 16383 * 100;
                temperature = ((temperatureHigh + temperatureLow) * 1.0 )/ 16383 / 4 * 165 - 40;
                hexStr = [NSString stringWithCString:[[NSString stringWithFormat:@"%@ 采集到的湿度:%ld %%, 温度:%ld !", date,humidity,temperature] UTF8String] encoding:NSUTF8StringEncoding];
                [BLEWeather setweatherfrombluetooth:temperature Humidity:humidity];
            }
        }
    }
}

-(double)getlightluxwithCH0:(double)ch0 andCH1:(double)ch1
{
    double lux = 0.0f;
    int  rate  = ch1/ch0*100;
    if (rate < 52) {
        lux = (0.0315*ch0)-(0.0593*ch0*pow(ch1/ch0, 1.4));
    }
    else if (rate < 65)
    {
        lux = (0.0229*ch0) - (0.0291*ch1);
    }
    else if (rate < 80)
    {
        lux = (0.0157*ch0) - (0.0180*ch1);
    }
    else if (rate < 130)
    {
        lux = (0.00338*ch0) - (0.00260*ch1);
    }
    else
    {
        lux = 0;
    }
    return lux;
}

-(void)RecvLightData:(NSData*)data
{
    Byte *hexData = (Byte *)[data bytes];
    for (int i=0;i<=[data length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",hexData[i]&0xff];
        int recv = [BLEController hexStringToInt:newHexStr];
        if (i == 0) {
            if (recv == 0) {
                errorCode = recv;
            }
            else{
                NSLog(@"error code : %d", recv);
            }
        }
        if (errorCode == 0)
        {
            
            ///16进制数
            if (i == 1) {
                lowlightChannel0 = [BLEController hexStringToInt:newHexStr];
            }
            else if (i == 2)
            {
                highlightChannel0 = [BLEController hexStringHighToInt:newHexStr];
            }
            else if (i == 3)
            {
                lowlightChannel1  = [BLEController hexStringToInt:newHexStr];
            }
            else if (i == 4)
            {
                highlightChannel1 = [BLEController hexStringHighToInt:newHexStr];
            }
            
            if ( 5 == i) {
                CH0 = lowlightChannel0 + highlightChannel0;
                CH1 = lowlightChannel1 + highlightChannel1;
            }
        }
    }
    
    curlux = [self getlightluxwithCH0:CH0*1.0 andCH1:CH1*1.0];
    [BLEWeather setlightfrombluetooth:curlux];
}

-(int)getuv:(float)output
{
    NSLog(@"getuv :%lf", output);
    int ret = 0;
    if (output < 1.04) {
        ret = 0;
    }
    else if (output < 1.12)
    {
        ret = 1;
    }
    else if (output < 1.20)
    {
        ret = 2;
    }
    else if (output < 1.28)
    {
        ret = 3;
    }
    else if (output < 1.36)
    {
        ret = 4;
    }
    else if (output < 1.44)
    {
        ret = 5;
    }
    else if (output < 1.52)
    {
        ret = 6;
    }
    else if (output < 1.60)
    {
        ret = 7;
    }
    else if (output < 1.68)
    {
        ret = 8;
    }
    else if (output < 1.76)
    {
        ret = 9;
    }
    else if (output < 1.84)
    {
        ret = 10;
    }
    else if (output < 1.92)
    {
        ret = 11;
    }
    else if (output < 2.00)
    {
        ret = 12;
    }
    else if (output < 2.08)
    {
        ret = 13;
    }
    else if (output < 2.16)
    {
        ret = 14;
    }
    else if (output < 2.24)
    {
        ret = 15;
    }
    else if (output < 2.32)
    {
        ret = 16;
    }
    else if (output < 2.40)
    {
        ret = 17;
    }
    else if (output < 2.48)
    {
        ret = 18;
    }
    else if (output < 2.56)
    {
        ret = 19;
    }
    else
    {
        ret = 20;
    }
    
    return ret;
}

-(void)RecvUVData:(NSData*)data
{
    Byte *hexData = (Byte *)[data bytes];
    for (int i=0;i<=[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",hexData[i]&0xff];
        int recv = [BLEController hexStringToInt:newHexStr];
        if (i == 0) {
            if (recv == 0) {
                errorCode = recv;
            }
            else{
                NSLog(@"error code : %d", recv);
            }
        }
        
        if (errorCode == 0)
        {
            
            //16进制数
            if (i == 1) {
                lowuv  = [BLEController hexStringToInt:newHexStr];
            }
            
            if (2 == i)
            {
                highuv = [BLEController hexStringHighToInt:newHexStr];
            }
            
            if (3 == i)
            {
                adcoutput = lowuv + highuv;
            }
            
        }
        
    }
    float adc_v = adcoutput/8192.0*3.32;
    
    uvvalue = [self getuv:adc_v];
    [BLEWeather setuvfrombluetooth:uvvalue];
}

-(void)RecvMicroPhone:(NSData*)data
{
    Byte *hexData = (Byte *)[data bytes];
    for (int i=0;i<=[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%02x",hexData[i]&0xff];
        int recv = [BLEController hexStringToInt:newHexStr];
        if (i == 0) {
            if (recv == 0) {
                errorCode = recv;
            }
            else{
                NSLog(@"error code : %d", recv);
            }
        }
        
        if (errorCode == 0)
        {
            
            //16进制数
            if (i == 2) {
                highphone  = [BLEController hexStringHighToInt:newHexStr];
            }
            
            if (1 == i)
            {
                lowphone = [BLEController hexStringToInt:newHexStr];
            }
            
            if (3 == i) {
                lowmaxphone = [BLEController hexStringToInt:newHexStr];
            }
            
            if (4 == i) {
                highmaxphone = [BLEController hexStringHighToInt:newHexStr];
            }
            
            
            if (3 == i)
            {
                phonevalue     = lowphone + highphone;
                maxphonethrans = 94+20.0*log10(((lowmaxphone + highmaxphone)/8192.0*3.32)*1.0);
            }
        }
    }
    
    phonethrans = phonevalue*1.0*8192.0/3.32;
    
    [BLEWeather setsoundfrombluetooth:phonethrans andmaxsound:maxphonethrans];
}

- (void)sendData{
    if (isBLEConnected) {
        if (isFistTime) {
            [_blecontroller getTemperatureAndHumi];
            [_blecontroller getLight];
            [_blecontroller getMicrophone:0];
            [_blecontroller getUV];
            isFistTime = NO;
        }
        
        gettimer = [NSTimer scheduledTimerWithTimeInterval: getDataTimeInterval
                                                    target: self
                                                  selector: @selector(handleTimer:)
                                                  userInfo: nil
                                                   repeats: YES];
    }
    
}

- (void) handleTimer: (NSTimer *) timer
{
    //在这里进行处理
    getindex++;
    [_blecontroller getMicrophone:1];
    if (getindex % 4 == 0) {
        [self.blecontroller getTemperatureAndHumi];
    }
    else if (getindex % 4 == 1)
    {
        [self.blecontroller getLight];
    }
    else if (getindex % 4 == 2)
    {
        [self.blecontroller getMicrophone:0];
    }
    else if (getindex % 4 == 3)
    {
        [self.blecontroller getUV];
    }
    
    if (isBLEConnected)
    {
        //[self.bleweatherControllerDelegate updatedataarray];
    }
}

@end
