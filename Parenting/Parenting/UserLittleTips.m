//
//  UserLittleTips.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-6-17.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "UserLittleTips.h"

@implementation UserLittleTips
+(id)dataBase
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

-(NSArray*)selectLittleTipsByAge:(int)age andCondition:(int)condition;
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

    NSString *strCondition = @"";
    switch (condition) {
        case QCM_TYPE_PLAY:
            strCondition = @"play";
            break;
        case QCM_TYPE_BATH:
            strCondition = @"bath";
            break;
        case QCM_TYPE_FEED:
            strCondition = @"feed";
            break;
        case QCM_TYPE_SLEEP:
            strCondition = @"sleep";
            break;
        case QCM_TYPE_DIAPER:
            strCondition = @"diaper";
            break;
        default:
            break;
    }
    
    NSString *sql = @"";
    sql = [NSString stringWithFormat:@"select * from bc_littletips where start_month<= %d and end_month >= %d and %@ = 1 order by tips_lock asc limit 3", age,age, strCondition];
    
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"littletips_id"]] forKey:@"tips_id"];
        [dic setValue:[resultset stringForColumn:@"tips_content"] forKey:@"content"];
        [array addObject:dic];
    }
    [db close];
    return array;
}

@end
