//
//  OpenFunction.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-9-23.
//  Copyright (c) 2013年 爱摩信息科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AlarmKey;
@interface OpenFunction : NSObject

+ (float) getSystemVersion;
+ (void) openUserReviews;
+ (NSString*)getpm25description:(int)value;
+ (NSString*)getopenudid;
+ (NSString*)getMonthBeginAndEndWith:(NSDate *)newDate;
+ (NSString*)getWeekBeginAndEndWith:(NSDate *)newDate;
+ (long)getTimeStampFromDate:(NSDate*)date;
+ (NSDate*)getDateFromTimeStamp:(long)timestamp;

+(void)addLocalNotificationWithMessage:(NSString *)message
                              FireDate:(NSDate *) fireDate
                              AlarmKey:(NSString *)alarmKey;

+(void)deleteLocalNotification:(NSString*) alarmKey;

+(void)addLocalNotification:(NSString *)message
                             RepeatDay:(NSString *)repeatday
                              FireDate:(NSString *) fireDate
                   AlarmKey:(NSString *) alarmKey;
@end
