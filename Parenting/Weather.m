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
                }
                else
                {
                    mycity = city;
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

    
//  UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"定位失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alter show];
//    return;

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
    NSArray *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (weatherDic == nil ||weatherDic.count == 1)
    {
        return nil;
    }
    else
    {
        NSDictionary *dic = [weatherDic lastObject];
        if (dic != nil && [dic count]>0) {
            NSNumber *aqi = [dic objectForKey:@"aqi"];
            return [NSString stringWithFormat:@"%@", aqi];
        }
    }
    
    return nil;
}

-(NSDictionary *)getweather
{
    NSMutableDictionary *envir=[[NSMutableDictionary alloc]init];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"weather"]) {
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
        
        if (CUSTOMER_COUNTRY == 1 && mycity) {
            NSString *pm25value = [self getweatherfromPM25in:mycity];
            if (pm25value != nil) {
                [envir setObject:pm25value forKey:@"PM25"];
            }
            
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:envir forKey:@"weather"];
    }
    else
    {
        envir=[[NSUserDefaults standardUserDefaults] objectForKey:@"weather"];
        if (CUSTOMER_COUNTRY == 1 && mycity) {
            if ([envir objectForKey:@"PM25"] == nil) {
                [envir setObject:[self getweatherfromPM25in:mycity] forKey:@"PM25"];
                [[NSUserDefaults standardUserDefaults] setObject:envir forKey:@"weather"];
            }
        }
        envir=[[NSUserDefaults standardUserDefaults] objectForKey:@"weather"];
    }
   
    return envir;
}

-(void)getweather:(Getweather) getweather
{
    self.getweatherBlock = getweather;

    [lm startUpdatingLocation];
}

@end
