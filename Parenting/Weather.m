//
//  Weather.m
//  Parenting
//
//  Created by user on 13-5-29.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "Weather.h"
#import "GDataXMLNode.h"
@implementation Weather
@synthesize getweatherBlock;
-(void)dealloc
{
    self.getweatherBlock = nil;

}
+(id)weather
{

    __strong static id _sharedObject = nil;

        _sharedObject = [[self alloc] init]; // or some other init method
        
    return _sharedObject;
}
-(id)init
{
    self=[super init];
    if (self) {
        lm=[[CLLocationManager alloc]init];
        lm.delegate=self;
        lm.desiredAccuracy=kCLLocationAccuracyBest;
        lm.distanceFilter=5;
    }

    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation");
    [lm stopUpdatingLocation];
    userCoordinate = newLocation.coordinate;
    
    //NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            //NSString *country = placemark.ISOcountryCode;
            NSString *city = placemark.locality;
            if (city != nil) {
                if ([currentLanguage compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [currentLanguage compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame) {
                    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:city];
                    
                    [mutableString deleteCharactersInRange:NSMakeRange([mutableString length]-1, 1)];
                    
                    mycity = mutableString;
                    [[NSUserDefaults standardUserDefaults] setObject:mycity forKey:@"mylocation"];
                }
                else
                {
                    mycity = city;
                    [[NSUserDefaults standardUserDefaults] setObject:mycity forKey:@"mylocation"];
                }

            }
        }
    }];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.getweatherBlock) {
            NSDictionary *dict = [self getweather];
            getweatherBlock(dict);
        }
    });
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

-(NSString*)yql
{
    CLLocationCoordinate2D coordinate=userCoordinate;
    NSString *str=[NSString stringWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=select woeid from geo.placefinder where text=\"%f,%f\" and gflags=\"R\"",coordinate.latitude,coordinate.longitude];
    str=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    
    str=[NSString stringWithContentsOfURL:[NSURL URLWithString:str] encoding:NSUTF8StringEncoding error:nil];
    return str;
}

-(NSString*)getWOEID
{
    [self yql];
    
    //NSLog(@"%@",[self yql]);
    
    GDataXMLDocument *xml=[[GDataXMLDocument alloc]initWithXMLString:[self yql] options:0 error:nil];
    NSArray *array=[xml nodesForXPath:@"/query/results/Result/woeid" error:nil];
    for (GDataXMLElement *item  in array) {
        return item.stringValue;
    }
    return nil;
}

- (NSString*)getweatherfromPM25in:(NSString*)city
{
    if (city == nil) {
        return [NSString stringWithFormat:@"%d", 0];
    }
    
    NSArray  *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    NSString *location;
    //NSLog(@"%@, %@", languages, currentLanguage);
    if ([currentLanguage compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [currentLanguage compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        location = [ChineseToPinyin pinyinFromChiniseString:city];
    }
    else
    {
        location = city;
    }
    
    // Convert string to lowercase
    location = [location lowercaseStringWithLocale:[NSLocale currentLocale]];
    
    //NSLog(@"lowerStr: %@", lowerStr);
    NSURL *URL =[NSURL URLWithString:[NSString stringWithFormat:@"http://www.pm25.in/api/querys/pm2_5.json?city=%@&token=%@", location, PM25INTOKEN]];
    NSError *error;
    NSString *stringFromFileAtURL = [[NSString alloc]
                                     initWithContentsOfURL:URL
                                     encoding:NSUTF8StringEncoding
                                     error:&error];
    
    NSData *data = [stringFromFileAtURL dataUsingEncoding:NSUTF8StringEncoding];
    if (data != nil)
    {
        NSArray *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (weatherDic == nil ||weatherDic.count == 1)
        {
            return [NSString stringWithFormat:@"%d", 0];
        }
        else
        {
            NSDictionary *dic = [weatherDic lastObject];
            if (dic != nil && [dic count]>0) {
                NSNumber *aqi = [dic objectForKey:@"aqi"];
                return [NSString stringWithFormat:@"%@", aqi];
            }
        }
    }
    return [NSString stringWithFormat:@"%d", 0];
}

-(NSDictionary *)getWeatherFromSina:(NSString*)city andByDay:(int)day
{
    NSString *key = @"";
    if (day == 0) {
        key = @"weathertoday";
    }
    else if (day == 1)
    {
        key = @"weathertomorrow";
    }
    else
    {
        key = @"weatheraftertomorrow";
    }
    
    
    NSMutableDictionary *envir=[[NSMutableDictionary alloc]init];
    
    NSStringEncoding chineseEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    city = [city stringByAddingPercentEscapesUsingEncoding:chineseEncoding];
    
    NSString* str = [NSString stringWithFormat:@"http://php.weather.sina.com.cn/xml.php?city=%@&password=DJOYnieT8234jlsK&day=%d",city, day];
    
    NSLog(@"%@",str);
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *citystring = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    GDataXMLDocument *xml=[[GDataXMLDocument alloc]initWithXMLString:citystring options:1 error:nil];
    
    GDataXMLElement *root = [xml rootElement];
    NSArray *rootarray = [root children];
    GDataXMLElement  *channeName = [rootarray objectAtIndex:0];
    NSArray *array = [channeName children];
    for (GDataXMLElement *item  in array)
    {
        NSArray *itemArray = [item children];
        if ([[item name] isEqualToString:@"status1"] && [itemArray count]>0)
        {
            [envir setObject: [[itemArray objectAtIndex:0] stringValue] forKey:@"weatherstatus"];
        }
        
        if ([[item name] isEqualToString:@"temperature1"] && [itemArray count]>0)
        {
            [envir setObject: [[itemArray objectAtIndex:0] stringValue] forKey:@"temperature1"];
        }
        
        if ([[item name] isEqualToString:@"temperature2"] && [itemArray count]>0)
        {
            [envir setObject: [[itemArray objectAtIndex:0] stringValue] forKey:@"temperature2"];
        }
        
        if ([[item name] isEqualToString:@"zwx_s"] && [itemArray count]>0)
        {
            [envir setObject: [[itemArray objectAtIndex:0] stringValue] forKey:@"zwx_s"];
        }
        
        if ([[item name] isEqualToString:@"pollution_l"] && [itemArray count]>0)
        {
            [envir setObject: [[itemArray objectAtIndex:0] stringValue] forKey:@"pollution_l"];
        }


    }
    
    if ([envir count] > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:envir forKey:key];
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

-(NSDictionary *)getWeatherDetail:(int)type
{
    switch (type) {
        case 0:
            return [[NSUserDefaults standardUserDefaults] objectForKey:@"weathertoday"];
        case 1:
            return [[NSUserDefaults standardUserDefaults] objectForKey:@"weathertomorrow"];
        case 2:
            return [[NSUserDefaults standardUserDefaults] objectForKey:@"weatheraftertomorrow"];
        default:
            break;
    }
    
    return nil;
}

-(NSDictionary *)getweather
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"weather"])
    {
        NSMutableDictionary *envir=[[NSMutableDictionary alloc]init];
        NSString *str=[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c",[self getWOEID]];
        
        str=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        str=[NSString stringWithContentsOfURL:[NSURL URLWithString:str] encoding:NSUTF8StringEncoding error:nil];
        
        GDataXMLDocument *xml=[[GDataXMLDocument alloc]initWithXMLString:str options:1 error:nil];
        NSDictionary *namespace=[NSDictionary dictionaryWithObjectsAndKeys:@"http://xml.weather.yahoo.com/ns/rss/1.0",@"yweather", nil];
        NSArray *array=[xml nodesForXPath:@"//yweather:atmosphere" namespaces:namespace error:nil];
        
        for (GDataXMLElement *item  in array) {
            ;
            [envir setObject:[[item attributeForName:@"humidity"]stringValue] forKey:@"humidity"];
            break;
            
        }
        array=[xml nodesForXPath:@"//yweather:condition" namespaces:namespace error:nil];
        for(GDataXMLElement *item in array)
        {
            [envir setObject:[[item attributeForName:@"temp"]stringValue] forKey:@"temp"];
            
        }
        
        mycity = [[NSUserDefaults standardUserDefaults] objectForKey:@"mylocation"];
        if (CUSTOMER_COUNTRY == 1 && mycity) {
            [self getWeatherFromSina:mycity andByDay:0];
            [self getWeatherFromSina:mycity andByDay:1];
            [self getWeatherFromSina:mycity andByDay:2];

            NSString *pm25value = [self getweatherfromPM25in:mycity];
            if (pm25value != nil) {
                [envir setObject:pm25value forKey:@"PM25"];
            }
            
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:envir forKey:@"weather"];
    }
    else
    {
        NSDictionary *envir=[[NSUserDefaults standardUserDefaults] objectForKey:@"weather"];
         mycity = [[NSUserDefaults standardUserDefaults] objectForKey:@"mylocation"];
        if (CUSTOMER_COUNTRY == 1 && mycity)
        {
            [self getWeatherFromSina:mycity andByDay:0];
            [self getWeatherFromSina:mycity andByDay:1];
            [self getWeatherFromSina:mycity andByDay:2];
            
            if ([envir objectForKey:@"PM25"] == nil)
            {
                NSMutableDictionary *newenvir=[[NSMutableDictionary alloc]init];
                if ([envir objectForKey:@"temp"] != nil) {
                    [newenvir setObject:[envir objectForKey:@"temp"] forKey:@"temp"];
                }
                
                if ([envir objectForKey:@"humidity"] != nil) {
                    [newenvir setObject:[envir objectForKey:@"humidity"] forKey:@"humidity"];
                }
                [newenvir setObject:[self getweatherfromPM25in:mycity] forKey:@"PM25"];
                [[NSUserDefaults standardUserDefaults] setObject:newenvir forKey:@"weather"];
            }
        }
    }
   
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"weather"];
}

- (NSString*)weatherCodeToString:(int)Code
{
    switch(Code){
        case 0:
            return @"龙卷风";
        case 1:
            return @"热带风暴";
        case 2:
            return @"暴风";
        case 3:
            return @"大雷雨";
        case 4:
            return @"雷阵雨";
        case 5:
            return @"雨夹雪";
        case 6:
            return @"雨夹雹";
        case 7:
            return @"雪夹雹";
        case 8:
            return @"冻雾雨";
        case 9:
            return @"细雨";
        case 10:
            return @"冻雨";
        case 11:
            return @"阵雨";
        case 12:
            return @"阵雨";
        case 13:
            return @"阵雪";
        case 14:
            return @"小阵雪";
        case 15:
            return @"高吹雪";
        case 16:
            return @"雪";
        case 17:
            return @"冰雹";
        case 18:
            return @"雨淞";
        case 19:
            return @"粉尘";
        case 20:
            return @"雾";
        case 21:
            return @"薄雾";
        case 22:
            return @"烟雾";
        case 23:
            return @"大风";
        case 24:
            return @"风";
        case 25:
            return @"冷";
        case 26:
            return @"阴";
        case 27:
            return @"多云";
        case 28:
            return @"多云";
        case 29:
            return @"局部多云";
        case 30:
            return @"局部多云";
        case 31:
            return @"晴";
        case 32:
            return @"晴";
        case 33:
            return @"转晴";
        case 34:
            return @"转晴";
        case 35:
            return @"雨夹冰雹";
        case 36:
            return @"热";
        case 37:
            return @"局部雷雨";
        case 38:
            return @"偶有雷雨";
        case 39:
            return @"偶有雷雨";
        case 40:
            return @"偶有阵雨";
        case 41:
            return @"大雪";
        case 42:
            return @"零星阵雪";
        case 43:
            return @"大雪";
        case 44:
            return @"局部多云";
        case 45:
            return @"雷阵雨";
        case 46:
            return @"阵雪";
        case 47:
            return @"局部雷阵雨";
        default:
            return @"水深火热";
    }
}

-(void)getweather:(Getweather) getweather
{
    self.getweatherBlock = getweather;

    [lm startUpdatingLocation];
}

@end
