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
    
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_msg (create_time int PRIMARY KEY NOT NULL,update_time int not NULL,msg_type int not NULL,key Varchar  DEFAULT NULL,msg_content Varchar  DEFAULT NULL,pic_url Varchar  DEFAULT NULL)"];
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

-(BOOL)deleteBabyMessage:(int) create_time
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
    
    res=[db executeUpdate:@"delete from bc_baby_msg where create_time = ?", [NSNumber numberWithInt:create_time]];
    
    if (!res) {
        NSLog(@"数据库删除失败");
        [db close];
        return res;
    }
    
    [db close];
    return res;
}

@end
