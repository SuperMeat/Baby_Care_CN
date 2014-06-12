//
//  EnvironmentAdviceDataBase.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-11-28.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//
#import "FMDatabase.h"
#import "EnvironmentAdviceDB.h"
#import "AdviseData.h"
#import "AdviseLevel.h"

@implementation EnvironmentAdviceDB
+(id)dataBase
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

+(int)getSuggestionIdByIds:(NSString*)idsstr
{
    NSArray *ids = [idsstr componentsSeparatedByString:@";"];
    NSLog(@"%@",idsstr);
    int randomid = rand()%[ids count];
    return [[ids objectAtIndex:randomid] intValue];
}

+(NSArray*)selectSuggestionByCondition:(int)condition andValue:(NSNumber*) value
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"BC_Info" ofType:@"sqlite"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSString *conditionName = @"";
    switch (condition) {
        case ENVIR_SUGGESTION_TYPE_TEMP:
            conditionName = @"temp";
            break;
        case ENVIR_SUGGESTION_TYPE_HUMI:
            conditionName = @"humi";
            break;
        case ENVIR_SUGGESTION_TYPE_LIGHT:
            conditionName = @"light";
            break;
        case ENVIR_SUGGESTION_TYPE_NOICE:
            conditionName = @"noice";
            break;
        case ENVIR_SUGGESTION_TYPE_UV:
            conditionName = @"uv";
            break;
        case ENVIR_SUGGESTION_TYPE_PM25:
            conditionName = @"pm25";
            break;
        default:
            conditionName = @"temp";
            break;
    }
    
    NSString *sqlstr = [NSString stringWithFormat:@"select * from bc_suggestion_by_enviroment where %@_min <= ? and %@_max >= ?", conditionName, conditionName];
    
    FMResultSet *resultset=[db executeQuery:sqlstr,value,value];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:[NSString stringWithFormat:@"%@_suggestion_ids", conditionName]];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];;
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    sqlstr = [NSString stringWithFormat:@"select * from 			bc_suggestion_by_enviroment where %@_min < ? and %@_max  = 0 ", conditionName, conditionName];
    
    resultset = [db executeQuery:sqlstr,value];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:[NSString stringWithFormat:@"%@_suggestion_ids", conditionName]];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }
    
    sqlstr = [NSString stringWithFormat:@"select * from 			bc_suggestion_by_enviroment where %@_min = 0 and %@_max > ? ", conditionName, conditionName];
    
    resultset = [db executeQuery:sqlstr,value];
    if ([resultset next]) {
        NSString *str = [resultset stringForColumn:[NSString stringWithFormat:@"%@_suggestion_ids", conditionName]];
        if (str != nil) {
            AdviseLevel *al = [[AdviseLevel alloc]init];
            al.mAdviseId = [self getSuggestionIdByIds:str];
            al.mLevel    = [resultset intForColumn:@"status"];
            [array addObject:al];
            [db close];
            return array;
        }
    }

    [db close];
    return nil;
}


+(NSArray*)selectSuggestionBySid:(int)sid andCondition:(int)condition;
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"BC_Info" ofType:@"sqlite"];
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    FMResultSet *resultset=[db executeQuery:@"select * from 		bc_suggestion where suggestion_id = ? and type = ?",[NSNumber numberWithInt:sid],[NSNumber numberWithInt:condition]];
    while([resultset next])
    {
        AdviseData *ad = [[AdviseData alloc]init];
        ad.mAuthor  = [resultset stringForColumn:@"author"];
        ad.mContent = [resultset stringForColumn:@"content"];
        ad.mContent_cn = [resultset stringForColumn:@"content"];
        ad.mFromUrl = [resultset stringForColumn:@"url"];
        switch (condition) {
            case SUGGESTION_DB_TYPE_TEMP:
                ad.mType    = ADVISE_TYPE_TEMP;
                break;
            case SUGGESTION_DB_TYPE_HUMI:
                ad.mType    = ADVISE_TYPE_HUMI;
                break;
            case SUGGESTION_DB_TYPE_LIGHT:
                ad.mType    = ADVISE_TYPE_LIGHT;
                break;
            case SUGGESTION_DB_TYPE_NOICE:
                ad.mType    = ADVISE_TYPE_NOICE;
                break;
            case SUGGESTION_DB_TYPE_UV:
                ad.mType    = ADVISE_TYPE_UV;
                break;
            case SUGGESTION_DB_TYPE_PM25:
                ad.mType    = ADVISE_TYPE_PM25;
                break;
            default:
                ad.mType    = ADVISE_TYPE_TEMP;
                break;
        }
        
        [array addObject:ad];
    }
    
    [db close];
    return array;
}

@end
