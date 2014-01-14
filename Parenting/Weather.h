//
//  Weather.h
//  Parenting
//
//  Created by user on 13-5-29.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void(^Getweather)(NSDictionary *weatherDict);

@class GDataXMLNode;
@interface Weather : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *lm;
    NSMutableData *Mydata;
    CLLocationCoordinate2D  userCoordinate;
    Getweather getweatherBlock;
    NSString* mycity;
}

@property (nonatomic, strong) Getweather getweatherBlock;

+(id)weather;
-(NSDictionary*)getweather;
-(void)getweather:(Getweather) getweather;

@end
