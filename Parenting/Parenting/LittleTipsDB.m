//
//  LittleTipsDB.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-7-2.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "LittleTipsDB.h"

@implementation LittleTipsDB

+(id)littleTipsDB{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
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
        res=[db executeUpdate:@"insert into bc_littleTips (littletips_id, create_time, update_time, start_month, end_month,tips_lock, tips_content,feed,sleep,bath,play,diaper,cry) values(?,?,?,?,?,?,?,?,?,?,?,?,?,)",
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

@end
