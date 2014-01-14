//
//  LogDBUtil.m
//  Parenting
//
//  Created by 爱摩信息科技 on 13-5-18.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "LogDBUtil.h"
#import "CacheFileUtil.h"

@implementation LogDBUtil

static LogDBUtil *sharedInstace;

+ (LogDBUtil*)sharedInstance
{
    if (sharedInstace == nil) {
        sharedInstace = [[LogDBUtil alloc] init];
    }
    return sharedInstace;
}

- (id)init
{
    [self db_open];
    return [super init];
}

- (BOOL)db_open
{
    NSString *documentsDirectory = [[[CacheFileUtil sharedInstance] getUserDocPath] stringByAppendingPathComponent:@"myDb"];
    if (sqlite3_open([documentsDirectory UTF8String], &database)==SQLITE_OK) {
        return YES;
    }
    return NO;
}

- (BOOL)createLogTable
{
    NSString *createTableSQLStr = [NSString stringWithFormat:@"create table if not exists logTable (logID integer primary key autoincrement,type integer,sing integer,capacity integer,duration integer,startTime text)"];
    
    const char *createTableSQL = [createTableSQLStr cStringUsingEncoding:NSASCIIStringEncoding];
    char *errMsg;
    if (sqlite3_exec(database, createTableSQL, NULL, NULL, &errMsg)==SQLITE_OK) {
        return YES;
    }else{
        NSLog(@"%s",errMsg);
    }
    return NO;
}


- (BOOL)insertLogTable:(NSString*)type sign:(NSString*)sign capacity:(NSString*)capacity duration:(NSString*)duration startTime:(NSString*)startTime
{
    [self createLogTable];
    
    NSString *stringInsertChatLogSQL = [NSString stringWithFormat:@"insert into logTable(type,sign,capacity,duration,startTime) values(%d,%d,%d,%d,'%@')",type.intValue,sign.intValue,capacity.intValue,duration.intValue,startTime];
    const char *insertChatLogSQL = [stringInsertChatLogSQL cStringUsingEncoding:NSASCIIStringEncoding];
    
    char *errMsg;
    if (sqlite3_exec(database, insertChatLogSQL, NULL, NULL, &errMsg)==SQLITE_OK) {
        return YES;
    }else{
        NSLog(@"%s",errMsg);
    }
    return NO;
}

- (NSArray*)queryLogTable:(NSString *)topCount
{
    const char *querySql = [[NSString stringWithFormat:@"select top %d type,startTime from logTable",topCount.intValue]cStringUsingEncoding:NSASCIIStringEncoding];
    sqlite3_stmt *queryStmt;
    sqlite3_prepare_v2(database, querySql, -1, &queryStmt, NULL);
    
    NSMutableArray *logTableArr = [[NSMutableArray alloc] initWithCapacity:topCount.intValue];
    while (sqlite3_step(queryStmt) == SQLITE_ROW) {
        int type = sqlite3_column_int(queryStmt, 0);
        char *startTime = (char*)sqlite3_column_text(queryStmt, 1);
        NSDictionary *tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%d", type],@"type",
                                 [NSString stringWithFormat:@"%s",startTime],@"startTime",nil] ;
        [logTableArr addObject:tempDic];
    }
    sqlite3_finalize(queryStmt);
    return logTableArr;
}

@end
