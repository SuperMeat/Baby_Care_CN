//
//  ACDate.m
//  ACBase
//
//  Created by @Arvi@ on 14-3-19.
//  Copyright (c) 2014年 com.amoycare. All rights reserved.
//

#import "ACDate.h"

@implementation ACDate
+(NSDate*)date
{
    NSDate *date = [NSDate date];
    return date;
}

+(NSString*)durationFormat
{
    NSDate *date=[[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"];
    if (date == nil) {
        return @"00:00:00";
    }
    //NSLog(@"durationFormat %@", date);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
    comps=  [calendar components:unitFlags fromDate:date toDate:[self date] options:0];
    return [NSString stringWithFormat:@"%02d:%02d:%02d",[comps hour],[comps minute],[comps second]];
}
+(int)getDurationfromdate:(NSString*)fomaterdate
{
    //NSLog(@"%@",fomaterdate);
    NSDateFormatter *fomatter=[[NSDateFormatter alloc]init];
    [fomatter setLocale:[NSLocale currentLocale]];
    [fomatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[fomatter dateFromString:fomaterdate];
    //NSLog(@"%@",date);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMonthCalendarUnit|NSDayCalendarUnit;
    comps=  [calendar components:unitFlags fromDate:date toDate:[ACDate date] options:0];
    return [comps month];
    
}

+(NSString*)getdateFormat
{
    NSDate *time=[self getStarttime];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit;
    //NSLog(@"getdateformat : %@", time);
    comps=[calendar components:unitFlags fromDate:time];
    
    NSString *week;
    switch ([comps weekday]) {
        case 1:
            week=NSLocalizedString(@"Sunday", nil);
            break;
        case 2:
            week=NSLocalizedString(@"Monday", nil);
            break;
        case 3:
            week=NSLocalizedString(@"Tuesday", nil);
            break;
        case 4:
            week=NSLocalizedString(@"Wednesday", nil);
            break;
        case 5:
            week=NSLocalizedString(@"Thursday", nil);
            break;
        case 6:
            week=NSLocalizedString(@"Friday", nil);
            break;
        case 7:
            week=NSLocalizedString(@"Saturday", nil);
            break;
            
        default:
            break;
    }
    //NSLog(@"%@",week);
    return [NSString stringWithFormat:@"%@ %02d/%02d",week,[comps day],[comps month]];;
}

+(NSString *)getStarttimefromdate:(NSDate*)date
{
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    
    [formater setDateFormat:@"HH:mm"];
    
    return [formater stringFromDate:date];
}

+(NSString *)getDurationfromdate:(NSDate*)date second:(int)second
{
    
    NSDate *datefuture=[date dateByAddingTimeInterval:second];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
    comps=  [calendar components:unitFlags fromDate:date toDate:datefuture options:0];
    return [NSString stringWithFormat:@"%02d:%02d:%02d",[comps hour],[comps minute],[comps second]];
    
}

+(NSString *)dateFomatdate:(NSDate*)date
{
    //NSLog(@"date  %@",date);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit;
    
    comps=[calendar components:unitFlags fromDate:date];
    NSString *week;
    switch ([comps weekday]) {
        case 1:
            week=NSLocalizedString(@"Sunday", nil);
            break;
        case 2:
            week=NSLocalizedString(@"Monday", nil);
            break;
        case 3:
            week=NSLocalizedString(@"Tuesday", nil);
            break;
        case 4:
            week=NSLocalizedString(@"Wednesday", nil);
            break;
        case 5:
            week=NSLocalizedString(@"Thursday", nil);
            break;
        case 6:
            week=NSLocalizedString(@"Friday", nil);
            break;
        case 7:
            week=NSLocalizedString(@"Saturday", nil);
            break;
            
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@ %02d/%02d",week,[comps day],[comps month]];;
}

+(NSString*)getDayBeforeDespFromDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
    comps=  [calendar components:unitFlags fromDate:date toDate:[currentdate date] options:nil];
    if ([comps day] >0) {
        return [NSString stringWithFormat:NSLocalizedString(@"DayTips", nil),[comps day]];
    }
    else if ([comps hour]>0) {
        return [NSString stringWithFormat:NSLocalizedString(@"HourTips", nil),[comps hour]];
    }
    else if ([comps minute]>0) {
        return [NSString stringWithFormat:NSLocalizedString(@"MinuteTips", nil),[comps minute]];
    }
    else if ([comps second]>0) {
        return [NSString stringWithFormat:NSLocalizedString(@"SecondTips", nil),[comps second]];
    }
    else
    {
        return @"NULL";
    }

}

+(NSDate*)getStarttime
{
    NSDate *date=[[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"];
    return date;
}

+(int)getMonth
{
    NSDate *time=[self getStarttime];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMonthCalendarUnit;
    comps=[calendar components:unitFlags fromDate:time];
    return [comps month];
}

+ (int)getday:(NSDate*) date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    return [comps day];
}

+(int)getWeek
{
    NSDate *time=[self getStarttime];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSWeekCalendarUnit;
    comps=[calendar components:unitFlags fromDate:time];
    return [comps week];
}
+(int)getWeekDay
{
    NSDate *time=[self getStarttime];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps=[calendar components:unitFlags fromDate:time];
    return [comps weekday];
}

+(int)getMonthFromDate:(NSDate*) date{
    NSDate *time=date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMonthCalendarUnit;
    comps=[calendar components:unitFlags fromDate:time];
    return [comps month];
}

+(int)getWeekFromDate:(NSDate*) date
{
    NSDate *time=date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSWeekCalendarUnit;
    comps=[calendar components:unitFlags fromDate:time];
    return [comps week];
}

+(int)getWeekDayFromDate:(NSDate*) date
{
    NSDate *time=date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps=[calendar components:unitFlags fromDate:time];
    return [comps weekday];
}

+(NSString*)getStarttimeFormat
{
    NSDate *time=[self getStarttime];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"HH:MM"];
    
    
    return [formatter stringFromDate:time];
    
}


+(int)getCurrentMonth
{
    NSDate *time=[self date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMonthCalendarUnit;
    comps=[calendar components:unitFlags fromDate:time];
    return [comps month];
}
+(int)getCurrentWeek
{
    NSDate *time=[self date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSWeekCalendarUnit;
    comps=[calendar components:unitFlags fromDate:time];
    return [comps week];
}

+(int)getEarlyWeek:(NSDate*) time
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSWeekCalendarUnit;
    comps=[calendar components:unitFlags fromDate:time];
    return [comps week];
}

+(int)getCurrentWeekDay
{
    NSDate *time=[self date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps=[calendar components:unitFlags fromDate:time];
    return [comps weekday];
}

+(int)getCurrentYear{
    NSDate *time=[self date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit;
    comps=[calendar components:unitFlags fromDate:time];
    return [comps year];
}

+(NSString *)dateForSummaryList:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit| NSMinuteCalendarUnit;
    comps=[calendar components:unitFlags fromDate:date];
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"MMM.d"];
    NSString *day=[formater stringFromDate:date];
    if ([day hasSuffix:@"1"]) {
        day=[NSString stringWithFormat:@"%@st  ",day];
    }
    else if ([day hasSuffix:@"2"])
    {
        day=[NSString stringWithFormat:@"%@nd  ",day];
    }
    else if([day hasSuffix:@"3"])
    {
        day=[NSString stringWithFormat:@"%@rd  ",day];
    }
    else
    {
        day=[NSString stringWithFormat:@"%@th  ",day];
    }
    [formater setDateFormat:@" HH:mm"];
    day=[NSString stringWithFormat:@"%@%@",day,[formater stringFromDate:date]];
    
    
    
    return day;
}

+(NSDate *) dateFromString:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

+(NSDate*)getNewDateFromOldDate:(NSDate*)newdate andOldDate:(NSDate*)olddate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *oldcomp1 = [calendar components:units fromDate:olddate];
    NSInteger oldhour = [oldcomp1 hour];
    NSInteger oldmin  = [oldcomp1 minute];
    NSInteger oldsec  = [oldcomp1 second];
    
    
    NSDateComponents *newcomp = [calendar components:units fromDate:newdate];
    NSInteger year   = [newcomp year];
    NSInteger month  = [newcomp month];
    NSInteger day    = [newcomp day];
    
    NSString* str = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",year,month,day,oldhour,oldmin,oldsec];
    return [self dateFromString:str];
}

+(NSDate*)getNewDateFromOldTime:(NSDate*)newdate andOldDate:(NSDate*)olddate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *oldcomp1 = [calendar components:units fromDate:olddate];
    NSInteger oldYear = [oldcomp1 year];
    NSInteger oldMonth  = [oldcomp1 month];
    NSInteger oldDay  = [oldcomp1 day];
    
    
    NSDateComponents *newcomp = [calendar components:units fromDate:newdate];
    NSInteger hour   = [newcomp hour];
    NSInteger min  = [newcomp minute];
    NSInteger sec    = [newcomp second];
    
    NSString* str = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",oldYear,oldMonth,oldDay,hour,min,sec];
    return [self dateFromString:str];
}

+ (NSString*)getWeekBeginAndEndWith:(NSDate *)newDate
{
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

+ (NSString*)getMonthBeginAndEndWith:(NSDate *)newDate
{
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

@end
