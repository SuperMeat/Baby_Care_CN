//
//  BaseSQL.h
//  BabyCalendar
//
//  Created by will on 14-6-10.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VaccineModel;
@class TrainModel;
@class TestModel;
@class NoteModel;
@class MilestoneModel;
@interface BaseSQL : NSObject

/** ADD by cwb **/

//查询近5日未接种疫苗
+(NSMutableArray*)queryData_vaccine_recent;
 


/****************里程碑********************/

// 创建数据库
+(FMDatabase*)createTable_milestone;
// 查询数据
+(NSMutableArray*)queryData_milestone;
+(NSMutableDictionary*)queryData_milesDic;
// 根据日期查询数据
+ (NSMutableArray*)queryData__milestone:(NSString*)date;
// 插入数据
+(BOOL)insertData_milestone:(MilestoneModel*)model;
// 更新
+ (BOOL)updateData_milestone:(MilestoneModel* )model;
// 保存照片到数据库
//+ (BOOL)update_photo_milestone:(NSString*)title wtihPhoto_path:(NSString*)photo_path;
// 保存照片到本地和数据库
//+ (void)saveImage_local_SQL:(NSData *)topImageData withTitle:(NSString*)title;


/**************疫苗**************/

// 创建数据库
+(FMDatabase*)createTable_vaccine;
// ２.查询数据
+ (NSMutableArray*)queryData_vaccine;
+ (NSMutableDictionary*)queryData_vaccineDic;
+ (NSMutableArray*)queryData_vaccine:(NSString*)date;
+ (NSMutableArray*)queryData_vaccinebyvaccinename:(NSString*)vaccine andTimes:(NSString*)times;
// 查询
+ (BOOL)queryData_vaccine_withModel:(VaccineModel*)model;
// 插入数据
+(BOOL)insertData_vaccine:(VaccineModel*)model;
//删除行
+ (BOOL)deleteData_vaccine:(VaccineModel*)model;
// 更新
+ (BOOL)updateData_vaccine:(VaccineModel*)model;
// 更新特殊情况
+ (BOOL)updateData_vaccineSpecial:(VaccineModel*)model;

/**************训练**************/
// 创建数据库
+(FMDatabase*)createTable_train;
// 插入数据
+(BOOL)insertData_train:(TrainModel*)model;
+ (NSMutableArray*)queryData_train;
+ (NSMutableDictionary*)queryData_trainDic;

// ２.查询数据
+ (NSMutableArray*)queryData_train:(NSString*)type withTrained:(NSNumber*)trained;
+ (NSMutableArray*)queryData_train:(NSString*)date;
// 更新
+ (BOOL)updateData_train:(TrainModel*)model;

/**************测评**************/
// 创建数据库
+(FMDatabase*)createTable_test;
// 插入数据
+(BOOL)insertData_test:(TestModel*)model;
// ２.查询数据
+ (NSMutableArray*)queryData_test;
+ (NSMutableDictionary*)queryData_testDic;
+ (NSMutableArray*)queryData_test:(NSString*)date;
// 更新
+ (BOOL)updateData_test:(TestModel*)model;
// 初始化测评
+ (void)addDatas_test;
//返回:某月份是否有完成评测
+ (BOOL)isFinishTestWithMonth:(int)month;
/**************日记**************/
// 创建数据库
+(FMDatabase*)createTable_note;
// 插入数据
+(BOOL)insertData_note:(NoteModel*)model;

// ２.查询数据
+ (NSMutableArray*)queryData_note;
+ (NSMutableDictionary*)queryData_noteDic;
// 根据日期查询数据
+ (NSMutableArray*)queryData_note_withDate:(NSString*)date;
// 删除所有行
+ (BOOL)delete_noteTable;
// 进3日内是否有日志
+(BOOL)isNoteRecent;
@end
