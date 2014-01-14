//
//  OpenFunction.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-9-23.
//  Copyright (c) 2013年 爱摩信息科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "OpenFunction.h"
#import "APService.h"
#import "AlarmKey.h"

@implementation OpenFunction

+ (float) getSystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (void) openUserReviews
{
    //NSString *str = [NSString stringWithFormat:
    //                 @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",706557892];
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/bao-bei-ji-hua-jian-ban-rang/id706557892?mt=8"];
    https://itunes.apple.com/cn/app/bao-bei-ji-hua-jian-ban-rang/id706557892?mt=8
    //NSLog(@"openuserreviews %@ ", str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+(NSString*)getpm25description:(int)value
{
    NSString *desp;
    if (value <= 35) {
        desp = @"优";
    }
    else if (value <= 75)
    {
        desp = @"良";
    }
    else if (value <= 115)
    {
        desp = @"轻度";
    }
    else if (value <= 150)
    {
        desp = @"中度";
    }
    else if (value <= 250)
    {
        desp = @"重度";
    }
    else
    {
        desp = @"严重";
    }
    
    return desp;
}

+ (NSString*)getopenudid
{
    return [APService openUDID];
}

+ (NSString*)getWeekBeginAndEndWith:(NSDate *)newDate{
    NSLog(@"%@",newDate);
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//设定周日为周首日
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"MM.dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    return [NSString stringWithFormat:@"%@~%@",beginString,endString];
}

+ (NSString*)getMonthBeginAndEndWith:(NSDate *)newDate{
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//设定周日为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    return [NSString stringWithFormat:@"%@~%@",beginString,endString];
}

+(long)getTimeStampFromDate:(NSDate*)date
{
    return [[NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]] intValue];
}

+(NSDate*)getDateFromTimeStamp:(long)timestamp
{
       return [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)timestamp];
}

+(void)addLocalNotification:(NSString *)message
                  RepeatDay:(NSString *)repeatday
                   FireDate:(NSString *)fireDate
                   AlarmKey:(NSString *)alarmKey
{
    NSDate *now = [currentdate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    [calendar setFirstWeekday:1];
    comps=[calendar components:unitFlags fromDate:now];
    int setweekday;
    if ([repeatday isEqualToString:@"日"]) {
        setweekday = 1;
    }
    if ([repeatday isEqualToString:@"一"]) {
        setweekday = 2;
    }
    if ([repeatday isEqualToString:@"二"]) {
        setweekday = 3;
    }
    if ([repeatday isEqualToString:@"三"]) {
        setweekday = 4;
    }
    if ([repeatday isEqualToString:@"四"]) {
        setweekday = 5;
    }
    if ([repeatday isEqualToString:@"五"]) {
        setweekday = 6;
    }
    if ([repeatday isEqualToString:@"六"]) {
        setweekday = 7;
    }
    
    int n;
    if ([comps weekday] > setweekday) {
        n = 7 - [comps weekday] + setweekday;
    }
    else
    {
        n = setweekday - [comps weekday];
    }
    //NSLog(@"getdateformat : %@", time);
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    long time = [timeSp intValue] + 86400 * n;
     NSLog(@"timeSpln:%ld",time); //时间戳的值
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSCalendar *calendar2 = [NSCalendar currentCalendar];
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    NSInteger unitFlags2 = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    [calendar2 setFirstWeekday:1];
    comps2=[calendar2 components:unitFlags2 fromDate:date];
    
    NSString *settime = [NSString stringWithFormat:@"%d-%d-%d %@:00", [comps2 year], [comps2 month], [comps2 day], fireDate];
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        notification.fireDate  = [currentdate dateFromString:settime];
        notification.repeatInterval = kCFCalendarUnitWeek;
        notification.timeZone  = [NSTimeZone defaultTimeZone];
        notification.soundName = @"钟琴.m4a";
        notification.alertBody = message;
        notification.hasAction = YES;
        notification.userInfo  = [[NSDictionary alloc] initWithObjectsAndKeys:alarmKey,@"AlarmKey", nil];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }

}
//添加本地通知的方法
/*
 message:显示的内容
 firedate:闹钟的时间
 alarmKey:闹钟的ID
 */
+(void)addLocalNotificationWithMessage:(NSString *)message
                              FireDate:(NSDate *) fireDate
                              AlarmKey:(NSString *)alarmKey
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        
        notification.fireDate       = fireDate;
        notification.repeatInterval = kCFCalendarUnitWeek;
        notification.timeZone  = [NSTimeZone defaultTimeZone];
        notification.soundName = @"钟琴.m4a";
        notification.alertBody = message;
        notification.hasAction = NO;
        notification.userInfo  = [[NSDictionary alloc] initWithObjectsAndKeys:alarmKey,@"AlarmKey", nil];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
}

/*
 删除本地通知
 */
+(void)deleteLocalNotification:(NSString*) alarmKey
{
    NSArray * allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification * localNotification in allLocalNotification) {
        NSString * alarmValue=[localNotification.userInfo objectForKey:alarmKey];

        if ([alarmValue isEqualToString:@"AlarmKey"]) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
}
@end
