//
//  BabyMessageDataDB
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-11.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "BabyMessageDataDB.h"

@implementation BabyMessageDataDB

+(id)babyMessageDB{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

-(BOOL)checkBabyMsgTable{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(ACCOUNTUID,BABYID)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return NO;
    }
    
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_msg (create_time int NOT NULL,update_time int not NULL,msg_type int not NULL,key Varchar  DEFAULT NULL,msg_content Varchar  DEFAULT NULL,pic_url Varchar  DEFAULT NULL)"]; 
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return NO;
    }
    return YES;
}

-(NSMutableArray*)selectAll{
    BOOL res;
    res = [self checkBabyMsgTable];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(ACCOUNTUID,BABYID)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    if (res) {
        NSString *sql = @"select * from bc_baby_msg order by create_time desc";
        FMResultSet *resultset=[db executeQuery:sql];
        NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
        while ([resultset next])
        {
            NSMutableArray *singleData = [[NSMutableArray alloc]initWithCapacity:0];
            [singleData addObject:[NSNumber numberWithInt:[resultset intForColumn:@"msg_type"]]];
            [singleData addObject:[resultset stringForColumn:@"msg_content"]];
            [singleData addObject:[resultset stringForColumn:@"pic_url"]];
            [singleData addObject:@""]; //keyword
            [singleData addObject:[NSNumber numberWithInt:[resultset intForColumn:@"create_time"]]]; //create_time
            [singleData addObject:[resultset stringForColumn:@"key"]];
            [array addObject:singleData];
        }
        return array;
        [db close];
    }
    return nil;
}

-(BOOL)insertBabyMessageNormal:(int)create_time
                    UpdateTime:(int)update_time
                           key:(NSString*)key
                          type:(int)msg_type
                       content:(NSString*)msg_content{
    BOOL res;
    res = [self checkBabyMsgTable];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(ACCOUNTUID,BABYID)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    res=[db executeUpdate:@"insert into bc_baby_msg values(?,?,?,?,?,?)",
         [NSNumber numberWithLong:create_time],
         [NSNumber numberWithLong:update_time],
         [NSNumber numberWithInt:msg_type],
         key,
         msg_content,
         [NSString stringWithFormat:@""]
         ];
    
    if (!res) {
        NSLog(@"%@",NSHomeDirectory());
        NSLog(@"插入失败");
        [db close];
        return res;
    }
    
    [db close];
    return res;
}

-(BOOL)deleteBabyMessage:(NSString*) key
{
    BOOL res;
    res = [self checkBabyMsgTable];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(ACCOUNTUID,BABYID)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    
    res=[db executeUpdate:@"delete from bc_baby_msg where key = ?", key];
    
    if (!res) {
        NSLog(@"数据库删除失败");
        [db close];
        return res;
    }
    
    [db close];
    return res;
}


/** vaccineExist **/
/*
 *  res:0 该条提醒未入库->入库 | 1 该条提醒已入库->更新 | -1 不需操作
 */
-(int)isVaccineExistWithKey:(int)keyId Days:(int)days{
    int res;
    res = [self checkBabyMsgTable];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(ACCOUNTUID,BABYID)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    res = 0;
    NSString *sql = [NSString stringWithFormat:@"select * from bc_baby_msg where msg_type = 10 and key = '%d' order by create_time desc",keyId];
    FMResultSet *resultset=[db executeQuery:sql];
    if ([resultset next]) {
        NSDate *create_date = [ACDate getDateFromTimeStamp:[resultset longForColumn:@"create_time"]];
        //判断是否今日插入更新
        if ((days == 5 || days == 3|| days == 1) && (![[ACDate dateFomatdate:create_date] isEqualToString:[ACDate dateFomatdate:[NSDate date]]]))
        {
            res = 1;
        }else{
            res = -1;
        }
    }
    [db close];
    return res;
}

/* 评测:今日内是否已插入提醒消息 */
/* res:0 该条提醒未入库->入库 | -1 不需操作 */
-(int)isTestExistTodayWithKey:(int)keyId{
    int res;
    res = [self checkBabyMsgTable];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(ACCOUNTUID,BABYID)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    res = 0;
    NSString *sql = [NSString stringWithFormat:@"select * from bc_baby_msg where msg_type = 11 and key = '%d' order by create_time desc",keyId];
    FMResultSet *resultset=[db executeQuery:sql];
    if ([resultset next]) {
        NSDate *create_date = [ACDate getDateFromTimeStamp:[resultset longForColumn:@"create_time"]];
        //判断是否今日插入更新
        if ([[ACDate dateFomatdate:create_date] isEqualToString:[ACDate dateFomatdate:[NSDate date]]])
        {
            res = -1;
        }
    }
    [db close];
    return res;
}

//日志提醒
-(BOOL)isNoteRemind{
    BOOL res;
    res = [self checkBabyMsgTable];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(ACCOUNTUID,BABYID)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return NO;
    }
    
    res = NO;
    FMResultSet *resultset=[db executeQuery:@"select * from bc_baby_msg where msg_type = 12 order by create_time desc"];
    if ([resultset next]) {
        NSDate *create_date = [ACDate getDateFromTimeStamp:[resultset longForColumn:@"create_time"]];
        //判断是否今日插入更新
        if ([ACDate getDiffDayFormNowToDate:create_date] > 3)
        {
            res = YES;
        }
    }
    else {
        res = YES;
    }
    [db close];
    return res;
}

/* 评测:今日内是否已插入生理记录提醒消息 */
/* res:0 该条提醒未入库->入库 | -1 不需操作 */
-(int)isPhyExistTodayWithType:(int)type{
    int res;
    res = [self checkBabyMsgTable];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(ACCOUNTUID,BABYID)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    res = 0;
    NSString *sql = [NSString stringWithFormat:@"select * from bc_baby_msg where msg_type = %d order by create_time desc",type];
    FMResultSet *resultset=[db executeQuery:sql];
    if ([resultset next]) {
        NSDate *create_date = [ACDate getDateFromTimeStamp:[resultset longForColumn:@"create_time"]];
        //判断是否今日插入更新
        if ([[ACDate dateFomatdate:create_date] isEqualToString:[ACDate dateFomatdate:[NSDate date]]])
        {
            res = -1;
        }
    }
    [db close];
    return res;
}

/** 检测系统更新消息是否存在 **/
-(BOOL)isSysUpdateMsgExist:(NSString*)version{
    BOOL res;
    res = [self checkBabyMsgTable];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(ACCOUNTUID,BABYID)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return NO;
    }
    
    res = NO;
    FMResultSet *resultset=[db executeQuery:@"select * from bc_baby_msg where msg_type = 0 and key=? order by create_time desc",version];
    if ([resultset next]) {
        return YES;
    }
    [db close];
    return res;
}

@end
