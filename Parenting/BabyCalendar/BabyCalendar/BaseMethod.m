//
//  BaseMethod.m
//  BabyCalendar
//
//  Created by will on 14-5-27.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseMethod.h"

@implementation BaseMethod


+ (UIViewController*)baseViewController:(UIView*)view
{
    id next = [view nextResponder];
    while (next) {
        next = [next nextResponder];
        if ([next isKindOfClass:[UIViewController class]]) {
            UIViewController* vc = (UIViewController*)next;
            return vc;
        }
    }
    
    return nil;
}

// 转化为北京时区时间
+ (NSDate*)beijingDate:(NSDate*)baseDate
{
    NSTimeZone* localzone = [NSTimeZone localTimeZone];
    NSDate *date = [NSDate dateWithTimeInterval:[localzone secondsFromGMT] sinceDate:baseDate];
    
    return date;
}
// 保存当前选中的日期
+ (void)saveSelectedDate:(NSDate*)selectedDate
{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormat];
    NSString* dateString = [formatter stringFromDate:selectedDate];
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:dateString forKey:kSelectedDate];
    [userDef synchronize];
}
// 获取当前选中的日期
+ (NSString*)selectedDateFromSave
{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    return [userDef objectForKey:kSelectedDate];
}
// 获取星期几
+ (NSString*)weekdayFromDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlags = NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger weekday = [comps weekday];
    
    NSString* weekdayStr = @"";
    if (weekday == 1) {
        weekdayStr = @"星期日";
    }
    if (weekday == 2) {
        weekdayStr = @"星期一";
    }
    if (weekday == 3) {
        weekdayStr = @"星期二";
    }
    if (weekday == 4) {
        weekdayStr = @"星期三";
    }
    if (weekday == 5) {
        weekdayStr = @"星期四";
    }
    if (weekday == 6) {
        weekdayStr = @"星期五";
    }
    if (weekday == 7) {
        weekdayStr = @"星期六";
    }
    return weekdayStr;
}

// yyyy年MM月dd日转NSDate
+ (NSDate*)dateFormString:(NSString*)dateString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormat];
    return [formatter dateFromString:dateString];
}
// NSDate转yyyy年MM月dd日
+ (NSString*)stringFromDate:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kDateFormat];
    return [formatter stringFromDate:date];
}

// 当前时间距离day天后的日期
+ (NSDate*)fromCurDate:(NSDate*)curDate withDay:(int)day
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:day];
    NSDate *date = [gregorian dateByAddingComponents:offsetComponents toDate:curDate options:0];
    return date;
    
}

// 两个日期间隔天数
+ (int)fromStartDate:(NSDate*)startDate withEndDate:(NSDate*)endDate
{
    if (endDate == nil || startDate == nil) {
        return 0;
    }
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitDay fromDate:startDate  toDate:endDate  options:0];
    int days = [comps day];
    
    return days;
}

//农历转换函数
+(NSString *)LunarForSolar:(NSDate *)solarDate{
    //天干名称
//    NSArray *cTianGan = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸", nil];
//    
//    //地支名称
//    NSArray *cDiZhi = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
//    
//    //属相名称
//    NSArray *cShuXiang = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
    
    //农历日期名
    NSArray *cDayName = [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                         @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                         @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName = [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static int wCurYear,wCurMonth,wCurDay;
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //取当前公历年、月、日
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:solarDate];
    wCurYear = [components year];
    wCurMonth = [components month];
    wCurDay = [components day];
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    
    //生成农历天干、地支、属相
//    NSString *szShuXiang = (NSString *)[cShuXiang objectAtIndex:((wCurYear - 4) % 60) % 12];
//    NSString *szNongli = [NSString stringWithFormat:@"%@(%@%@)年",szShuXiang, (NSString *)[cTianGan objectAtIndex:((wCurYear - 4) % 60) % 10],(NSString *)[cDiZhi objectAtIndex:((wCurYear - 4) % 60) % 12]];
    
    //生成农历月、日
    NSString *szNongliDay;
    if (wCurMonth < 1){
        szNongliDay = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }
    else{
        szNongliDay = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
//    NSString *lunarDate = [NSString stringWithFormat:@"%@ %@月 %@",szNongli,szNongliDay,(NSString *)[cDayName objectAtIndex:wCurDay]];
    NSString *lunarDate = [NSString stringWithFormat:@"农历 %@月%@",szNongliDay,(NSString *)[cDayName objectAtIndex:wCurDay]];
    
    return lunarDate;
}

// 数据库路径
+ (NSString*) getSQLPath {
//    NSArray* paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) ;
//    return [[paths objectAtIndex:0]stringByAppendingPathComponent:@"MyTable.db"] ;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];

    return CALENDARDBPATH(user_id,baby_id);
}

// 删除旧照片
+ (void)deleteOldPhoto:(NSString*)photoName
{
    if (photoName != nil && photoName.length > 0) {
        NSError *error = nil;
        NSString *old_photo=[BaseMethod dataFilePath:photoName];
        if([[NSFileManager defaultManager] removeItemAtPath:old_photo error:&error])
        {
            NSLog(@"旧照片移除成功");
        } else
        {
            NSLog(@"error=%@", error);
        }
    }
}

// 保存新照片
+ (void)saveNewPhoto:(UIImage*)image withPhotoName:(NSString*)photoName
{
    NSData* topImageData = UIImageJPEGRepresentation(image, 0.5);
    
    NSString *photo_path=[BaseMethod dataFilePath:photoName];
    BOOL sussess = [topImageData writeToFile:photo_path atomically:YES];
    if (sussess) {
        NSLog(@"保存照片成功");
    }else
    {
        NSLog(@"保存照片失败");
    }
}

//返回文件路径
+ (NSString *)dataFilePath:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

// 几个月份的测评
+ (NSInteger)month_test
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"TestData" ofType:@"plist"];
    NSArray* arr = [NSArray arrayWithContentsOfFile:path];
    return arr.count;
}


+ (NSDictionary *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    //    if ([cString length] < 6) {
    //        return [UIColor clearColor];
    //    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    //    if ([cString length] != 6)
    //        return [UIColor clearColor];
    
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
    
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:r],@"red",[NSNumber numberWithInt:g],@"green",[NSNumber numberWithInt:b],@"blue", nil];
}

+(CGColorRef) getColorFromRed:(float)red Green:(float)green Blue:(float)blue Alpha:(float)alpha
{
    //    CGFloat r = (CGFloat) red/255.0;
    //    CGFloat g = (CGFloat) green/255.0;
    //    CGFloat b = (CGFloat) blue/255.0;
    //    CGFloat a = (CGFloat) alpha/255.0;
    //    NSLog(@"%f %f %f",r,g,a);
    CGFloat components[4] = {red,green,blue,alpha};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef color = (CGColorRef)CGColorCreate(colorSpace, components);
    CGColorSpaceRelease(colorSpace);
	
    return color;
    
}
@end
