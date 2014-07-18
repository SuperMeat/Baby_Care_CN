//
//  ACFunction.m
//  ACBase
//
//  Created by @Arvi@ on 14-3-19.
//  Copyright (c) 2014年 com.amoycare. All rights reserved.
//

#import "ACFunction.h"

@implementation ACFunction
+ (float) getSystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (void) openUserReviews
{
    NSString *str = [NSString stringWithFormat:REVIEW_URL];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+(void)addLocalNotification:(NSString *)message
                  RepeatDay:(NSString *)repeatday
                   FireDate:(NSString *)fireDate
                   AlarmKey:(NSString *)alarmKey
{
    NSDate *now = [NSDate date];
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
        notification.fireDate  = [ACDate dateFromString:settime];
        notification.repeatInterval = kCFCalendarUnitWeek;
        notification.timeZone  = [NSTimeZone defaultTimeZone];
        notification.soundName = @"钟琴.m4a";
        notification.alertBody = message;
        notification.hasAction = YES;
        notification.userInfo  = [[NSDictionary alloc] initWithObjectsAndKeys:alarmKey,alarmKey, nil];
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
        
        notification.fireDate  = fireDate;
        notification.timeZone  = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody = message;
        notification.hasAction = YES;
        notification.userInfo  = [[NSDictionary alloc] initWithObjectsAndKeys:alarmKey,alarmKey, nil];
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
        if ([alarmValue isEqualToString:alarmKey]) {
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
}

+ (UIColor *) colorWithHexString:(NSString *) color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+(void)writeFile:(NSString *)file
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //获取路径
    //1、参数NSDocumentDirectory要获取的那种路径
    NSArray*  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //2、得到相应的Documents的路径
    NSString* DocumentDirectory = [paths objectAtIndex:0];
    //3、更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[DocumentDirectory stringByExpandingTildeInPath]];
    //4、创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    [fileManager removeItemAtPath:@"uvinfo" error:nil];
    NSString *path = [DocumentDirectory stringByAppendingPathComponent:@"uvinfo"];
    //5、创建数据缓冲区
    NSMutableData  *writer = [[NSMutableData alloc] init];
    //6、将字符串添加到缓冲中
    [writer appendData:[file dataUsingEncoding:NSUTF8StringEncoding]];
    //7、将其他数据添加到缓冲中
    //将缓冲的数据写入到文件中
    [writer writeToFile:path atomically:YES];
}


@end
