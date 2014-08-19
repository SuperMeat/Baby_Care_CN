//
//  BaseSQL.m
//  BabyCalendar
//
//  Created by will on 14-6-10.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseSQL.h"
#import "MilestoneModel.h"
#import "AddMilestoneModel.h"
#import "VaccineModel.h"
#import "TrainModel.h"
#import "TestModel.h"
#import "NoteModel.h"
@implementation BaseSQL

/****************里程碑********************/

// 创建数据库
+(FMDatabase*)createTable_milestone
{
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if (![dataBase open]){
        NSLog(@"OPEN FAIL");
    }
    
    [dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS milestoneTable(id text long,date text,month text,title text,content text,photo_path text,completed bool)"];
    [dataBase close];
    
    return dataBase;
}


// ２.查询数据
+ (NSMutableArray*)queryData_milestone
{
    NSMutableArray* datas = [NSMutableArray array];
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM milestoneTable ORDER BY date"];
        while ([rs next]){
            MilestoneModel* model = [[MilestoneModel alloc]init];
            model.id = [rs stringForColumn:@"id"];
            model.date = [rs stringForColumn:@"date"];
            model.month = [rs stringForColumn:@"month"];
            model.title = [rs stringForColumn:@"title"];
            model.content = [rs stringForColumn:@"content"];
            model.photo_path = [rs stringForColumn:@"photo_path"];
            model.completed = [NSNumber numberWithBool:[rs boolForColumn:@"completed"]];
            [datas addObject:model];
        }
        [rs close];
        [dataBase close];
    }
    return datas;
}


// ２.查询数据
+ (NSMutableArray*)queryData__milestone:(NSString*)date
{
    NSMutableArray* datas = [NSMutableArray array];
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM milestoneTable WHERE date=?",date];
        while ([rs next]){
            MilestoneModel* model = [[MilestoneModel alloc]init];
            model.id = [rs stringForColumn:@"id"];
            model.date = [rs stringForColumn:@"date"];
            model.month = [rs stringForColumn:@"month"];
            model.title = [rs stringForColumn:@"title"];
            model.content = [rs stringForColumn:@"content"];
            model.photo_path = [rs stringForColumn:@"photo_path"];
            model.completed = [NSNumber numberWithBool:[rs boolForColumn:@"completed"]];
            
            [datas addObject:model];
        }
        [rs close];
        [dataBase close];
    }
    return datas;
}
// 插入数据
+(BOOL)insertData_milestone:(MilestoneModel*)model
{
   
    //插入数据库
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    [dataBase open];
    BOOL success = [dataBase executeUpdate:@"INSERT INTO milestoneTable (id,date,month,title,content,photo_path,completed) VALUES (?,?,?,?,?,?,?)",
    model.id,model.date,model.month,model.title,model.content,model.photo_path,model.completed];
    [dataBase close];
    
    return success;
}
// 更新
+ (BOOL)updateData_milestone:(MilestoneModel* )model
{
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    [dataBase open];
    BOOL success = [dataBase executeUpdate:@"UPDATE milestoneTable SET title = ?,date = ?,content = ?,photo_path = ?,completed = ? WHERE id = ? ",model.title,model.date,model.content,model.photo_path,model.completed,model.id];
    [dataBase close];
    return success;
}
//// 保存照片到数据库
//+ (BOOL)update_photo_milestone:(NSString*)title wtihPhoto_path:(NSString*)photo_path
//{
//    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
//    [dataBase open];
//    BOOL success = [dataBase executeUpdate:@"UPDATE milestoneTable SET photo_path = ? WHERE title = ? ",photo_path,title];
//    [dataBase close];
//    if (success) {
//        return YES;
//    }
//    
//    return NO;
//    
//}
//// 保存照片到本地和数据库
//+ (void)saveImage_local_SQL:(NSData *)topImageData withTitle:(NSString*)title
//{
//    // 保存照片到本地
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString* timeStr = [formatter stringFromDate:[NSDate date]];
//    
//    NSString *photoName = [NSString stringWithFormat:@"%@.jpg",timeStr];
//    
//    NSString *photo_path=[BaseMethod dataFilePath:photoName];
//    NSLog(@"PATH : %@", photo_path);
//    
//    //NSData* data = UIImageJPEGRepresentation([UIImage imageNamed:@"3"], 0.5);
//    BOOL sussess = [topImageData writeToFile:photo_path atomically:YES];
//    if (sussess) {
//        NSLog(@"保存照片成功");
//        // 保存图片名称到数据库
//        [BaseSQL update_photo_milestone:title wtihPhoto_path:photo_path];
//    }
//    
//}

/**************疫苗**************/

// 创建数据库
+(FMDatabase*)createTable_vaccine
{
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if (![dataBase open]){
        NSLog(@"OPEN FAIL");
    }
    
    [dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS vaccineTable(id int,vaccine text,illness text,times text,completedDate text,willDate text,inplan bool,completed bool)"];
    [dataBase close];
    
    return dataBase;
}


// ２.查询数据
+ (NSMutableArray*)queryData_vaccine
{
    NSMutableArray* datas = [NSMutableArray array];
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM vaccineTable ORDER BY completedDate DESC"];
        while ([rs next]){
            VaccineModel* model = [[VaccineModel alloc]init];
            model.vaccine = [rs stringForColumn:@"vaccine"];
            model.illness = [rs stringForColumn:@"illness"];
            model.times = [rs stringForColumn:@"times"];
            model.completedDate = [rs stringForColumn:@"completedDate"];
            model.willDate = [rs stringForColumn:@"willDate"];
            model.inplan = [NSNumber numberWithBool:[rs boolForColumn:@"inplan"]];
            model.completed = [NSNumber numberWithBool:[rs boolForColumn:@"completed"]];
            model.id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            [datas addObject:model];
        }
        [rs close];
        [dataBase close];
    }
    return datas;
}
// ２.查询数据
+ (NSMutableArray*)queryData_vaccine:(NSString*)date
{
    NSMutableArray* datas = [NSMutableArray array];
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM vaccineTable WHERE completedDate =?",date];
        while ([rs next]){
            VaccineModel* model = [[VaccineModel alloc]init];
            model.vaccine = [rs stringForColumn:@"vaccine"];
            model.illness = [rs stringForColumn:@"illness"];
            model.times = [rs stringForColumn:@"times"];
            model.completedDate = [rs stringForColumn:@"completedDate"];
            model.willDate = [rs stringForColumn:@"willDate"];
            model.inplan = [NSNumber numberWithBool:[rs boolForColumn:@"inplan"]];
            model.completed = [NSNumber numberWithBool:[rs boolForColumn:@"completed"]];
            model.id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            [datas addObject:model];
        }
        [rs close];
        [dataBase close];
    }
    return datas;
}
// 插入数据
+(BOOL)insertData_vaccine:(VaccineModel*)model
{
    
    //插入数据库
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    [dataBase open];
    BOOL success = [dataBase executeUpdate:@"INSERT INTO vaccineTable (id,vaccine,illness,times,completedDate,willDate,inplan,completed) VALUES (?,?,?,?,?,?,?,?)",model.id,
                    model.vaccine,model.illness,model.times,model.completedDate,model.willDate,model.inplan,model.completed];
    [dataBase close];
    
    return success;
}
//删除行
+ (BOOL)deleteData_vaccine:(VaccineModel*)model
{
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    [dataBase open];
    BOOL success = [dataBase executeUpdate:@"DELETE FROM vaccineTable WHERE id = ?",model.id];
    [dataBase close];
    
    return success;
}
// 更新
+ (BOOL)updateData_vaccine:(VaccineModel*)model
{
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    [dataBase open];
    BOOL success = [dataBase executeUpdate:@"UPDATE vaccineTable SET completedDate = ?,completed = ? WHERE id = ? ",model.completedDate,model.completed,model.id];
    [dataBase close];
    return success;
}
// 查询
+ (BOOL)queryData_vaccine_withModel:(VaccineModel*)model
{
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if ([dataBase open]) {
        
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM vaccineTable WHERE vaccine=?",model.vaccine];
        while ([rs next]){
            [rs close];
            [dataBase close];
            return YES;
        }
        [rs close];
        [dataBase close];
    }
    return NO;
}

/**************训练**************/
// 创建数据库
+(FMDatabase*)createTable_train
{
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if (![dataBase open]){
        NSLog(@"OPEN FAIL");
    }
    
    [dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS train_table(id int,type text,title text,content text,trained bool,date text,month int)"];
    [dataBase close];
    
    return dataBase;
}
// 插入数据
+(BOOL)insertData_train:(TrainModel*)model
{
    //插入数据库
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    [dataBase open];
    BOOL success = [dataBase executeUpdate:@"INSERT INTO train_table (id,type,title,content,date,trained,month) VALUES (?,?,?,?,?,?,?)",model.id,model.type,model.title,model.content,model.date,model.trained,model.month];
    [dataBase close];
    
    return success;
}

// ２.查询数据
+ (NSMutableArray*)queryData_train
{
    NSMutableArray* datas = [NSMutableArray array];
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if ([dataBase open]) {
//        int index = 0;
        NSString* string = @"SELECT * FROM train_table";
        FMResultSet *rs = [dataBase executeQuery:string];
        while ([rs next]){
//            index++;
            TrainModel* model = [[TrainModel alloc]init];
            model.id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            model.type = [rs stringForColumn:@"type"];
            model.title = [rs stringForColumn:@"title"];
            model.content = [rs stringForColumn:@"content"];
            model.trained = [NSNumber numberWithBool:[rs boolForColumn:@"trained"]];
            model.date = [rs stringForColumn:@"date"];
            [datas addObject:model];
        }
        [rs close];
        [dataBase close];
    }
    return datas;
}
+ (NSMutableArray*)queryData_train:(NSString*)date
{
    NSMutableArray* datas = [NSMutableArray array];
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if ([dataBase open]) {
        
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM train_table WHERE date=?",date];
        while ([rs next]){
            TrainModel* model = [[TrainModel alloc]init];
            model.id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            model.type = [rs stringForColumn:@"type"];
            model.title = [rs stringForColumn:@"title"];
            model.content = [rs stringForColumn:@"content"];
            model.trained = [NSNumber numberWithBool:[rs boolForColumn:@"trained"]];
            model.date = [rs stringForColumn:@"date"];
            [datas addObject:model];
        }
        [rs close];
        [dataBase close];
    }
    return datas;
}
// ２.查询数据
+ (NSMutableArray*)queryData_train:(NSString*)type withTrained:(NSNumber*)trained
{
    NSMutableArray* datas = [NSMutableArray array];
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if ([dataBase open]) {
//        int index = 0;
        NSString* string = [NSString stringWithFormat:@"SELECT * FROM train_table WHERE type='%@' AND trained='%@'",type,trained];
        
        FMResultSet *rs = [dataBase executeQuery:string];
        while ([rs next]){
//            index++;
            TrainModel* model = [[TrainModel alloc]init];
            model.id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            model.type = [rs stringForColumn:@"type"];
            model.title = [rs stringForColumn:@"title"];
            model.content = [rs stringForColumn:@"content"];
            model.trained = [NSNumber numberWithBool:[rs boolForColumn:@"trained"]];
            model.date = [rs stringForColumn:@"date"];
            [datas addObject:model];
        }
        [rs close];
        [dataBase close];
    }
    return datas;
}
// 更新
+ (BOOL)updateData_train:(TrainModel*)model
{
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    [dataBase open];
    BOOL success = [dataBase executeUpdate:@"UPDATE train_table SET date=?,trained=? WHERE id = ? ",model.date,model.trained,model.id];
    [dataBase close];
    return success;
}

/**************测评**************/
// 创建数据库
+(FMDatabase*)createTable_test
{
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if (![dataBase open]){
        NSLog(@"OPEN FAIL");
    }
    
    [dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS test_table(date text,month int,completed bool,score int,knowledge_score int,active_score int,language_score int,society_score int)"];
    [dataBase close];
    
    return dataBase;
}
// 插入数据
+(BOOL)insertData_test:(TestModel*)model
{
    
    //插入数据库
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    [dataBase open];
    BOOL success = [dataBase executeUpdate:@"INSERT INTO test_table (date,month,completed,score,knowledge_score,active_score,language_score,society_score) VALUES (?,?,?,?,?,?,?,?)",model.date,model.month,model.completed,model.score,model.knowledge_score,model.active_score,model.language_score,model.society_score];
    [dataBase close];
    
    return success;
}

// ２.查询数据
+ (NSMutableArray*)queryData_test
{
    NSMutableArray* datas = [NSMutableArray array];
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if ([dataBase open]) {
        NSString* string = @"SELECT * FROM test_table";
        FMResultSet *rs = [dataBase executeQuery:string];
        while ([rs next]){
            TestModel* model = [[TestModel alloc] init];
            model.date = [rs stringForColumn:@"date"];
            model.month = [NSNumber numberWithInt:[rs intForColumn:@"month"]];
            model.completed = [NSNumber numberWithBool:[rs boolForColumn:@"completed"]];
            model.score = [NSNumber numberWithInt:[rs intForColumn:@"score"]];
            model.knowledge_score = [NSNumber numberWithInt:[rs intForColumn:@"knowledge_score"]];
            model.active_score = [NSNumber numberWithInt:[rs intForColumn:@"active_score"]];
            model.language_score = [NSNumber numberWithInt:[rs intForColumn:@"language_score"]];
            model.society_score = [NSNumber numberWithInt:[rs intForColumn:@"society_score"]];
            
            [datas addObject:model];
        }
        [rs close];
        [dataBase close];
    }
    return datas;
}
+ (NSMutableArray*)queryData_test:(NSString*)date
{
    NSMutableArray* datas = [NSMutableArray array];
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if ([dataBase open]) {
   
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM test_table WHERE date=?",date];
        while ([rs next]){
            TestModel* model = [[TestModel alloc] init];
            model.date = [rs stringForColumn:@"date"];
            model.month = [NSNumber numberWithInt:[rs intForColumn:@"month"]];
            model.completed = [NSNumber numberWithBool:[rs boolForColumn:@"completed"]];
            model.score = [NSNumber numberWithInt:[rs intForColumn:@"score"]];
            model.knowledge_score = [NSNumber numberWithInt:[rs intForColumn:@"knowledge_score"]];
            model.active_score = [NSNumber numberWithInt:[rs intForColumn:@"active_score"]];
            model.language_score = [NSNumber numberWithInt:[rs intForColumn:@"language_score"]];
            model.society_score = [NSNumber numberWithInt:[rs intForColumn:@"society_score"]];
            
            [datas addObject:model];
        }
        [rs close];
        [dataBase close];
    }
    return datas;
}
// 更新
+ (BOOL)updateData_test:(TestModel*)model
{
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    [dataBase open];
    BOOL success = [dataBase executeUpdate:@"UPDATE test_table SET date=?,completed=?,score=?,knowledge_score=?,active_score=?,language_score=?,society_score=? WHERE month = ? ",model.date,model.completed,model.score,model.knowledge_score,model.active_score,model.language_score,model.society_score,model.month];
    [dataBase close];
    return success;
}

// 初始化测评
+ (void)addDatas_test
{
   
    
    [BaseSQL createTable_test];
    NSArray* tests = [BaseSQL queryData_test];
    if (tests.count == 0) {
        for (int index = 0; index < [BaseMethod month_test]; index++) {
            TestModel* model = [[TestModel alloc] init];
            model.date = @"";
            model.month = [NSNumber numberWithInt:index+1];
            model.completed = [NSNumber numberWithBool:NO];
            model.score = [NSNumber numberWithInt:0];
            model.knowledge_score = [NSNumber numberWithInt:0];
            model.active_score = [NSNumber numberWithInt:0];
            model.language_score = [NSNumber numberWithInt:0];
            model.society_score = [NSNumber numberWithInt:0];
            [BaseSQL insertData_test:model];
        }
    }
}

/*
 @property(nonatomic,copy)NSString* content;
 @property(nonatomic,copy)NSString* date;
 @property(nonatomic,retain)NSNumber* mood;
 @property(nonatomic,copy)NSString* photo;
 */

/**************日记**************/
// 创建数据库
+(FMDatabase*)createTable_note
{
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if (![dataBase open]){
        NSLog(@"OPEN FAIL");
    }
    
    [dataBase executeUpdate:@"CREATE TABLE IF NOT EXISTS note_table(id int,date text,content text,mood int,photo text)"];
    [dataBase close];
    
    return dataBase;
}
// 插入数据
+(BOOL)insertData_note:(NoteModel*)model
{
    
    //插入数据库
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    [dataBase open];
    BOOL success = [dataBase executeUpdate:@"INSERT INTO note_table (id,date,content,mood,photo) VALUES (?,?,?,?,?)",model.id,model.date,model.content,model.mood,model.photo];
    [dataBase close];
    
    return success;
}

// ２.查询数据
+ (NSMutableArray*)queryData_note
{
    NSMutableArray* datas = [NSMutableArray array];
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if ([dataBase open]) {
        NSString* string = @"SELECT * FROM note_table ORDER BY date";
        FMResultSet *rs = [dataBase executeQuery:string];
        while ([rs next]){
            NoteModel* model = [[NoteModel alloc] init];
            model.id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            model.date = [rs stringForColumn:@"date"];
            model.content = [rs stringForColumn:@"content"];
            model.mood = [NSNumber numberWithInt:[rs intForColumn:@"mood"]];
            model.photo = [rs stringForColumn:@"photo"];
            
            [datas addObject:model];
        }
        [rs close];
        [dataBase close];
    }
    return datas;
}
// 根据日期查询数据
+ (NSMutableArray*)queryData_note_withDate:(NSString*)date
{
    NSMutableArray* datas = [NSMutableArray array];
    
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    if ([dataBase open]) {

        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM note_table WHERE date=?",date];
        while ([rs next]){
            NoteModel* model = [[NoteModel alloc] init];
            model.id = [NSNumber numberWithInt:[rs intForColumn:@"id"]];
            model.date = [rs stringForColumn:@"date"];
            model.content = [rs stringForColumn:@"content"];
            model.mood = [NSNumber numberWithInt:[rs intForColumn:@"mood"]];
            model.photo = [rs stringForColumn:@"photo"];
            
            [datas addObject:model];
        }
        [rs close];
        [dataBase close];
    }
    return datas;
}

// 删除所有行
+ (BOOL)delete_noteTable
{
    //插入数据库
    FMDatabase* dataBase = [FMDatabase databaseWithPath:[BaseMethod getSQLPath]];
    [dataBase open];
    BOOL success = [dataBase executeUpdate:@"DELETE FROM note_table"];
    [dataBase close];
    
    return success;
}

@end
