//
//  WhoDataBase.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-18.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "WhoDataBase.h"

@implementation WhoDataBase

+(id)whoDB{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

#pragma 获取数据库对应X轴的描点数据
+(NSArray*)getDataArrayByXposition:(NSArray*)xPosition Condition:(NSString*)condition TableName:(NSString*) tableName
{
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:xPosition.count];
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:WHODBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select %@ from %@ where age in (%@)",condition,tableName,[xPosition componentsJoinedByString:@","]];
    FMResultSet *set=[db executeQuery:sql];
    while ([set next]) {
        [dataArray addObject:[set stringForColumn:condition]];
    }
    if (!res) {
        NSLog(@"插入失败");
        return nil;
    }
    [db close];
    return dataArray;
}


@end
