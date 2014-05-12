//
//  UserTipsDB.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-20.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "UserTipsDB.h"

@implementation UserTipsDB
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
    NSString *path=[[NSBundle mainBundle] pathForResource:@"BC_Info" ofType:@"sqlite"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
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
    [db close];
    return array;
}

-(NSArray*)selectTipListByCategoryId:(int)categoryid
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"BC_Info" ofType:@"sqlite"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    NSString *sql =[NSString stringWithFormat:@"select * from bc_tips where categoryid = %d",categoryid];
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next])
    {
        NSDictionary *dic = [self selectTipByTipId:[resultset intForColumn:@"tip_id"]];
        if (dic != nil)
        {
            [array addObject:dic];
        }
    }
    
    [db close];
    return array;
}

-(NSDictionary*)selectTipByTipId:(int)tipid
{
    BOOL res;
    NSString *path=[[NSBundle mainBundle] pathForResource:@"BC_Info" ofType:@"sqlite"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    NSString *sql =[NSString stringWithFormat:@"select * from bc_tips where tip_id = %d",tipid];
    FMResultSet *resultset=[db executeQuery:sql];
   
    if ([resultset next]) {
         NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:6];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"tip_id"]] forKey:@"tip_id"];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@" category_id"]] forKey:@"category_id"];
        [dic setValue:[resultset stringForColumn:@"tip_title"] forKey:@"tip_title"];
        [dic setValue:[resultset stringForColumn:@"tip_summary"] forKey:@"tip_summary"];
        [dic setValue:[resultset stringForColumn:@"tip_pic_url"] forKey:@"tip_pic_url"];
        [dic setValue:[NSNumber numberWithLong:[resultset longForColumn:@"read_time"]] forKey:@"read_time"];
        [db close];
        return dic;
    }
    [db close];
    return nil;
}

@end
