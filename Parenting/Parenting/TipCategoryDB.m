//
//  TipCategoryDB.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-5-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "TipCategoryDB.h"

@implementation TipCategoryDB

+(id)tipCategoryDB{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}
 
+(NSArray*)selectAllCategoryList{
    NSArray *resArray = [[NSArray alloc]init];;
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    NSString *sql =@"select * from bc_tips_category order by category_id";
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        int category_id = [resultset intForColumn:@"category_id"];
        NSString * name = [resultset stringForColumn:@"name"];
        NSString * describe = [resultset stringForColumn:@"describe"];
        NSString * icon = [resultset stringForColumn:@"icon"];
        
        NSArray *arr = [[NSArray alloc] initWithObjects:
                        [NSNumber numberWithInt:category_id],name,describe,icon,
                        nil];
        resArray = [resArray arrayByAddingObject:arr];
    }
    [db close];
    return resArray;
}

+(BOOL)insertCategoryDB:(int)categoryId
             CreateTime:(int)createTime
             UpdateTime:(int)updateTime
               ParentId:(int)parentId
                   name:(NSString*)name
               describe:(NSString*)describe
                   icon:(NSString*)icon{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_tips_category (category_id INTEGER PRIMARY KEY,create_time integer not null, update_time INTEGER default 0,parent_id integer default 0, name Varchar DEFAULT NULL,describe TEXT DEFAULT NULL, icon Varchar DEFAULT NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return res;
    }
    
    if (![self checkExist:categoryId]) {
        res=[db executeUpdate:@"insert into bc_tips_category (category_id, create_time, update_time, parent_id, name,describe, icon) values(?,?,?,?,?,?,?)",
             [NSNumber numberWithInt:categoryId],
             [NSNumber numberWithInt:createTime],
             [NSNumber numberWithInt:updateTime],
             [NSNumber numberWithInt:parentId],
             name,
             describe,
             icon
             ];

    }
    else{
        res=[db executeUpdate:@"update bc_tips_category set update_time=?,parent_id=?,name=?,describe=?,icon=? where category_id=?",
             [NSNumber numberWithInt:categoryId],
             [NSNumber numberWithInt:parentId],
             name,
             describe,
             icon,
             [NSNumber numberWithInt:categoryId]];
    }
    
    
    if (!res) {
        NSLog(@"数据库插入失败");
        [db close];
        return res;
    }
    [db close];
    return res;
}

+(BOOL)checkExist:(int)categoryId{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_tips_category (category_id INTEGER PRIMARY KEY,create_time integer not null, update_time INTEGER default 0,parent_id integer default 0, name Varchar DEFAULT NULL,describe TEXT DEFAULT NULL,  icon Varchar DEFAULT NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return res;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select category_id from bc_tips_category where category_id = %d", categoryId];
    
    FMResultSet *resultset=[db executeQuery:sql];
    res = NO;
    while ([resultset next]) {
        res = YES;
    }
    
    return res;

}

#pragma 返回YES则需要更新
+(BOOL)checkUpdateState:(int)categoryId
             UpdateTime:(int)updateTime{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_tips_category (category_id INTEGER PRIMARY KEY,create_time integer not null, update_time INTEGER default 0,parent_id integer default 0, name Varchar DEFAULT NULL,describe TEXT DEFAULT NULL,  icon Varchar DEFAULT NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return res;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select update_time from bc_tips_category where category_id = %d", categoryId];
    
    FMResultSet *resultset=[db executeQuery:sql];
    res = YES;
    while ([resultset next]) {
        int update_Time = [resultset intForColumn:@"update_time"];
        if (update_Time == updateTime) {
            res = NO;
        }
    }

    return res;
}

+(BOOL)checkSubscribe:(int)UserID
           categoryId:(int)categoryId
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    NSString *sql =[NSString stringWithFormat:@"select * from bc_user where user_id = %d",UserID];
    FMResultSet *resultset=[db executeQuery:sql];
    res = NO;
    if ([resultset next]) {
//        [resultset stringForColumn:@"category_ids"];
        NSRange range= [[resultset stringForColumn:@"category_ids"] rangeOfString:[NSString stringWithFormat:@",%d,",categoryId]];
        if (range.length != 0) {
            res = YES;
        }
    }
    [db close];
    return res;
}

@end
