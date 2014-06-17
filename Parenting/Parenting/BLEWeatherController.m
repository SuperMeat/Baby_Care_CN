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

-(void)stopbluetooth
{
    if (isBLEConnected) {
        [self.blecontroller bledisconnect];
    }
}

-(void)setbluetooth
{
    self.blecontroller = [[BLEController alloc] init];
    self.blecontroller.bleControllerDelegate = self;
    getDataTimeInterval = GETBLEDATATIMERAL;
    isFistTip = YES;
    [self checkbluetooth];
}

-(void)timeGo
{
    if (isTimeOut)
    {
        if (isFistTip) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"未搜索到相关设备,请确定\n①手机蓝牙已开启\n②环境监测配件已开启并在手机附近" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            isFistTip = NO;
        }
        [self.blecontroller stopscan];
        [checktimer invalidate];
        isFound = NO;
        [self checkbluetooth];
    }
}

#pragma -mark bluetooth delegate
-(void)BLEPowerOff:(BOOL)isPowerOff
{
    if (isBLEConnected) {
        isBLEConnected = NO;
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"" message:@"监测宝没有足够电量,请充电" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
}

-(void)DidConnected:(BOOL)isConnected
{
    if (!isBLEConnected) {
        isBLEConnected = isConnected;
        [self.blecontroller stopscan];
        [checktimer invalidate];
        //UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"" message:@"监测宝连接成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alter show];
        [self sendData];
    }
}

-(void)DisConnected:(BOOL)isConnected
{
    isFound    = NO;
    isTimeOut  = NO;
    isFistTime = YES;
    isFistTip  = YES;
    if (isBLEConnected) {
        isBLEConnected = isConnected;
        [gettimer invalidate];
        //UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"" message:@"监测宝已断开连接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alter show];
        [self checkbluetooth];
    }
}

-(void)scanResult:(BOOL)result with:(NSMutableArray  *)foundPeripherals
{
    if (!result) {
        isTimeOut=YES;
    }
    else
    {
        //Peripherals的名字跟配件名字匹配 如果不匹配还是提示错误
        if (!isFound && !isBLEConnected) {
            NSString *sysPeripheralsName =[[NSUserDefaults standardUserDefaults] objectForKey:@"BLE_ENV"];
            for (CBPeripheral *peripheral in foundPeripherals) {
                if ([sysPeripheralsName isEqualToString:[peripheral name]])
                {
                    //同步数据
                    [checktimer invalidate];
                    [self.blecontroller bleconnect];
                    isFound = YES;
                    break;
                }
            }
        }
    }
    
}

-(void)RecvHumiAndTempDada:(NSData*)data
{
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
                humidity    = ((humidityHigh+humidityLow) * 1.0 )/ 16383 * 100;
                temperature = ((temperatureHigh + temperatureLow) * 1.0 )/ 16383 / 4 * 165 - 40;
                
                if (temperature > TEMP_MAX_VALUE)
                {
                    [ACFunction addLocalNotificationWithMessage:[NSString stringWithFormat:@"宝贝计划监测宝温馨提醒您,温度过高,需开启空调或转移到凉快的室内,以确保宝宝能在适当温度下活动!"] FireDate:[ACDate date] AlarmKey:@"phonewarning"];
                }
                
                if (humidity > HUMI_MAX_VALUE)
                {
                    [ACFunction addLocalNotificationWithMessage:[NSString stringWithFormat:@"宝贝计划监测宝温馨提醒您,湿度过大,需开启除湿机,以确保宝宝能在适当湿度下活动!"] FireDate:[ACDate date] AlarmKey:@"phonewarning"];
                }
                
                [BLEWeather setweatherfrombluetooth:temperature Humidity:humidity];
            }
        }
    }
}

#define ALSIT 175
#define AGAIN 1
#define GA    0.49f
#define B     1.862f
#define C     0.746f
#define D     1.291f
#define DF    52 //DF 52 for APDS-9930
-(int)getlightluxwithCH0:(int)ch0 andCH1:(int)ch1
{
    double    IAC1 = ch0-B*ch1;
    double    IAC2 = C * ch0 - D * ch1;
    double    IAC =  MAX(MAX(IAC1, IAC2), 0);
    double    LPC = GA * DF / ((ALSIT * AGAIN)*1.0);
    int       Lux = IAC * LPC;
    return    Lux;
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
    
    curlux = [self getlightluxwithCH0:CH0 andCH1:CH1];
    if (curlux > LIGHT_MAX_VALUE)
    {
        [ACFunction addLocalNotificationWithMessage:[NSString stringWithFormat:@"宝贝计划监测宝温馨提醒您,光线强度过大,需为宝宝遮光或关闭灯光,以确保宝宝能在适当光线下活动!"] FireDate:[ACDate date] AlarmKey:@"phonewarning"];
    }

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
    if (uvvalue > UV_MAX_VALUE)
    {
        [ACFunction addLocalNotificationWithMessage:[NSString stringWithFormat:@"宝贝计划监测宝温馨提醒您,紫外线强度过大,需为宝宝采取防晒措施,以确保宝宝能在适宜的紫外强度下活动!"] FireDate:[ACDate date] AlarmKey:@"phonewarning"];
    }

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
            
            if (4 == i)
            {
                highmaxphone = [BLEController hexStringHighToInt:newHexStr];
            }
            
            if (5 == i)
            {
                phonevalue     = lowphone + highphone;
                maxphonethrans = (lowmaxphone + highmaxphone)/8192.0*3.32*1000;
            }
        }
    }
    
    phonethrans = phonevalue/8192.0*3.32*1000;
    if (maxphonethrans > NOICE_MAX_VALUE)
    {
        [ACFunction addLocalNotificationWithMessage:[NSString stringWithFormat:@"宝贝计划监测宝温馨提醒您,噪音指数过高,确定噪音来源,并且关闭或者远离,以确保宝宝能在安静环境下活动!"] FireDate:[ACDate date] AlarmKey:@"phonewarning"];
    }
    
    [BLEWeather setsoundfrombluetooth:phonethrans andmaxsound:maxphonethrans];
}

- (void)RecvPM25Data:(NSData*)data
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
                highpm25  = [BLEController hexStringHighToInt:newHexStr];
            }
            
            if (1 == i)
            {
                lowpm25 = [BLEController hexStringToInt:newHexStr];
            }
            
        
            if (3 == i)
            {
                pm25value = (lowpm25+highpm25)/8192.0*3.3*168;
            }
        }
    }
    
    if (pm25value > PM25_MAX_VALUE)
    {
        [ACFunction addLocalNotificationWithMessage:[NSString stringWithFormat:@"宝贝计划监测宝温馨提醒您,空气污染指数过高,需净化空气,以确保宝宝能在空气清新的环境下活动!"] FireDate:[ACDate date] AlarmKey:@"phonewarning"];
    }

    [BLEWeather setpm25frombluetooth:pm25value];
}

- (void)sendData{
    if (isBLEConnected) {
        if (isFistTime) {
            [self.blecontroller getTemperatureAndHumi];
            [self.blecontroller getLight];
            [self.blecontroller getMicrophone:0];
            [self.blecontroller getUV];
            [self.blecontroller getAir];
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
    if (getindex % 5 == 0) {
        [self.blecontroller getTemperatureAndHumi];
    }
    else if (getindex % 5 == 1)
    {
        [self.blecontroller getLight];
    }
    else if (getindex % 5 == 2)
    {
        [self.blecontroller getMicrophone:0];
    }
    else if (getindex % 5 == 3)
    {
        [self.blecontroller getUV];
    }
    else if (getindex % 5 == 4)
    {
        [self.blecontroller getAir];
    }
}

@end
