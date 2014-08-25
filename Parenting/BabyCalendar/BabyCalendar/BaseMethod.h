//
//  BaseMethod.h
//  BabyCalendar
//
//  Created by will on 14-5-27.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseMethod : NSObject

+ (UIViewController*)baseViewController:(UIView*)view;


/********NSDate***********/

// 转化为北京时区时间
+ (NSDate*)beijingDate:(NSDate*)baseDate;
// 保存当前选中的日期
+ (void)saveSelectedDate:(NSDate*)selectedDate;
// 获取当前选中的日期
+ (NSString*)selectedDateFromSave;

// 获取星期几
+ (NSString*)weekdayFromDate:(NSDate*)date;
// yyyy年MM月dd日转NSDate
+ (NSDate*)dateFormString:(NSString*)dateString;
// NSDate转yyyy年MM月dd日
+ (NSString*)stringFromDate:(NSDate*)date;
// 当前时间距离day天后的日期
+ (NSDate*)fromCurDate:(NSDate*)curDate withDay:(int)day;
// 两个日期间隔天数
+ (int)fromStartDate:(NSDate*)startDate withEndDate:(NSDate*)endDate;
//农历转换函数
+(NSString *)LunarForSolar:(NSDate *)solarDate;

// 数据库路径
+ (NSString*)getSQLPath;
//返回文件路径
+ (NSString *)dataFilePath:(NSString *)fileName;

// 删除旧照片
+ (void)deleteOldPhoto:(NSString*)photoName;
// 保存新照片
+ (void)saveNewPhoto:(UIImage*)image withPhotoName:(NSString*)photoName;

// 几个月份的测评
+ (NSInteger)month_test;

/***********color**************/
+ (NSDictionary *) colorWithHexString: (NSString *)color;
+(CGColorRef) getColorFromRed:(float)red Green:(float)green Blue:(float)blue Alpha:(float)alpha;

+ (NSString*)getBabyNickname;
@end
