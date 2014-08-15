//
//  ACDate.h
//  ACBase
//
//  Created by @Arvi@ on 14-3-19.
//  Copyright (c) 2014年 com.amoycare. All rights reserved.
//

#import "ACConfig.h"

@interface ACDate : NSObject
+(NSDate   *)date;
+(NSString *)durationFormat;
+(NSString *)getdateFormat;
+(NSDate   *)getStarttime;
+(NSString *)getStarttimeFormat;
+(NSString *)getStarttimefromdate:(NSDate*)date;
+(NSString *)getDurationfromdate:(NSDate*)date second:(int)second;
+(NSString *)dateFomatdate:(NSDate*)date;
+(NSString *)getDayBeforeDespFromDate:(NSDate*)date;
+(NSString *)dateDetailFomatdate:(NSDate*)date;
+(NSString *)dateDetailFomatdate2:(NSDate*)date;

+(int)getMonth;
+(int)getWeek;
+(int)getWeekDay;

+(NSDate*)getNewDateFromOldDate:(NSDate*) newdate andOldDate:(NSDate*)olddate;
+(NSDate*)getNewDateFromOldTime:(NSDate*)newdate andOldDate:(NSDate*)olddate;
+(NSString*)getDaySinceDate:(NSDate *)date;

+(int)getMonthFromDate:(NSDate*)   date;
+(int)getWeekFromDate:(NSDate*)    date;
+(int)getWeekDayFromDate:(NSDate*) date;

+(int)getCurrentMonth;
+(int)getCurrentWeek;
+(int)getCurrentWeekDay;
+(int)getCurrentHour;
+(int)getday:(NSDate*) date;
+(int)getEarlyWeek:(NSDate*) time;
+(int)getCurrentYear;
+(int)getDurationfromdate:(NSString*)fomaterdate;
+(NSString *)dateForSummaryList:(NSDate*)date;
+(NSDate *)dateFromString:(NSString *)dateString;

+ (NSString*)getMonthBeginAndEndWith:(NSDate *)newDate;
+ (NSString*)getWeekBeginAndEndWith:(NSDate *)newDate;
+ (long)getTimeStampFromDate:(NSDate*)date;
+ (NSDate*)getDateFromTimeStamp:(long)timestamp;

@end
