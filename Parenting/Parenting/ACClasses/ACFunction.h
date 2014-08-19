//
//  ACFunction.h
//  ACBase
//
//  Created by @Arvi@ on 14-3-19.
//  Copyright (c) 2014年 com.amoycare. All rights reserved.
//

#import "ACConfig.h"

@interface ACFunction : NSObject
+ (float) getSystemVersion;
+ (void)  openUserReviews;
/**
 *  本地通知处理
 *
 *  @param message  自定义提醒
 *  @param fireDate fireDate description
 *  @param alarmKey 
 */
+(void)addLocalNotificationWithMessage:(NSString *)message
                              FireDate:(NSDate *) fireDate
                              AlarmKey:(NSString *)alarmKey;

+(void)deleteLocalNotification:(NSString*) alarmKey;

+(void)addLocalNotification:(NSString *)message
                  RepeatDay:(NSString *)repeatday
                   FireDate:(NSString *) fireDate
                   AlarmKey:(NSString *) alarmKey;

+ (UIColor *) colorWithHexString:(NSString *) color;

+(void)writeFile:(NSString *)file;

+(UIImage*)cutView:(UIView*)view andWidth:(CGFloat)width andHeight:(CGFloat)height;
+(UIImage*)cutScrollView:(UIScrollView*)scrollView;

@end
