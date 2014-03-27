//
//  SummaryDB.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-26.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "SummaryDB.h"

@implementation SummaryDB
+(id)dataBase
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

-(NSArray*)selectAll
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_feed (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, oz DOUBLE DEFAULT 0,remark Varchar DEFAULT NULL, feed_type Varchar DEFAULT NULL,food_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_diaper (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, color Varchar DEFAULT NULL,hard Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_sleep (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, posture Varchar DEFAULT NULL,place Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_bath (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, bath_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_play (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, place Varchar DEFAULT NULL,play_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    
    FMResultSet *set=[db executeQuery:@"select * from(select starttime,type from bc_baby_feed union all select starttime,type from bc_baby_diaper union all select starttime,type from bc_baby_sleep union all select starttime,type from bc_baby_bath union all select starttime,type from bc_baby_play)order by starttime desc"];
    while ([set next]) {
        ActivityItem *item=[[ActivityItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        [array addObject:item];
    }
    if (!res) {
        NSLog(@"插入失败");
        [db close];
        return nil;
    }
    [db close];
    return  array;
}

-(NSArray*)selectAllforsummary
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_feed (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, oz DOUBLE DEFAULT 0,remark Varchar DEFAULT NULL, feed_type Varchar DEFAULT NULL,food_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_diaper (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, color Varchar DEFAULT NULL,hard Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_sleep (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, posture Varchar DEFAULT NULL,place Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_bath (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, bath_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_play (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, place Varchar DEFAULT NULL,play_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select * from(select starttime,type from bc_baby_feed union all select starttime,type from bc_baby_diaper union all select starttime,type from bc_baby_sleep union all select starttime,type from bc_baby_bath union all select starttime,type from bc_baby_play)order by starttime desc"];
    while ([set next]) {
        SummaryItem *item=[[SummaryItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        item.duration=[self selectDurationfromStarttime:item.starttime Type:item.type];
        
        
        [array addObject:item];
    }
    
    [db close];
    return  array;
}
-(NSArray*)selectfeedforsummary
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_feed (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, oz DOUBLE DEFAULT 0,remark Varchar DEFAULT NULL, feed_type Varchar DEFAULT NULL,food_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_diaper (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, color Varchar DEFAULT NULL,hard Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_sleep (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, posture Varchar DEFAULT NULL,place Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_bath (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, bath_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_play (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, place Varchar DEFAULT NULL,play_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select * from bc_baby_feed order by starttime desc"];
    while ([set next]) {
        SummaryItem *item=[[SummaryItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        item.duration=[self selectDurationfromStarttime:item.starttime Type:item.type];
        [array addObject:item];
    }
    
    [db close];
    return  array;
}
-(NSArray*)selectdiaperforsummary
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_feed (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, oz DOUBLE DEFAULT 0,remark Varchar DEFAULT NULL, feed_type Varchar DEFAULT NULL,food_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_diaper (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, color Varchar DEFAULT NULL,hard Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_sleep (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, posture Varchar DEFAULT NULL,place Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_bath (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, bath_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_play (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, place Varchar DEFAULT NULL,play_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select * from bc_baby_diaper order by starttime desc"];
    while ([set next]) {
        SummaryItem *item=[[SummaryItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        item.duration=[self selectDurationfromStarttime:item.starttime Type:item.type];
        
        
        [array addObject:item];
    }
    
    [db close];
    return  array;
}

-(NSArray*)selectbathforsummary
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_feed (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, oz DOUBLE DEFAULT 0,remark Varchar DEFAULT NULL, feed_type Varchar DEFAULT NULL,food_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_diaper (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, color Varchar DEFAULT NULL,hard Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_sleep (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, posture Varchar DEFAULT NULL,place Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_bath (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, bath_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_play (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, place Varchar DEFAULT NULL,play_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select * from bc_baby_bath order by starttime desc"];
    while ([set next]) {
        SummaryItem *item=[[SummaryItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        item.duration=[self selectDurationfromStarttime:item.starttime Type:item.type];
        
        
        [array addObject:item];
    }
    
    [db close];
    return  array;
}

-(NSArray*)selectsleepforsummary
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_feed (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, oz DOUBLE DEFAULT 0,remark Varchar DEFAULT NULL, feed_type Varchar DEFAULT NULL,food_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_diaper (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, color Varchar DEFAULT NULL,hard Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_sleep (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, posture Varchar DEFAULT NULL,place Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_bath (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, bath_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_play (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, place Varchar DEFAULT NULL,play_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select * from  bc_baby_sleep order by starttime desc"];
    while ([set next]) {
        SummaryItem *item=[[SummaryItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        item.duration=[self selectDurationfromStarttime:item.starttime Type:item.type];
        
        
        [array addObject:item];
    }
    
    [db close];
    return  array;
}


-(NSArray*)selectplayforsummary
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_feed (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, oz DOUBLE DEFAULT 0,remark Varchar DEFAULT NULL, feed_type Varchar DEFAULT NULL,food_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_diaper (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, color Varchar DEFAULT NULL,hard Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_sleep (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, posture Varchar DEFAULT NULL,place Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_bath (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, bath_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_play (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, place Varchar DEFAULT NULL,play_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select * from  bc_baby_play order by starttime desc"];
    while ([set next]) {
        SummaryItem *item=[[SummaryItem alloc]init];
        item.starttime=[set dateForColumn:@"starttime"];
        item.type=[set stringForColumn:@"type"];
        item.duration=[self selectDurationfromStarttime:item.starttime Type:item.type];
        
        
        [array addObject:item];
    }
    
    [db close];
    return  array;
}

-(NSString *)selectDurationfromStarttime:(NSDate*)start Type:(NSString *)type
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    NSString *str=@"";
    
    NSLog(@"type%@",type);
    
    if (![type isEqualToString:@"Diaper"]) {
        FMResultSet *resultset=[db executeQuery:@"select * from(select starttime,duration,type from bc_baby_feed union all select starttime,duration,type from bc_baby_sleep union all select starttime,duration,type from bc_baby_bath union all select starttime,duration,type from bc_baby_play)where starttime=? and type=? order by starttime desc",start,type ];
        
        if ([resultset next]) {NSLog(@"duration%@",str);
            str= [currentdate getDurationfromdate:start second:[resultset intForColumn:@"duration"]];
        }
        
    }
    else {
        
        FMResultSet *set=[db executeQuery:@"select * from bc_baby_diaper where starttime=? and type=?",start,type];
        
        [set next];
        str= NSLocalizedString([set stringForColumn:@"status"], nil) ;
        
    }
    
    [db close];
    return str;
}

-(NSString*)selectFromfeed
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_feed (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, oz DOUBLE DEFAULT 0,remark Varchar DEFAULT NULL, feed_type Varchar DEFAULT NULL,food_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select starttime from bc_baby_feed order by starttime desc"];
    while ([set next]) {
        NSDate *date=[set dateForColumn:@"starttime"];
        NSLog(@"feeddate %@",date);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
        comps=  [calendar components:unitFlags fromDate:date toDate:[currentdate date] options:nil];
        if ([comps day] >0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"DayTips", nil),[comps day]];
        }
        else if ([comps hour]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"HourTips", nil),[comps hour]];
        }
        else if ([comps minute]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"MinuteTips", nil),[comps minute]];
        }
        else if ([comps second]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"SecondTips", nil),[comps second]];
        }
        else
        {
            [db close];
            return @"NULL";
        }
    }
    [db close];
    return @"NULL";
}
-(NSString*)selectFrombath
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_bath (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT NULL, remark Varchar DEFAULT NULL, bath_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select starttime from bc_baby_bath order by starttime desc"];
    while ([set next]) {
        NSDate *date=[set dateForColumn:@"starttime"];
        NSLog(@"bathdate %@",date);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
        comps=  [calendar components:unitFlags fromDate:date toDate:[currentdate date] options:nil];
        if ([comps day] >0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"DayTips", nil),[comps day]];
        }
        else if ([comps hour]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"HourTips", nil),[comps hour]];
        }
        else if ([comps minute]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"MinuteTips", nil),[comps minute]];
        }
        else if ([comps second]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"SecondTips", nil),[comps second]];
        }
        else
        {
            [db close];
            return @"NULL";
        }
    }
    [db close];
    return @"NULL";
}
-(NSString*)selectFromsleep
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_sleep (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, posture Varchar DEFAULT NULL,place Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select starttime from bc_baby_sleep order by starttime desc"];
    while ([set next]) {
        NSDate *date=[set dateForColumn:@"starttime"];
        NSLog(@"sleepdate %@",date);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
        comps=  [calendar components:unitFlags fromDate:date toDate:[currentdate date] options:nil];
        if ([comps day] >0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"DayTips", nil),[comps day]];
        }
        else if ([comps hour]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"HourTips", nil),[comps hour]];
        }
        else if ([comps minute]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"MinuteTips", nil),[comps minute]];
        }
        else if ([comps second]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"SecondTips", nil),[comps second]];
        }
        else
        {
            [db close];
            return @"NULL";
        }
    }
    [db close];
    return @"NULL";
}
-(NSString*)selectFromplay
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_play (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, duration INTEGER DEFAULT 0, remark Varchar DEFAULT NULL, place Varchar DEFAULT NULL,play_type Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select starttime from bc_baby_play order by starttime desc"];
    while ([set next]) {
        NSDate *date=[set dateForColumn:@"starttime"];
        
        NSLog(@"playdate %@",date);
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
        comps=  [calendar components:unitFlags fromDate:date toDate:[currentdate date] options:nil];
        if ([comps day] >0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"DayTips", nil),[comps day]];
        }
        else if ([comps hour]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"HourTips", nil),[comps hour]];
        }
        else if ([comps minute]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"MinuteTips", nil),[comps minute]];
        }
        else if ([comps second]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"SecondTips", nil),[comps second]];
        }
        else
        {
            [db close];
            return @"NULL";
        }
    }
    [db close];
    return @"NULL";
    
}
-(NSString*)selectFromdiaper
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_diaper (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, starttime Timestamp DEFAULT NULL, month INTEGER DEFAULT NULL, week INTEGER DEFAULT NULL, weekday INTEGER DEFAULT NULL, status Varchar DEFAULT NULL, remark Varchar DEFAULT NULL, color Varchar DEFAULT NULL,hard Varchar DEFAULT NULL,moreinfo Varchar DEFAULT NULL,type Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return nil;
        
    }
    FMResultSet *set=[db executeQuery:@"select starttime from bc_baby_diaper order by starttime desc"];
    while ([set next]) {
        NSDate *date=[set dateForColumn:@"starttime"];
        NSLog(@"diaperdate %@",date);
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =NSDayCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit;
        comps=  [calendar components:unitFlags fromDate:date toDate:[currentdate date] options:nil];
        if ([comps day] >0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"DayTips", nil),[comps day]];
        }
        else if ([comps hour]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"HourTips", nil),[comps hour]];
        }
        else if ([comps minute]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"MinuteTips", nil),[comps minute]];
        }
        else if ([comps second]>0) {
            [db close];
            return [NSString stringWithFormat:NSLocalizedString(@"SecondTips", nil),[comps second]];
        }
        else
        {
            [db close];
            return @"NULL";
        }
    }
    [db close];
    return @"NULL";
    
}

-(NSArray*)searchFromfeed:(NSDate*)start
{
    
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    FMResultSet *set=[db executeQuery:@"select * from bc_baby_feed where starttime=?",start];
    
    [set next];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[set dateForColumn:@"starttime"]];
    [array addObject:[set  objectForColumnName:@"duration"]];
    [array addObject:[set objectForColumnName:@"feedway"]];
    if ([set stringForColumn:@"ozorlr"]) {
        [array addObject:[set stringForColumn:@"ozorlr"]];
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@""]];
    }
    if ([set stringForColumn:@"remark"]) {
        [array addObject:[set stringForColumn:@"remark"]];
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@""]];
    }
    
    [db close];
    return  array;
}

-(NSArray*)searchFromdiaper:(NSDate*)start
{
    
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    FMResultSet *set=[db executeQuery:@"select * from bc_baby_diaper where starttime=?",start];
    [set next];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[set dateForColumn:@"starttime"]];
    if ([set stringForColumn:@"remark"]) {
        [array addObject:[set stringForColumn:@"remark"]];
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@""]];
    }
    [array addObject:[set stringForColumn:@"status"]];
    [array addObject:[set stringForColumn:@"color"]];
    [array addObject:[set stringForColumn:@"hard"]];
    [array addObject:[NSNumber numberWithLong:[set longForColumn:@"update_time"]]];
    [array addObject:[NSNumber numberWithLong:[set longForColumn:@"create_time"]]];
    
    [db close];
    return  array;
}

-(NSDictionary*)createDiaperUploadData:(FMResultSet *)set
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:12];
    
    if (set != Nil) {
        
        [dic setValue:[NSNumber numberWithLong:[set longForColumn:@"create_time"]] forKey:@"create_time"];
        [dic setValue:[NSNumber numberWithInt:[ACDate getTimeStampFromDate:[set dateForColumn:@"starttime"]]] forKey:@"starttime"];
        
        [dic setValue:[NSNumber numberWithInt:[set intForColumn:@"month"]] forKey:@"month"];
        [dic setValue:[NSNumber numberWithInt:[set intForColumn:@"week"]] forKey:@"week"];
        [dic setValue:[NSNumber numberWithInt:[set intForColumn:@"weekday"]] forKey:@"weekday"];
        
        [dic setValue:[set stringForColumn:@"status"] forKey:@"status"];
        [dic setValue:[set stringForColumn:@"remark"] forKey:@"remark"];
        [dic setValue:[set stringForColumn:@"color"] forKey:@"color"];
        [dic setValue:[set stringForColumn:@"hard"] forKey:@"hard"];
        [dic setValue:[set stringForColumn:@"moreinfo"] forKey:@"moreinfo"];
        [dic setValue:[set stringForColumn:@"type"] forKey:@"type"];
        
        [dic setValue:[NSNumber numberWithLong:[set dateForColumn:@"update_time"]] forKey:@"update_time"];
    }
    
    return dic;
}

-(NSArray*)searchFromdiaperNoUpload
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    FMResultSet *set=[db executeQuery:@"select * from bc_baby_diaper"];
    while ([set next])
    {
        NSDictionary *dic = [self createDiaperUploadData:set];
        if ([dic count] > 0)
        {
            [array addObject:dic];
        }
    }
    
    [db close];
    return  array;
}

-(NSArray*)searchFrombath:(NSDate*)start
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    
    FMResultSet *set=[db executeQuery:@"select * from bc_baby_bath where starttime=?",start];
    
    [set next];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[set dateForColumn:@"starttime"]];
    [array addObject:[set  objectForColumnName:@"duration"]];
    
    if ([set stringForColumn:@"remark"]) {
        [array addObject:[set stringForColumn:@"remark"]];
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@""]];
    }
    [db close];
    return  array;
    
}
-(NSArray*)searchFromplay:(NSDate*)start
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    FMResultSet *set=[db executeQuery:@"select * from bc_baby_play where starttime=?",start];
    [set next];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[set dateForColumn:@"starttime"]];
    [array addObject:[set  objectForColumnName:@"duration"]];
    
    if ([set stringForColumn:@"remark"]) {
        [array addObject:[set stringForColumn:@"remark"]];
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@""]];
    }
    
    [array addObject:[set stringForColumn:@"place"]];
    
    [db close];
    return  array;
}

-(NSArray*)searchFromsleep:(NSDate*)start
{
    
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    FMResultSet *set=[db executeQuery:@"select * from bc_baby_sleep where starttime=?",start];
    [set next];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    [array addObject:[set dateForColumn:@"starttime"]];
    [array addObject:[set  objectForColumnName:@"duration"]];
    
    if ([set stringForColumn:@"remark"]) {
        [array addObject:[set stringForColumn:@"remark"]];
    }
    else
    {
        [array addObject:[NSString stringWithFormat:@""]];
    }
    
    [array addObject:[set stringForColumn:@"place"]];
    
    [db close];
    return  array;
}

-(BOOL)deleteWithStarttime:(NSDate*)starttime
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    
    res=[db executeUpdate:@"delete from feed where starttime=?",starttime];
    res=[db executeUpdate:@"delete from bath where starttime=?",starttime];
    res=[db executeUpdate:@"delete from diaper where starttime=?",starttime];
    res=[db executeUpdate:@"delete from sleep where starttime=?",starttime];
    res=[db executeUpdate:@"delete from play where starttime=?",starttime];
    [db close];
    return res;
}

+ (NSArray *)dataFromTable:(int)fileTag andpage:(int)scrollpage andTable:(NSString *)table
{
    //NSLog(@"dataFromTable:%d, page:%d, table:%@", fileTag, scrollpage, table);
    int week    = [ACDate getCurrentWeek];
    int weekday = [ACDate getCurrentWeekDay];
    int month   = [ACDate getCurrentMonth];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *count = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *duration = [[NSMutableArray alloc] initWithCapacity:0];
    BOOL res = YES;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    if (0 == fileTag) {
        //week
        int max = 0;
        if (week-scrollpage != [ACDate getCurrentWeek]) {
            max = 7;
        }else{
            max = weekday;
        }
        for (int i = 1; i <= max; i++) {
            int curweek = 0;
            if (week <= scrollpage) {
                curweek = 52- scrollpage + week;
            }
            else
            {
                curweek = week;
            }
            
            NSString *sql = [NSString stringWithFormat:@"select count(*) from bc_baby_%@ where week = %i and weekday = %i", table, curweek, i];
            NSString *sql1 = [NSString stringWithFormat:@"select sum(duration) from bc_baby_%@ where week = %i and weekday = %i", table, curweek, i];
            if ([table isEqualToString:@"Diaper"]) {
                sql1 = [NSString stringWithFormat:@"select count(*) from bc_baby_%@ where week = %i and weekday = %i", table, curweek, i];
            }
            FMResultSet *set  = [db executeQuery:sql];
            FMResultSet *set1 = [db executeQuery:sql1];
            if ([set next]) {
                [count addObject:[set objectForColumnIndex:0]];
            }
            if ([set1 next]) {
                NSString *ss;
                if (![[set1 objectForColumnIndex:0] isKindOfClass:[NSNull class]]) {
                    if ([table isEqualToString:@"Diaper"]) {
                        ss = [NSString stringWithFormat:@"%f", [[set1 objectForColumnIndex:0] floatValue]];
                    }else{
                        ss = [NSString stringWithFormat:@"%f", [[set1 objectForColumnIndex:0] floatValue]/3600];
                    }
                }else{
                    ss = @"0";
                }
                [duration addObject:ss];
            }
        }
    }
    else
    {
        //month
        int curmonth = 0;
        if (month <= scrollpage) {
            curmonth = 12- scrollpage + month;
        }
        else
        {
            curmonth = month;
        }
        
        int nowDay = [ACDate getday:[ACDate date]];
        if ((month-scrollpage) == [ACDate getCurrentMonth]) {
            for (int i = 0; i <= (nowDay - 1) / 7; i++) {
                NSString *str = @"0";
                [count addObject:str];
                [duration addObject:str];
            }
        }
        else
        {
            count = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil];
            duration = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil];
        }
        NSString *sql;
        if ([table isEqualToString:@"Diaper"]) {
           sql = [NSString stringWithFormat:@"select starttime from bc_baby_%@ where month = %i", table, curmonth];
        }else{
           sql = [NSString stringWithFormat:@"select starttime,duration from bc_baby_%@ where month = %i", table, curmonth];
        }
        FMResultSet *set = [db executeQuery:sql];
        
        while ([set next]) {
            NSTimeInterval interval = [set doubleForColumn:@"starttime"];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
            int day = [ACDate getday:date];
            NSLog(@"set next day: %d count: %@ duration:%@", day, count, duration);
            int oldeCount = [[count objectAtIndex:(day - 1) / 7] intValue];
            oldeCount++;
            [count removeObjectAtIndex:(day - 1) / 7];
            NSString *str = [NSString stringWithFormat:@"%d", oldeCount];
            [count insertObject:str atIndex:(day - 1) / 7];
            NSString *str1 = [NSString stringWithFormat:@"%i", [set intForColumn:@"duration"]];
            int oldeDurationCount = [[duration objectAtIndex:(day - 1) / 7] intValue];
            [duration removeObjectAtIndex:(day - 1) / 7];
            if ([table isEqualToString:@"Diaper"]) {
                [duration insertObject:[NSString stringWithFormat:@"%i", oldeCount] atIndex:(day - 1) / 7];
            }
            else
            {
                [duration insertObject:[NSString stringWithFormat:@"%f", (oldeDurationCount + [str1 floatValue])/3600] atIndex:(day - 1) / 7];
            }
        }
    }
    
    if (0 == fileTag) {
        long timestamp = [ACDate getTimeStampFromDate:[ACDate date]];
        NSDate   *newDate    = [ACDate getDateFromTimeStamp:(timestamp-scrollpage*604800)];
        NSString *rangeTitle = [ACDate getWeekBeginAndEndWith:newDate];
        [self setWeekName:table andrange:rangeTitle];
    }
    else
    {
        int curmonth = 0,curyear = 0;
        if (month <= scrollpage) {
            curmonth = 12- scrollpage + month;
            curyear  = [ACDate getCurrentYear]-scrollpage/12-1;
        }
        else
        {
            curmonth = month;
            curyear  = [ACDate getCurrentYear];
        }
        NSLog(@"scrollpage:%d, month:%d, curmonth:%d", scrollpage, month,curmonth);
        [self setTitleName:[NSString stringWithFormat:@"%@(%i.%d)",NSLocalizedString(table,nil), curyear, curmonth]];
    }
    [db close];
    [array addObject:count];
    [array addObject:duration];
    return [NSArray arrayWithArray:array];
}

+ (int)getMonthMax:(int)scrollpage
{
    int max   = 31;
    int month = [ACDate getCurrentMonth];
    BOOL res  = YES;
    NSString *sql;
    NSString *table = @"diaper";
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    if ([table isEqualToString:@"diaper"]) {
        sql = [NSString stringWithFormat:@"select starttime from bc_baby_%@ where month = %i", table, month - scrollpage];
    }
    
    FMResultSet *set = [db executeQuery:sql];
    while ([set next]) {
        NSTimeInterval interval = [set doubleForColumn:@"starttime"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
        max = range.length;
    }
    [db close];
    
    return max;
}

+ (NSArray *)dataSourceFromDatabase:(int)fileTag andpage:(int)scrollpage andTable:(NSString *)table
{
    int week = [ACDate getCurrentWeek];
    int weekday = [ACDate getCurrentWeekDay];
    int month = [ACDate getCurrentMonth];
    NSMutableArray *arrayCount = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *arr = [NSArray arrayWithObjects:@"play", @"bath", @"feed", @"sleep", @"diaper", nil];
    BOOL res = YES;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];

    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    for (NSString *table in arr) {
        NSString *cs = @"sum(duration)";
        if ([table isEqualToString:@"diaper"]) {
            cs = @"count(*)";
        }
        NSMutableArray *muarr = [[NSMutableArray alloc] initWithCapacity:0];
        // 显示周
        if (0 == fileTag) {
            int max = 0;
            if (week - scrollpage != [ACDate getCurrentWeek]) {
                max = 7;
            }else{
                max = weekday;
            }
            
            for (int i = 1; i <= max; i++) {
                NSString *sql = [NSString stringWithFormat:@"select %@ from bc_baby_%@ where week = %i and weekday = %i", cs, table, week - scrollpage, i];
                FMResultSet *set=[db executeQuery:sql];
                if ([set next]) {
                    NSString *str;
                    if ([[set objectForColumnIndex:0] isKindOfClass:[NSNull class]]) {
                        str=@"0";
                        
                    }else{
                        if ([table isEqualToString:@"diaper"]) {
                            str= [NSString stringWithFormat:@"%f", [[set objectForColumnIndex:0] floatValue]];
                        }else{
                            str= [NSString stringWithFormat:@"%f", [[set objectForColumnIndex:0] floatValue]/3600];
                        }
                        
                    }
                    [muarr addObject:str];
                }
            }
        }
        /**
         *	显示月
         */
        else
        {
            int nowDay = [ACDate getday:[ACDate date]];
            NSLog(@"datasourcefromdatebase：nowday:%d", nowDay);
            if (month-scrollpage == [ACDate getCurrentMonth]) {
                for (int i = 0; i <= (nowDay - 1) / 7; i++) {
                    NSString *str = @"0";
                    [muarr addObject:str];
                }
            }else{
                muarr = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", nil];
            }
            NSLog(@"datasourcefromdatabase:%@,scrollpage:%d", muarr,scrollpage);
            NSString *sql;
            if ([table isEqualToString:@"diaper"]) {
                sql = [NSString stringWithFormat:@"select starttime from bc_baby_%@ where month = %i", table, month - scrollpage];
            }else{
                sql = [NSString stringWithFormat:@"select starttime,duration from bc_baby_%@ where month = %i", table, month - scrollpage];
            }
            FMResultSet *set = [db executeQuery:sql];
            while ([set next]) {
                NSTimeInterval interval = [set doubleForColumn:@"starttime"];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
                int day = [ACDate getday:date];
                NSLog(@"datasourcefromdatabase: date:%@ day: %d",date,day);
                NSString *str = @"";
                int count = [[muarr objectAtIndex:(day - 1) / 7] intValue];
                NSLog(@"datasourcefromdatabase: count: %d", count);
                
                if ([table isEqualToString:@"diaper"]) {
                    [muarr removeObjectAtIndex:(day - 1) / 7];
                    [muarr insertObject:[NSString stringWithFormat:@"%i", count + 1] atIndex:(day - 1) / 7];
                }else{
                    if ([[set stringForColumn:@"duration"] isKindOfClass:[NSNull class]]) {
                        str = @"0";
                    }
                    else{
                        float dt = [[set stringForColumn:@"duration"] floatValue];
                        float olddt = [[muarr objectAtIndex:(day - 1) / 7] floatValue];
                        if (![table isEqualToString:@"diaper"]) {
                            str = [NSString stringWithFormat:@"%f", dt / 3600 + olddt];
                        }
                        [muarr removeObjectAtIndex:(day - 1) / 7];
                        [muarr insertObject:str atIndex:(day - 1) / 7];
                    }
                }
            }
        }
        [arrayCount addObject:muarr];
    }
    if (0 == fileTag) {
        [self setWeekName:fileTag andTAble:@"All" andpage:scrollpage];
    }else{
        int curmonth = 0;
        if (month <= scrollpage ) {
            curmonth = 12 - month + scrollpage;
        }
        [self setTitleName:[NSString stringWithFormat:@"%@(%i.%i)",NSLocalizedString(@"All",nil), [ACDate getCurrentYear], curmonth]];
    }
    [db close];
    NSLog(@"%@", arrayCount);
    return [NSArray arrayWithArray:arrayCount];
}

+ (NSArray *)scrollData:(int)scrollpage andTable:(NSString *)table andFieldTag:(int)fileTag{
    if ([table isEqualToString:@"All"]) {
        return  [self dataSourceFromDatabase:fileTag andpage:scrollpage andTable:table];
    }else{
        return [self dataFromTable:fileTag andpage:scrollpage andTable:table];
    }
}

+ (int)scrollWidth:(int)tag
{
    BOOL res = YES;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];

    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    NSArray *arr = [NSArray arrayWithObjects:@"bc_baby_play", @"bc_baby_bath", @"bc_baby_feed", @"bc_baby_sleep", @"bc_baby_diaper", nil];
    NSString *distinct = @"week";
    NSString *sql;
    int ret = 0;
    if (0 == tag) {
        distinct = @"week";
    }else{
        distinct = @"month";
    }
    for (NSString *table in arr) {
        int max = 0;
        int min = 0;
        //sql = [NSString stringWithFormat:@"select max(%@) from(select distinct(%@) from %@)", distinct, distinct, table];
        sql = [NSString stringWithFormat:@"select max(starttime) from %@", table];
        FMResultSet *set=[db executeQuery:sql];
        if ([set next]) {
            max = [set intForColumnIndex:0];
        }
        //sql = [NSString stringWithFormat:@"select min(%@) from(select distinct(%@) from %@)", distinct, distinct, table];
        sql = [NSString stringWithFormat:@"select min(starttime) from %@", table];
        set=[db executeQuery:sql];
        if ([set next]) {
            min = [set intForColumnIndex:0];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:max];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekCalendarUnit;
        [calendar setFirstWeekday:1];
        comps=[calendar components:unitFlags fromDate:date];
        int maxyear  = [comps year];
        int maxmonth = [comps month];
        int maxweek  = [comps week];
        
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:min];
        NSCalendar *calendar2 = [NSCalendar currentCalendar];
        NSDateComponents *comps2 = [[NSDateComponents alloc] init];
        NSInteger unitFlags2 = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekCalendarUnit;
        [calendar2 setFirstWeekday:1];
        comps2=[calendar2 components:unitFlags2 fromDate:date2];
        int minyear  = [comps2 year];
        int minmonth = [comps2 month];
        int minweek  = [comps2 week];
        
        int n = maxyear - minyear;
        if (0 == tag) {
            ret = maxweek + 52 * n - minweek + 1;
        }
        else
        {
            ret = maxmonth + 12 * n - minmonth + 1;
        }
        NSLog(@"width:ret:%d", ret);
    }
    [db close];
    return ret;
}

+ (int)scrollWidthWithTag:(int)tag andTableName:(NSString*)tablename
{
    BOOL res = YES;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    NSString *sql;
    int ret = 0;
    int max = 0;
    int min = 0;
    sql = [NSString stringWithFormat:@"select max(starttime) from bc_baby_%@", tablename];
    FMResultSet *set=[db executeQuery:sql];
    if ([set next]) {
        max = [set intForColumnIndex:0];
    }
    sql = [NSString stringWithFormat:@"select min(starttime) from bc_baby_%@", tablename];
    set=[db executeQuery:sql];
    if ([set next]) {
        min = [set intForColumnIndex:0];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:max];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekCalendarUnit;
    [calendar setFirstWeekday:1];
    comps=[calendar components:unitFlags fromDate:date];
    int maxyear  = [comps year];
    int maxmonth = [comps month];
    int maxweek  = [comps week];
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:min];
    NSCalendar *calendar2 = [NSCalendar currentCalendar];
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    NSInteger unitFlags2 = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekCalendarUnit;
    [calendar2 setFirstWeekday:1];
    comps2=[calendar2 components:unitFlags2 fromDate:date2];
    int minyear  = [comps2 year];
    int minmonth = [comps2 month];
    int minweek  = [comps2 week];
    
    int n = maxyear - minyear;
    if (0 == tag) {
        ret = maxweek + 52 * n - minweek + 1;
    }
    else
    {
        ret = maxmonth + 12 * n - minmonth + 1;
    }
    NSLog(@"table:%@ width:%d",tablename, ret);
    [db close];
    return ret;
}

+ (void)setTitleName:(NSString *)name{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:name forKey:@"NAME"];
    [df synchronize];
}

+ (void)setWeekName:(int)fileTag andTAble:(NSString *)table andpage:(int)scrollPage{
    NSString *name = [NSString stringWithFormat:@"%@(%i %@)",NSLocalizedString(table, nil), [self scrollWidth:fileTag] - scrollPage, NSLocalizedString(@"Week", nil)];
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:name forKey:@"NAME"];
    [df synchronize];
}

+ (void)setWeekName:(NSString *)table andrange:(NSString *)range{
    NSString *name = [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(table, nil), range];
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:name forKey:@"NAME"];
    [df synchronize];
}

@end
