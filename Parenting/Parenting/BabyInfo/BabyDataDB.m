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

+(BOOL)createNewBabyInfo:(int)user_id
                  BabyId:(int)baby_id
                Nickname:(NSString *)nickname
                Birthday:(long)birthday
                     Sex:(int)sex
               HeadPhoto:(NSString *)headphoto
            RelationShip:(NSString *)relationship
    RelationShipNickName:(NSString *)relationship_nickname
              Permission:(int)permission
              CreateTime:(long)create_time
              UpdateTime:(long)update_time
{
    BOOL res;
    [[NSUserDefaults standardUserDefaults] setInteger:baby_id forKey:@"cur_babyid"];
    
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id,baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby (baby_id  INTEGER PRIMARY KEY NOT NULL, user_id INTEGER NOT NULL, nickname Varchar DEFAULT NULL, birth Timestamp DEFAULT NULL,tall Varchar DEFAULT NULL,weight Varchar  DEFAULT NULL,hc Varchar DEFAULT NULL,sex Varchar DEFAULT NULL,head Varchar DEFAULT NULL,relationship Varchar DEFAULT NULL,relationship_nickname Varchar DEFAULT NULL, permission integer default 0, create_time integer default 0, update_time integer default 0)"];
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    
    res=[db executeUpdate:@"insert into bc_baby(baby_id,user_id,nickname, birth,sex,head,relationship,relationship_nickname,permission,create_time,update_time) values(?,?,?,?,?,?,?,?,?,?,?)",[NSNumber numberWithInt:user_id],
        [NSNumber numberWithInt:baby_id],
        nickname,
        [NSNumber numberWithLong:birthday],
        [NSNumber numberWithInt:sex],
        headphoto,
        relationship,
        relationship_nickname,
        [NSNumber numberWithInt:permission],
        [NSNumber numberWithLong:create_time],
        [NSNumber numberWithLong:update_time]
    ];
    
    if (!res)
    {
        NSLog(@"插入失败");
        return res;
    }

    [db close];
    return res;
}

-(NSArray*)selectBabyListByUserId:(int)user_id
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id,baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from bc_baby where user_id = %d", user_id];
    
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        NSDictionary *dic = [self selectBabyInfoByBabyId:[resultset intForColumn:@"baby_id"]];
        if (dic != nil) {
            [array addObject:dic];
        }
    }
    
    return array;

}

-(NSDictionary*)selectBabyInfoByBabyId:(int)baby_id
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id,baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from bc_baby where baby_id = %d", baby_id];
    
    FMResultSet *resultset=[db executeQuery:sql];
    if ([resultset next])
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:11];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"user_id"]] forKey:@"user_id"];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@" baby_id"]] forKey:@"baby_id"];
        [dic setValue:[resultset stringForColumn:@"nickname"] forKey:@"nickname"];
        [dic setValue:[NSNumber numberWithLong:[resultset longForColumn:@"birth"]] forKey:@"birth"];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"sex"]] forKey:@"sex"];
        [dic setValue:[resultset stringForColumn:@"icon"] forKey:@"icon"];
        [dic setValue:[resultset stringForColumn:@"relationship"] forKey:@"relationship"];
        [dic setValue:[resultset stringForColumn:@"relationship_nickname"] forKey:@"relationship_nickname"];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"permission"]] forKey:@"permission"];
        [dic setValue:[NSNumber numberWithLong:[resultset longForColumn:@"create_time"]] forKey:@"create_time"];
        [dic setValue:[NSNumber numberWithLong:[resultset longForColumn:@"update_time"]] forKey:@"update_time"];
    }
    
    return nil;

}

-(BOOL)updateBabyInfoName:(NSString*)newNickname BabyId:(int)baby_id
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"update bc_baby set nickname= ? where baby_id=?",newNickname, [NSNumber numberWithInt:baby_id]];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)updateBabyBirth:(long)birth BabyId:(int)baby_id
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"update bc_baby set birth= ? where baby_id=?",[NSNumber numberWithLong:birth], [NSNumber numberWithInt:baby_id]];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)updateBabySex:(int)sex BabyId:(int)baby_id
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"update bc_baby set sex= ? where baby_id=?",[NSNumber numberWithInt:sex], [NSNumber numberWithInt:baby_id]];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)updateBabyIcon:(NSString*)icon BabyId:(int)baby_id
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"update bc_baby set icon= ? where baby_id=?",icon, [NSNumber numberWithInt:baby_id]];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)updateBabyInfoUpdateTime:(long)update_time BabyId:(int)baby_id
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"update bc_baby set update_time= ? where baby_id=?",[NSNumber numberWithLong:update_time], [NSNumber numberWithInt:baby_id]];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

-(BOOL)insertBabyPhysiology:(long)create_time
                 UpdateTime:(long)update_time
                MeasureTime:(long)measure_time
                       Type:(int)type
                      Value:(double)value
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];
    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    res=[db executeUpdate:@"CREATE TABLE if not exists bc_baby_physiology (create_time integer NOT NULL PRIMARY KEY, update_time integer DEFAULT 0, type integer defalut 0, measure_time integer default 0, value double default 0)"];
    
    if (!res) {
        NSLog(@"表格创建失败");
        return res;
    }
    
    res=[db executeUpdate:@"insert into bc_baby_physiology values(?,?,?,?,?)",
        [NSNumber numberWithLong:create_time],
        [NSNumber numberWithLong:update_time],
        [NSNumber numberWithLong:measure_time],
        [NSNumber numberWithInt:type],
        [NSNumber numberWithDouble:value]
         ];
    
    if (!res) {
        NSLog(@"%@",NSHomeDirectory());
        NSLog(@"插入失败");
        return res;
    }
    [db close];
    
    return res;

}

-(BOOL)updateBabyPhysiology:(double)value ByCreateTime:(long)create_time andType:(int)type
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];

    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"update bc_baby_physiology set value= ? where create_time=? and type = ?",[NSNumber numberWithDouble:value], [NSNumber numberWithLong:create_time],[NSNumber numberWithInt:type]];
    if (!res) {
        NSLog(@"更新失败");
        return res;
    }
    [db close];
    return res;
}

-(NSArray*)selectBabyPhysiologyList:(int)type
{
    BOOL res;
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:0];
    
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];

    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    NSString *sql =[NSString stringWithFormat:@"select * from bc_baby_physiology where type = %d",type];
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:11];
        [dic setValue:[NSNumber numberWithInt:[resultset longForColumn:@"create_time"]] forKey:@"create_time"];
        [dic setValue:[NSNumber numberWithInt:[resultset longForColumn:@"update_time"]] forKey:@"update_time"];
        [dic setValue:[NSNumber numberWithInt:[resultset intForColumn:@"type"]] forKey:@"type"];
        [dic setValue:[NSNumber numberWithDouble:[resultset doubleForColumn:@"value"]] forKey:@"value"];
        [dic setValue:[NSNumber numberWithLong:[resultset longForColumn:@"measure_time"]] forKey:@"measure_time"];
        [array addObject:dic];
    }
    
    return array;
}

-(BOOL)deleteBabyPhysiologyByType:(int)type andCreateTime:(long)create_time
{
    BOOL res;
    int user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_userid"] integerValue];
    int baby_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cur_babyid"] integerValue];
    FMDatabase *db=[FMDatabase databaseWithPath:USERDBPATH(user_id, baby_id)];

    res=[db open];
    if (!res) {
        NSLog(@"数据库打开失败");
        return res;
    }
    
    res=[db executeUpdate:@"delete bc_baby_physiology where create_time=? and type = ?", [NSNumber numberWithLong:create_time],[NSNumber numberWithInt:type]];
    if (!res) {
        NSLog(@"删除失败");
        return res;
    }
    [db close];
    return res;
}

-(NSArray*)selectWFAByType:(int)type andSex:(int)sex
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
    NSString *sql =[NSString stringWithFormat:@"select * from bc_wfa where type = %d and sex = %d",type, sex];
    FMResultSet *resultset=[db executeQuery:sql];
    while ([resultset next]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:11];
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
