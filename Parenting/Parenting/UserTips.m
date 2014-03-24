//
//  UserTips.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-20.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "UserTips.h"

@implementation UserTips
+(id)dataBase
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

-(NSArray*)selectTipsCategoryByFlagId:(int)flagid
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"BC_Tips" ofType:@"sqlite"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }

    NSString *sql = @"";
    if (flagid == 0) {
        sql = @"select * from bc_tips_category";
    }
    else
    {
        sql = [NSString stringWithFormat:@"select * from bc_tips_category where category_id = %d", flagid];
    }
    
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"category_id"]] forKey:@"category_id"];
        [dic setValue:[resultset stringForColumn:@"category_title"] forKey:@"category_id"];
        [array addObject:dic];
    }
    
    return array;
}

-(NSArray*)selectTipsByCategoryId:(int)categoryid
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"BC_Tips" ofType:@"sqlite"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSString *sql =[NSString stringWithFormat:@"select * from bc_tips where categoryid = %d",categoryid];
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"tip_id"]] forKey:@"tip_id"];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@" category_id"]] forKey:@"category_id"];
        [dic setValue:[resultset stringForColumn:@"tip_title"] forKey:@"tip_title"];
        [dic setValue:[resultset stringForColumn:@"tip_summary"] forKey:@"tip_summary"];
        [dic setValue:[resultset stringForColumn:@"tip_pic_url"] forKey:@"tip_pic_url"];
        [dic setValue:[NSNumber numberWithLong:[resultset longForColumn:@"read_time"]] forKey:@"read_time"];
        [array addObject:dic];
    }
    
    return array;
}

-(NSArray*)selectTipsByTipId:(int)tipid
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"BC_Tips" ofType:@"sqlite"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSString *sql =[NSString stringWithFormat:@"select * from bc_tips where tip_id = %d",tipid];
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"tip_id"]] forKey:@"tip_id"];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@" category_id"]] forKey:@"category_id"];
        [dic setValue:[resultset stringForColumn:@"tip_title"] forKey:@"tip_title"];
        [dic setValue:[resultset stringForColumn:@"tip_summary"] forKey:@"tip_summary"];
        [dic setValue:[resultset stringForColumn:@"tip_pic_url"] forKey:@"tip_pic_url"];
        [dic setValue:[NSNumber numberWithLong:[resultset longForColumn:@"read_time"]] forKey:@"read_time"];
        [array addObject:dic];
    }
    
    return array;
}

@end
