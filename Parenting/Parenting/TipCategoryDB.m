//
//  TipCategoryDB.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-5-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "TipCategoryDB.h"
#import "ACDate.h"

@implementation TipCategoryDB

+(id)tipCategoryDB{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}
 
+(NSArray*)selectAllCategoryList{
    NSArray *resArray = [[NSArray alloc]init];;
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    NSString *sql =@"select * from bc_tips_category order by category_id";
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        int category_id = [resultset intForColumn:@"category_id"];
        NSString * name = [resultset stringForColumn:@"name"];
        NSString * describe = [resultset stringForColumn:@"describe"];
        NSString * icon = [resultset stringForColumn:@"icon"];
        
        NSArray *arr = [[NSArray alloc] initWithObjects:
                        [NSNumber numberWithInt:category_id],name,describe,icon,
                        nil];
        resArray = [resArray arrayByAddingObject:arr];
    }
    [db close];
    return resArray;
}

+(NSArray*)selectCategoryList:(int)parent_id{
    NSArray *resArray = [[NSArray alloc]init];;
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from bc_tips_category where parent_id=%d order by category_id",parent_id];
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        int category_id = [resultset intForColumn:@"category_id"];
        NSString * name = [resultset stringForColumn:@"name"];
        NSString * describe = [resultset stringForColumn:@"describe"];
        NSString * icon = [resultset stringForColumn:@"icon"];
        
        NSArray *arr = [[NSArray alloc] initWithObjects:
                        [NSNumber numberWithInt:category_id],name,describe,icon,
                        nil];
        resArray = [resArray arrayByAddingObject:arr];
    }
    [db close];
    return resArray;
}

+(NSArray*)selectCategoryById:(int)category_id{
    NSArray *resArray = [[NSArray alloc]init];;
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from bc_tips_category where category_id=%d",category_id];
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        int category_id = [resultset intForColumn:@"category_id"];
        NSString * name = [resultset stringForColumn:@"name"];
        NSString * describe = [resultset stringForColumn:@"describe"];
        NSString * icon = [resultset stringForColumn:@"icon"];
        
        NSArray *arr = [[NSArray alloc] initWithObjects:
                        [NSNumber numberWithInt:category_id],name,describe,icon,
                        nil];
        resArray = [resArray arrayByAddingObject:arr];
    }
    [db close];
    return resArray;
}

+(BOOL)insertCategoryDB:(int)categoryId
             CreateTime:(int)createTime
             UpdateTime:(int)updateTime
               ParentId:(int)parentId
                   name:(NSString*)name
               describe:(NSString*)describe
                   icon:(NSString*)icon{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_tips_category (category_id INTEGER PRIMARY KEY,create_time integer not null, update_time INTEGER default 0,parent_id integer default 0, name Varchar DEFAULT NULL,describe TEXT DEFAULT NULL, icon Varchar DEFAULT NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return res;
    }
    
    if (![self checkExist:categoryId]) {
        res=[db executeUpdate:@"insert into bc_tips_category (category_id, create_time, update_time, parent_id, name,describe, icon) values(?,?,?,?,?,?,?)",
             [NSNumber numberWithInt:categoryId],
             [NSNumber numberWithInt:createTime],
             [NSNumber numberWithInt:updateTime],
             [NSNumber numberWithInt:parentId],
             name,
             describe,
             icon
             ];

    }
    else{
        res=[db executeUpdate:@"update bc_tips_category set update_time=?,parent_id=?,name=?,describe=?,icon=? where category_id=?",
             [NSNumber numberWithInt:categoryId],
             [NSNumber numberWithInt:parentId],
             name,
             describe,
             icon,
             [NSNumber numberWithInt:categoryId]];
    }
    
    
    if (!res) {
        NSLog(@"数据库插入失败");
        [db close];
        return res;
    }
    [db close];
    return res;
}

+(BOOL)checkExist:(int)categoryId{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_tips_category (category_id INTEGER PRIMARY KEY,create_time integer not null, update_time INTEGER default 0,parent_id integer default 0, name Varchar DEFAULT NULL,describe TEXT DEFAULT NULL,  icon Varchar DEFAULT NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return res;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select category_id from bc_tips_category where category_id = %d", categoryId];
    
    FMResultSet *resultset=[db executeQuery:sql];
    res = NO;
    while ([resultset next]) {
        res = YES;
    }
    
    return res;

}

#pragma 返回YES则需要更新
+(BOOL)checkUpdateState:(int)categoryId
             UpdateTime:(int)updateTime{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_tips_category (category_id INTEGER PRIMARY KEY,create_time integer not null, update_time INTEGER default 0,parent_id integer default 0, name Varchar DEFAULT NULL,describe TEXT DEFAULT NULL,  icon Varchar DEFAULT NULL)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        [db close];
        return res;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select update_time from bc_tips_category where category_id = %d", categoryId];
    
    FMResultSet *resultset=[db executeQuery:sql];
    res = YES;
    while ([resultset next]) {
        int update_Time = [resultset intForColumn:@"update_time"];
        if (update_Time == updateTime) {
            res = NO;
        }
    }

    return res;
}

#pragma 检查并删除服务器上已删除类目
+(BOOL)checkDeleteCategory:(NSString*)ids{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return res;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select category_id from bc_tips_category where category_id not in (%@)", ids];
    
    FMResultSet *resultset=[db executeQuery:sql];
    res = YES;
    while ([resultset next]) {
        int categoryId = [resultset intForColumn:@"category_id"];
        sql = [NSString stringWithFormat:@"delete from bc_tips_category where category_id = %d ", categoryId];
        res=[db executeUpdate:sql];
        if (!res) {
            NSLog(@"数据库删除失败");
            [db close];
            return res;
        }
    }
    
    return res;
}


+(BOOL)checkSubscribe:(int)UserID
           categoryId:(int)categoryId
{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    NSString *sql =[NSString stringWithFormat:@"select * from bc_user where user_id = %d",UserID];
    FMResultSet *resultset=[db executeQuery:sql];
    res = NO;
    if ([resultset next]) {
//        [resultset stringForColumn:@"category_ids"];
        NSRange range= [[resultset stringForColumn:@"category_ids"] rangeOfString:[NSString stringWithFormat:@",%d,",categoryId]];
        if (range.length != 0) {
            res = YES;
        }
    }
    [db close];
    return res;
}

#pragma 插入贴士:检测该条是否存在->检测是否该条有更新->插入数据
+(BOOL)insertTipDB:(int)tipId
        CreateTime:(int)createTime
        UpdateTime:(int)updateTime
        CategoryId:(int)categoryId
             Title:(NSString*)title
           Summary:(NSString*)summary
            PicUrl:(NSString*)picUrl{
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return NO;
    }
    
    if (![DataBase checkRecordExistByID:tipId
                              FiledName:@"tip_id"
                              TableName:@"bc_tips"
                                 DBPath:UDBPATH]) {
        res=[db executeUpdate:@"insert into bc_tips (tip_id, create_time, update_time, category_id, tip_title,tip_summary, tip_pic_url,read_time) values(?,?,?,?,?,?,?,?)",
                 [NSNumber numberWithInt:tipId],
                 [NSNumber numberWithInt:createTime],
                 [NSNumber numberWithInt:updateTime],
                 [NSNumber numberWithInt:categoryId],
                 title,
                 [NSString stringWithFormat:@""],//summary 暂时不存帖子内容
                 picUrl,
                 [NSNumber numberWithInt:0]
                 ];
    }
    else{
        //存在判断需不需要更新
        if ([DataBase checkRecordNeedUpdateByID:tipId UpdateTime:updateTime FiledName:@"tip_id" TableName:@"bc_tips" DBPath:UDBPATH]) {
            //需要更新数据
            res=[db executeUpdate:@"update bc_tips set update_time=?, category_id=?,tip_title=?,tip_pic_url=? where tip_id=?",
                 [NSNumber numberWithInt:updateTime],
                 [NSNumber numberWithInt:categoryId],
                 title,
                 picUrl,
                 [NSNumber numberWithInt:tipId]];
        }
    }
    return res;
}

+(NSArray*)selectTipsByIds:(NSString*)ids{
    NSArray *resArray = [[NSArray alloc]init];;
    BOOL res;
    FMDatabase *db=[FMDatabase databaseWithPath:UDBPATH];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        [db close];
        return nil;
    }
    
    NSString *sql =[NSString stringWithFormat:@"select * from bc_tips where tip_id in (%@) order by create_time",ids];
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        int tipId = [resultset intForColumn:@"tip_id"];
        int createTime = [resultset intForColumn:@"create_time"];
        NSDate *createDate = [ACDate getDateFromTimeStamp:(long)createTime];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString * time = [dateFormatter stringFromDate:createDate];
        NSString * title = [resultset stringForColumn:@"tip_title"];
        NSString * summary = [resultset stringForColumn:@"tip_summary"];
        NSString * pic = [resultset stringForColumn:@"tip_pic_url"];
        NSArray *arr = [[NSArray alloc] initWithObjects:
                        [NSNumber numberWithInt:tipId],time,title,summary,pic,[NSNumber numberWithInt:createTime],
                        nil];
        resArray = [resArray arrayByAddingObject:arr];
    }
    [db close];
    return resArray;
}

@end
