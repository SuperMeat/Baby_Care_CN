//
//  BLEWeather.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-1-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "BLEWeather.h"

@implementation BLEWeather
@synthesize getbleweatherBlock;
-(void)dealloc
{
    self.getbleweatherBlock = nil;
    
}
+(id)bleweather
{
    
    __strong static id _sharedObject = nil;
    
    _sharedObject = [[self alloc] init]; // or some other init method
    
    return _sharedObject;
}
-(id)init
{
    self=[super init];
    
    return self;
}

-(NSDictionary *)getbleweather
{
    NSMutableDictionary *envir=[[NSMutableDictionary alloc]init];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"])
    {
        [envir setValue:[NSString stringWithFormat:@"0"] forKey:@"temp"];
        [envir setValue:[NSString stringWithFormat:@"0"] forKey:@"humidity"];
        [envir setValue:[NSString stringWithFormat:@"0"] forKey:@"light"];
        [envir setValue:[NSString stringWithFormat:@"0"] forKey:@"sound"];
        [envir setValue:[NSString stringWithFormat:@"0"] forKey:@"maxsound"];

        [envir setValue:[NSString stringWithFormat:@"0"] forKey:@"uv"];
        
        [[NSUserDefaults standardUserDefaults] setObject:envir forKey:@"weatherbluetooth"];
    }
    else
    {
        envir=[[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"];
    }
    
    return envir;
}

+(void)setweatherfrombluetooth:(long)temp Humidity:(long)humi
{
    //[[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"weatherbluetooth"];
    NSDictionary *envir = [[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"];
    NSLog(@"setweatherfrombluetooth :%ld, %ld", temp,humi);
    if (envir == nil)
    {
        NSMutableDictionary *envir=[[NSMutableDictionary alloc]init];
        [envir setValue:[NSString stringWithFormat:@"%ld",temp] forKey:@"temp"];
        [envir setValue:[NSString stringWithFormat:@"%ld",humi] forKey:@"humidity"];
        
        [[NSUserDefaults standardUserDefaults] setObject:envir forKey:@"weatherbluetooth"];
    }
    else
    {
        NSLog(@"%@", envir);
        NSMutableDictionary *envir2 = [[NSMutableDictionary alloc] initWithDictionary:envir];
        [envir2 setValue:[NSString stringWithFormat:@"%ld",temp] forKey:@"temp"];
        [envir2 setValue:[NSString stringWithFormat:@"%ld",humi] forKey:@"humidity"];
        [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"weatherbluetooth"];
        [[NSUserDefaults standardUserDefaults] setObject:envir2 forKey:@"weatherbluetooth"];
    }
}

+(void)setlightfrombluetooth:(double)light
{
    NSDictionary *envir = [[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"];
    NSLog(@"setlightfrombluetooth :%lf", light);
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"])
    {
        NSMutableDictionary *envir=[[NSMutableDictionary alloc]init];
        [envir setValue:[NSString stringWithFormat:@"%lf",light] forKey:@"light"];
        [[NSUserDefaults standardUserDefaults] setObject:envir forKey:@"weatherbluetooth"];
    }
    else
    {
        NSLog(@"%@", envir);
        NSMutableDictionary *envir2 = [[NSMutableDictionary alloc] initWithDictionary:envir];

        [envir2 setValue:[NSString stringWithFormat:@"%lf",light] forKey:@"light"];
        [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"weatherbluetooth"];
        [[NSUserDefaults standardUserDefaults] setObject:envir2 forKey:@"weatherbluetooth"];

    }
}

+(void)setsoundfrombluetooth:(double)sound andmaxsound:(double)maxsound
{
    NSDictionary *envir = [[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"];

    NSLog(@"setsoundfrombluetooth sound:%lf, maxsound:%lf", sound, maxsound);
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"])
    {
        NSMutableDictionary *envir=[[NSMutableDictionary alloc]init];
        [envir setValue:[NSString stringWithFormat:@"%lf",sound] forKey:@"sound"];
        
        [envir setValue:[NSString stringWithFormat:@"%lf",maxsound] forKey:@"maxsound"];
        
        [[NSUserDefaults standardUserDefaults] setObject:envir forKey:@"weatherbluetooth"];
    }
    else
    {
        NSMutableDictionary *envir2 = [[NSMutableDictionary alloc] initWithDictionary:envir];
        
        [envir2 setValue:[NSString stringWithFormat:@"%lf",sound] forKey:@"sound"];
        [envir2 setValue:[NSString stringWithFormat:@"%lf",maxsound] forKey:@"maxsound"];
        [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"weatherbluetooth"];
        [[NSUserDefaults standardUserDefaults] setObject:envir2 forKey:@"weatherbluetooth"];
       
    }
}

+(void)setuvfrombluetooth:(long)uv
{
    //[[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"weatherbluetooth"];
    NSDictionary *envir = [[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"];
    
    NSLog(@"setuvfrombluetooth : %ld", uv);
    //NSMutableDictionary *envir=[[NSMutableDictionary alloc]init];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"])
    {
        NSMutableDictionary *envir=[[NSMutableDictionary alloc]init];
        [envir setValue:[NSString stringWithFormat:@"%ld",uv] forKey:@"uv"];
        [[NSUserDefaults standardUserDefaults] setObject:envir forKey:@"weatherbluetooth"];
    }
    else
    {
        NSMutableDictionary *envir2 = [[NSMutableDictionary alloc] initWithDictionary:envir];
        
        [envir2 setValue:[NSString stringWithFormat:@"%ld",uv] forKey:@"uv"];
        [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"weatherbluetooth"];
        [[NSUserDefaults standardUserDefaults] setObject:envir2 forKey:@"weatherbluetooth"];
    }
}

+(long)gettemperature{
    NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"];
    if([[dict objectForKey:@"temp"] length]>0)
    {
        return [[NSString stringWithFormat:@"%@",[dict objectForKey:@"temp"]]intValue];
    }
    
    return 0;
}

+(long)gethumidity
{
    NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"];
    if([[dict objectForKey:@"humidity"] length]>0)
    {
        return [[NSString stringWithFormat:@"%@",[dict objectForKey:@"humidity"]]intValue];
    }
    
    return 0;
}

+(double)getlight{
    NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"];
    if([[dict objectForKey:@"light"] length]>0)
    {
        return [[NSString stringWithFormat:@"%@",[dict objectForKey:@"light"]]doubleValue];
    }
    
    return 0.0;
}

+(double)getsound{
    NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"];
    if([[dict objectForKey:@"maxsound"] length]>0)
    {
        return [[NSString stringWithFormat:@"%@",[dict objectForKey:@"maxsound"]]intValue];
    }
    
    return 0;
}

+(long)getuv{
    NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults] objectForKey:@"weatherbluetooth"];
    if([[dict objectForKey:@"uv"] length]>0)
    {
        return [[NSString stringWithFormat:@"%@",[dict objectForKey:@"uv"]]intValue];
    }
    
    return 0;
}

-(void)getbleweather:(GetBLEweather) getbleweather
{
    self.getbleweatherBlock = getbleweather;
}
@end
