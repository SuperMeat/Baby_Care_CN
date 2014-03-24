//
//  BabyDataDB.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-2-27.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "BabyDataDB.h"

@implementation BabyDataDB
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

-(NSArray*)selectWFAByType:(int)type andSex:(int)sex
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
    NSString *sql =[NSString stringWithFormat:@"select * from bc_wfa where type = %d and sex = %d",type, sex];
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"type"]] forKey:@"type"];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"sex"]] forKey:@"sex"];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"age"]] forKey:@"age"];
        [dic setValue:[NSNumber numberWithDouble:[resultset doubleForColumn:@"L"]] forKey:@"L"];
        [dic setValue:[NSNumber numberWithDouble:[resultset doubleForColumn:@"M"]] forKey:@"M"];
        [dic setValue:[NSNumber numberWithDouble:[resultset doubleForColumn:@"S"]] forKey:@"S"];
        [dic setValue:[NSNumber numberWithDouble:[resultset doubleForColumn:@"P01"]] forKey:@"P01"];
        [dic setValue:[NSNumber numberWithDouble:[resultset doubleForColumn:@"P25"]] forKey:@"P25"];
        [dic setValue:[NSNumber numberWithDouble:[resultset doubleForColumn:@"P50"]] forKey:@"P50"];
        [dic setValue:[NSNumber numberWithDouble:[resultset doubleForColumn:@"P75"]] forKey:@"P75"];
        [dic setValue:[NSNumber numberWithDouble:[resultset doubleForColumn:@"P99"]] forKey:@"P99"];
        [array addObject:dic];
    }
    
    return array;
}


@end
