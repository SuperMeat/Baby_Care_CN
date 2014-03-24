//
//  UserRecordDB.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-19.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "UserDataDB.h"

@implementation UserDataDB
+(id)dataBase
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

-(BOOL)createNewUser:(int)user_id andCategoryIds:(NSString*)cgids andIcon:(NSString*)icon andUserType:(int)userType andUserAccount:(NSString*)account andAppVer:(NSString*)appver andCreateTime:(int)createtime andUpdateTime:(int)updatetime
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_user (user_id int NOT NULL PRIMARY KEY, category_ids Varchar DEFAULT NULL, icon Varchar DEFAULT NULL, user_type INTEGER DEFAULT NULL, user_account Varchar DEFAULT NULL, app_ver Varchar DEFAULT NULL, create_time int not NULL, update_time int not NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    
    res=[db executeUpdate:@"insert into bc_user values(?,?,?,?,?,?,?,?)",[NSNumber numberWithInt:user_id],
         cgids,
         icon,
         [NSNumber numberWithInt:userType],
         account,
         appver,
         [NSNumber numberWithLong:createtime],
         [NSNumber numberWithLong:updatetime]
    ];
    
    if (!res) {
        NSLog(@"%@",NSHomeDirectory());
        NSLog(@"插入失败");
        return res;
    }
    [db close];
    
    return res;

}

-(NSDictionary*)selectUser:(int)user_id
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSString *sql =[NSString stringWithFormat:@"select * from bc_user where user_id = %d",user_id];
    FMResultSet *resultset=[db executeQuery:sql];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if ([resultset next]) {
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"user_id"]] forKey:@"user_id"];
        [dic setValue:[resultset stringForColumn:@"category_ids"] forKey:@"category_ids"];
        [dic setValue:[resultset stringForColumn:@"icon"] forKey:@"icon"];
        [dic setValue:[NSNumber numberWithInt:@"user_type"] forKey:@"user_type"];
        [dic setValue:[resultset stringForColumn:@"user_account"] forKey:@"user_account"];
        [dic setValue:[resultset stringForColumn:@"app_ver"] forKey:@"app_ver"];
        [dic setValue:[NSNumber numberWithLong:[resultset longForColumn:@"create_time"]] forKey:@"create_time"];
        [dic setValue:[NSNumber numberWithLong:[resultset longForColumn:@"update_time"]] forKey:@"update_time"];
    }
    
    return dic;

}

-(BOOL)updateUserCategoryIds:(NSString*)ids andUserId:(int)user_id
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"update bc_user set  category_ids= ? where user_id=?",ids, [NSNumber numberWithInt:user_id]];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)updateUserPhoto:(NSString*)photo andUserId:(int)user_id
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"update bc_user set icon= ? where user_id=?",photo, [NSNumber numberWithInt:user_id]];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

@end
