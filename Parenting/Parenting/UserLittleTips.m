//
//  UserLittleTips.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-6-17.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "UserLittleTips.h"

@implementation UserLittleTips
+(id)dataBase
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

-(NSArray*)selectLittleTipsByAge:(int)age andCondition:(int)condition;
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }

    NSString *strCondition = @"";
    switch (condition) {
        case QCM_TYPE_PLAY:
            strCondition = @"play";
            break;
        case QCM_TYPE_BATH:
            strCondition = @"bath";
            break;
        case QCM_TYPE_FEED:
            strCondition = @"feed";
            break;
        case QCM_TYPE_SLEEP:
            strCondition = @"sleep";
            break;
        case QCM_TYPE_DIAPER:
            strCondition = @"diaper";
            break;
        case QCM_TYPE_MEDICINE:
            strCondition = @"medicine";
            break;
        default:
            break;
    }
    
    NSString *sql = @"";
    sql = [NSString stringWithFormat:@"select * from bc_littletips where start_month<= %d and end_month >= %d and %@ = 1 order by read_time asc limit 3", age,age, strCondition];
    
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next])
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"littletips_id"]] forKey:@"tips_id"];
        [dic setValue:[resultset stringForColumn:@"tips_content"] forKey:@"content"];
        [array addObject:dic];
    }
    [db close];
    return array;
}

-(BOOL)updateReadTime:(int)tips_id
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }

    NSString *sql = [NSString stringWithFormat:@"update bc_littletips set read_time = %ld where littletips_id = %d", [ACDate getTimeStampFromDate:[ACDate date]], tips_id];
    
    res=[db executeUpdate:sql];
    if (!res) {
        NSLog(@"数据库更新失败");
        [db close];
        return res;
    }

    return res;
}


+(BOOL)insertLittleTip:(int)littleTipId
            CreateTime:(int)createTime
            UpdateTime:(int)updateTime
            StartMonth:(int)startMonth
              EndMonth:(int)endMonth
               TipLock:(int)tipLock
            TipContent:(NSString*)tipContent
                  Feed:(int)feed
                 Sleep:(int)sleep
                  Bath:(int)bath
                  Play:(int)play
                Diaper:(int)diaper
                   Cry:(int)cry{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return NO;
    }
    
    if (![DataBase checkRecordExistByID:littleTipId
                              FiledName:@"littletips_id"
                              TableName:@"bc_littleTips"
                                 DBPath:UDBPATH]) {
        res=[db executeUpdate:@"insert into bc_littleTips (littletips_id, create_time, update_time, start_month, end_month,tips_lock, tips_content,feed,sleep,bath,play,diaper,cry) values(?,?,?,?,?,?,?,?,?,?,?,?,?)",
             [NSNumber numberWithInt:littleTipId],
             [NSNumber numberWithInt:createTime],
             [NSNumber numberWithInt:updateTime],
             [NSNumber numberWithInt:startMonth],
             [NSNumber numberWithInt:endMonth],
             [NSNumber numberWithInt:tipLock],
             tipContent,
             [NSNumber numberWithInt:feed],
             [NSNumber numberWithInt:sleep],
             [NSNumber numberWithInt:bath],
             [NSNumber numberWithInt:play],
             [NSNumber numberWithInt:diaper],
             [NSNumber numberWithInt:cry]
             ];
    }
    else{
        //更新
        res=[db executeUpdate:@"update bc_littletips set update_time=?,start_month=?,end_month=?,tips_lock=?,tips_content=?,feed=?,sleep=?,bath=?,play=?,diaper=?,cry=? where littletips_id=?",
             [NSNumber numberWithInt:updateTime],
             [NSNumber numberWithInt:startMonth],
             [NSNumber numberWithInt:endMonth],
             [NSNumber numberWithInt:tipLock],
             tipContent,
             [NSNumber numberWithInt:feed],
             [NSNumber numberWithInt:sleep],
             [NSNumber numberWithInt:bath],
             [NSNumber numberWithInt:play],
             [NSNumber numberWithInt:diaper],
             [NSNumber numberWithInt:cry],
             [NSNumber numberWithInt:littleTipId]];
    }
    return res;
}

+(long)getLastUpdateTime{
    long res = 9999999999;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    
    NSString *sql = @"select max(update_time) as LastUpdateTime from bc_littleTips";
    FMResultSet *resultset=[db executeQuery:sql];
    res = 0;
    while ([resultset next]) {
        int lastUpdateTime = [resultset intForColumn:@"LastUpdateTime"];
        res = (long)lastUpdateTime;
    }
    [db close];
    return res;
}

@end
