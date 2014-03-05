//
//  BabyInfoManagerDB.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-2-27.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "BabyInfoManagerDB.h"

@implementation BabyInfoManagerDB
+(id)babyinfoDB
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

+(BOOL)createNewBabyInfo:(NSString*)name andBirthday:(NSDate*)birthday andTall:(NSString*)tall andWeight:(NSString*)weight andHC:(NSString*) hc andSex:(NSString*)sex andHeadPhoto:(NSString*)headphoto
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:DBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"CREATE TABLE if not exists baby_manager (baby_id  INTEGER PRIMARY KEY NOT NULL, name Varchar DEFAULT NULL, birth Timestamp DEFAULT NULL,tall Varchar DEFAULT NULL,weight Varchar  DEFAULT NULL,hc Varchar DEFAULT NULL,sex Varchar DEFAULT NULL,head Varchar DEFAULT NULL)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    
    res=[db executeUpdate:@"insert into baby_manager(name, birth, tall,weight,hc,sex,head) values(?,?,?,?,?,?,?)",name,birthday,tall,weight,hc,sex,headphoto];
    if (!res)
    {
        NSLog(@"插入失败");
        return res;
    }

    [db close];
    return res;
}

+(BOOL)updateBabyInfoName:(NSString*)name andId:(int)id
{
    return TRUE;
}

@end
