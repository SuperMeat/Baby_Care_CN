//
//  BabyDataDB.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-2-27.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BabyDataDB : NSObject
+(id)babyinfoDB;

/**
 *  新增宝宝信息
 *
 *  @param user_id               服务器返回用户ID唯一标识
 *  @param baby_id               服务器返回宝宝ID
 *  @param nickname              宝宝昵称
 *  @param birthday              出生年月日
 *  @param tall                  身高
 *  @param weight                体重
 *  @param hc                    头围
 *  @param sex                   性别
 *  @param headphoto             头像
 *  @param relationship          关系
 *  @param relationship_nickname 关系昵称
 *  @param permission            权限
 *  @param create_time           创建时间
 *  @param update_time           更新时间
 *
 *  @return 创建成功TRUE失败FALSE
 */
+(BOOL)createNewBabyInfo:(int)user_id
                  BabyId:(int)baby_id
                Nickname:(NSString*)nickname
                Birthday:(long)birthday
                     Sex:(int)sex
               HeadPhoto:(NSString*)headphoto
            RelationShip:(NSString*)relationship
    RelationShipNickName:(NSString*)relationship_nickname
              Permission:(int)permission
              CreateTime:(long)create_time
              UpdateTime:(long)update_time;

/**
 *  提取宝宝列表
 *
 *  @param user_id 用户ID
 *
 *  @return 宝宝信息组成的数组
 */
-(NSArray*)selectBabyListByUserId:(int)user_id;

/**
 *  提取宝宝信息
 *
 *  @param baby_id 宝宝唯一ID
 *
 *  @return 宝宝信息数字字典
 */
-(NSDictionary*)selectBabyInfoByBabyId:(int)baby_id;

/**
 *  更新宝宝昵称
 *
 *  @param baby_id 宝宝ID
 *
 *  @return 更新成功标识
 */
-(BOOL)updateBabyInfoName:(NSString*)newNickname BabyId:(int)baby_id;

-(BOOL)updateBabyBirth:(long)birth BabyId:(int)baby_id;

-(BOOL)updateBabySex:(int)sex BabyId:(int)baby_id;

-(BOOL)updateBabyIcon:(NSString*)icon BabyId:(int)baby_id;

-(BOOL)updateBabyInfoUpdateTime:(long)update_time BabyId:(int)baby_id;

/**
 *  新增生理曲线
 *
 *  @param create_time 服务器返回创建实际爱你
 *  @param update_time 服务器更新时间
 *  @param type        曲线类型
 *  @param value       值
 *
 *  @return 插入成功True失败false
 */
-(BOOL)insertBabyPhysiology:(long)create_time UpdateTime:(long)update_time
                       MeasureTime:(long)measure_time Type:(int)type Value:(double)value;
-(BOOL)updateBabyPhysiology:(double)value ByCreateTime:(long)create_time andType:(int)type;
-(NSArray*)selectBabyPhysiologyList:(int)type;
-(BOOL)deleteBabyPhysiologyByType:(int)type andCreateTime:(long)create_time;

/**
 *  获取曲线模板数据
 *
 *  @param type 曲线类型(身高,体重,头围...)
 *  @param sex  性别
 *
 *  @return 标准值组成的数组
 */
-(NSArray*)selectWFAByType:(int)type andSex:(int)sex;

@end
