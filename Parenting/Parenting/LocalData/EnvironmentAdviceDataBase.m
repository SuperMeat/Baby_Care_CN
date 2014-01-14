//
//  EnvironmentAdviceDataBase.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-11-28.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//
#import "FMDatabase.h"
#import "EnvironmentAdviceDataBase.h"
#import "AdviseData.h"
#import "AdviseLevel.h"

@implementation EnvironmentAdviceDataBase
+(id)dataBase
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

+(int)getSuggestionIdByIds:(NSString*)idsstr
{
    NSArray *ids = [idsstr componentsSeparatedByString:@";"];
    NSLog(@"%@",idsstr);
    int randomid = rand()%[ids count];
    return [[ids objectAtIndex:randomid] intValue];
}

+(NSArray*)selectSleepSuggestionByTemp:(int)temp
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 			sleep_suggestion_by_environment where temp_min <= ? and temp_max >= ?",[NSNumber numberWithInt:temp],[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];;
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from sleep_suggestion_by_environment where temp_max = 0 and temp_min < ?",[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from sleep_suggestion_by_environment where temp_min = 0 and temp_max > ?",[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }

    return array;
}

+(NSArray*)selectFeedSuggestionByTemp:(int)temp
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 			feed_suggestion_by_environment where temp_min <= ? and temp_max >= ?",[NSNumber numberWithInt:temp],[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];;
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from feed_suggestion_by_environment where temp_max = 0 and temp_min < ?",[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from feed_suggestion_by_environment where temp_min = 0 and temp_max > ?",[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }

    return array;
}

+(NSArray*)selectPlaySuggestionByTemp:(int)temp
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 			play_suggestion_by_environment where temp_min <= ? and temp_max >= ?",[NSNumber numberWithInt:temp],[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];;
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from play_suggestion_by_environment where temp_max = 0 and temp_min < ?",[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from play_suggestion_by_environment where temp_min = 0 and temp_max > ?",[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    return array;
}

+(NSArray*)selectBathSuggestionByTemp:(int)temp
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 			bath_suggestion_by_environment where temp_min <= ? and temp_max >= ?",[NSNumber numberWithInt:temp],[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];;
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from bath_suggestion_by_environment where temp_max = 0 and temp_min < ?",[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from bath_suggestion_by_environment where temp_min = 0 and temp_max > ?",[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    return array;
}

+(NSArray*)selectDiaperSuggestionByTemp:(int)temp
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 			diaper_suggestion_by_environment where temp_min <= ? and temp_max >= ?",[NSNumber numberWithInt:temp],[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];;
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from diaper_suggestion_by_environment where temp_max = 0 and temp_min < ?",[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from diaper_suggestion_by_environment where temp_min = 0 and temp_max > ?",[NSNumber numberWithInt:temp]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"temp_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    return array;
}

+(NSArray*)selectFeedSuggestionByHumi:(int)humi
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 			feed_suggestion_by_environment where humi_min <= ? and humi_max >= ?",[NSNumber numberWithInt:humi],[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];;
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from feed_suggestion_by_environment where humi_max = 0 and humi_min < ?",[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from feed_suggestion_by_environment where humi_min = 0 and humi_max > ?",[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    return array;
}

+(NSArray*)selectPlaySuggestionByHumi:(int)humi
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 			play_suggestion_by_environment where humi_min <= ? and humi_max >= ?",[NSNumber numberWithInt:humi],[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];;
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from play_suggestion_by_environment where humi_max = 0 and humi_min < ?",[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from play_suggestion_by_environment where humi_min = 0 and humi_max > ?",[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
        
    }
    
    return array;
}

+(NSArray*)selectBathSuggestionByHumi:(int)humi
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 			bath_suggestion_by_environment where humi_min <= ? and humi_max >= ?",[NSNumber numberWithInt:humi],[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];;
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from bath_suggestion_by_environment where humi_max = 0 and humi_min < ?",[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from bath_suggestion_by_environment where humi_min = 0 and humi_max > ?",[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
        
    }
    return array;
}

+(NSArray*)selectSleepSuggestionByHumi:(int)humi
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 			sleep_suggestion_by_environment where humi_min <= ? and humi_max >= ?",[NSNumber numberWithInt:humi],[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];;
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from sleep_suggestion_by_environment where humi_max = 0 and humi_min < ?",[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from sleep_suggestion_by_environment where humi_min = 0 and humi_max > ?",[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    return array;
}

+(NSArray*)selectDiaperSuggestionByHumi:(int)humi
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 			diaper_suggestion_by_environment where humi_min <= ? and humi_max >= ?",[NSNumber numberWithInt:humi],[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];;
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from diaper_suggestion_by_environment where humi_max = 0 and humi_min < ?",[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    resultset = [db executeQuery:@"select * from diaper_suggestion_by_environment where humi_min = 0 and humi_max > ?",[NSNumber numberWithInt:humi]];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:@"humi_suggestion_ids"];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
        
    }
    return array;
}

+(NSArray*)selectFeedSuggestionByPM25:(int)pm25
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    
    return array;
}

+(NSArray*)selectPlaySuggestionByPM25:(int)pm25
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    
    return array;
}

+(NSArray*)selectBathSuggestionByPM25:(int)pm25
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    
    return array;
}

+(NSArray*)selectSleepSuggestionByPM25:(int)pm25
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    
    return array;
}

+(NSArray*)selectDiaperSuggestionByPM25:(int)pm25
{
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    
    return array;
}

+(NSArray*)selectsuggestiontemp:(int)sid
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 		temp_suggestion where id = ?",[NSNumber numberWithInt:sid]];
    while([resultset next])
    {
        AdviseData *ad = [[AdviseData alloc]init];
        ad.mAuthor  = [resultset stringForColumn:@"author"];
        ad.mContent = [resultset stringForColumn:@"content_en"];
        ad.mContent_cn = [resultset stringForColumn:@"content_cn"];
        ad.mFromUrl = [resultset stringForColumn:@"url"];
        ad.mType    = ADVISE_TYPE_TEMP;
        [array addObject:ad];
    }
    
    [db close];
    return array;
}

+(NSArray*)selectsuggestionhumi:(int)sid
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 		humi_suggestion where id = ?",[NSNumber numberWithInt:sid]];
    while([resultset next])
    {
        AdviseData *ad = [[AdviseData alloc]init];
        ad.mAuthor  = [resultset stringForColumn:@"author"];
        ad.mContent = [resultset stringForColumn:@"content_en"];
        ad.mContent_cn = [resultset stringForColumn:@"content_cn"];
        ad.mFromUrl = [resultset stringForColumn:@"url"];
        ad.mType    = ADVISE_TYPE_HUMI;
        [array addObject:ad];
    }
    
    [db close];
    return array;
}

+(NSArray*)selectsuggestionlight:(int)sid
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 		light_suggestion where id = ?",[NSNumber numberWithInt:sid]];
    while([resultset next])
    {
        AdviseData *ad = [[AdviseData alloc]init];
        ad.mAuthor  = [resultset stringForColumn:@"author"];
        ad.mContent = [resultset stringForColumn:@"content_en"];
        ad.mContent_cn = [resultset stringForColumn:@"content_cn"];
        ad.mFromUrl = [resultset stringForColumn:@"url"];
        ad.mType    = ADVISE_TYPE_LIGHT;
        [array addObject:ad];
    }
    
    [db close];
    return array;
}

+(NSArray*)selectsuggestionnoice:(int)sid
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 		noice_suggestion where id = ?",[NSNumber numberWithInt:sid]];
    while([resultset next])
    {
        AdviseData *ad = [[AdviseData alloc]init];
        ad.mAuthor  = [resultset stringForColumn:@"author"];
        ad.mContent = [resultset stringForColumn:@"content_en"];
        ad.mContent_cn = [resultset stringForColumn:@"content_cn"];
        ad.mFromUrl = [resultset stringForColumn:@"url"];
        ad.mType    = ADVISE_TYPE_NOICE;
        [array addObject:ad];
    }
    
    [db close];
    return array;
}

+(NSArray*)selectsuggestionpm25:(int)sid
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 		pm25_suggestion where id = ?",[NSNumber numberWithInt:sid]];
    while([resultset next])
    {
        AdviseData *ad = [[AdviseData alloc]init];
        ad.mAuthor  = [resultset stringForColumn:@"author"];
        ad.mContent = [resultset stringForColumn:@"content_en"];
        ad.mContent_cn = [resultset stringForColumn:@"content_cn"];
        ad.mFromUrl = [resultset stringForColumn:@"url"];
        ad.mType    = ADVISE_TYPE_PM25;
        [array addObject:ad];
    }
    
    [db close];
    return array;
}

+(NSArray*)selectsuggestionuv:(int)sid
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Babyinfo" ofType:@"rdb"];
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 		uv_suggestion where id = ?",[NSNumber numberWithInt:sid]];
    while([resultset next])
    {
        AdviseData *ad = [[AdviseData alloc]init];
        ad.mAuthor  = [resultset stringForColumn:@"author"];
        ad.mContent = [resultset stringForColumn:@"content_en"];
        ad.mContent_cn = [resultset stringForColumn:@"content_cn"];
        ad.mFromUrl = [resultset stringForColumn:@"url"];
        ad.mType    = ADVISE_TYPE_UV;
        [array addObject:ad];
    }
    
    [db close];
    return array;
}

@end
