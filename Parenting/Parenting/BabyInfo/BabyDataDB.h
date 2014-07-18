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

/**
 *  修改宝宝出生日期
 *
 *  @param birth   出生时间戳
 *  @param baby_id 宝宝唯一ID
 *
 *  @return true or false
 */
-(BOOL)updateBabyBirth:(long)birth BabyId:(int)baby_id;

/**
 *  更改性别
 *
 *  @param sex     性别
 *  @param baby_id 宝宝id
 *
 *  @return
 */
-(BOOL)updateBabySex:(int)sex BabyId:(int)baby_id;

/**
 *  更改宝宝照片
 *
 *  @param icon    照片名字
 *  @param baby_id 宝宝id
 *
 *  @return
 */
-(BOOL)updateBabyIcon:(NSString*)icon BabyId:(int)baby_id;

/**
 *  更新同步时间
 *
 *  @param update_time 同步时间时间戳,服务器返回
 *  @param baby_id
 *
 *  @return
 */
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
-(BOOL)insertBabyPhysiology:(long)create_time
                 UpdateTime:(long)update_time
                MeasureTime:(long)measure_time
                       Type:(int)type
                      Value:(double)value;
/**
 *  更新生理曲线值
 *
 *  @param value       值
 *  @param create_time 创建时间
 *  @param type        曲线类型
 *
 *  @return
 */
-(BOOL)updateBabyPhysiology:(double)value ByCreateTime:(long)create_time andType:(int)type;

/**
 *  获取曲线列表
 *
 *  @param type 曲线类型
 *
 *  @return
 */
-(NSArray*)selectBabyPhysiologyList:(int)type;

/**
 *  删除某一条曲线记录
 *
 *  @param type        曲线类型
 *  @param create_time 创建时间
 *
 *  @return 
 */
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

/**
 *  插入一条新的洗澡记录
 *
 *  @param create_time 创建时间
 *  @param update_time 更新时间
 *  @param start_time  洗澡时间
 *  @param month       月
 *  @param week        周
 *  @param weekday     周几
 *  @param duration    时长
 *  @param deal_way    洗澡方式
 *  @param remark      备注
 *  @param more_info   备用字段
 */
-(BOOL)insertBabyBathRecord:(long)create_time
                 UpdateTime:(long)update_time
                  StartTime:(NSDate*)start_time
                      Month:(int)month
                       Week:(int)week
                    Weekday:(int)weekday
                   Duration:(int)duration
                   BathType:(NSString*)bath_type
                     Remark:(NSString*)remark
                   MoreInfo:(NSString*)more_info;

/**
 *  更新洗澡记录
 *
 *  @param starttime  洗澡时间
 *  @param month      月
 *  @param week       周
 *  @param weekday    周几
 *  @param duration   时长
 *  @param bath_type  洗澡方式
 *  @param remark     备注
 *  @param more_info  扩展字段
 *  @param createtime 创建时间
 *
 *  @return 更新成功trur失败false
 */
-(BOOL)updateBathRecord:(NSDate*)starttime
                  Month:(int)month
                   Week:(int)week
                WeekDay:(int)weekday
               Duration:(int)duration
               BathType:(NSString*)bath_type
                 Remark:(NSString*)remark
               MoreInfo:(NSString*)more_info
             CreateTime:(long)createtime;

/**
 *  新增尿布信息
 *
 *  @param create_time 创建时间
 *  @param update_time 同步时间
 *  @param start_time  开始时间
 *  @param month       月
 *  @param week        周
 *  @param weekday     周几
 *  @param status      尿布状态(干,湿,脏)
 *  @param color       尿布颜色
 *  @param hard        硬度
 *  @param remark      备注
 *  @param more_info   备用字段
 *
 *  @return
 */
-(BOOL)insertBabyDiaperRecord:(long)create_time
                   UpdateTime:(long)update_time
                    StartTime:(NSDate *)start_time
                        Month:(int)month
                         Week:(int)week
                      Weekday:(int)weekday
                       Status:(NSString *)status
                       Amount:(NSString *)amount
                        Color:(NSString *)color
                         Hard:(NSString *)hard
                       Remark:(NSString *)remark
                     MoreInfo:(NSString *)more_info;

/**
 *  更新尿布记录
 *
 *  @param starttime  开始时间
 *  @param month      月
 *  @param week       周
 *  @param weekday    周几
 *  @param status     尿布状态
 *  @param color      颜色
 *  @param hard       硬度
 *  @param remark     备注
 *  @param more_info  备用字段
 *  @param createtime 创建时间
 *
 *  @return
 */
-(BOOL)updateDiaperRecord:(NSDate*)starttime
                    Month:(int)month
                     Week:(int)week
                  WeekDay:(int)weekday
                   Status:(NSString *)status
                   Amount:(NSString *)amount
                    Color:(NSString *)color
                     Hard:(NSString *)hard
                   Remark:(NSString *)remark
                 MoreInfo:(NSString*)more_info
               CreateTime:(long)createtime;

/**
 *  新增喂食记录
 *
 *  @param create_time 创建时间
 *  @param update_time 更新时间
 *  @param start_time  开始时间
 *  @param month       月
 *  @param week        周
 *  @param weekday     周几
 *  @param duration    持续时间
 *  @param oz          量
 *  @param feed_type   喂食方式
 *  @param food_type   食物类型
 *  @param remark      备注
 *  @param more_info
 *
 *  @return
 */
-(BOOL)insertBabyFeedRecord:(long)create_time
                 UpdateTime:(long)update_time
                  StartTime:(NSDate *)start_time
                      Month:(int)month
                       Week:(int)week
                    Weekday:(int)weekday
                   Duration:(int)duration
                         Oz:(NSString *)oz
                   FeedType:(NSString *)feed_type
                   FoodType:(NSString *)food_type
                     Remark:(NSString *)remark
                   MoreInfo:(NSString *)more_info;

/**
 *  更新喂食记录
 *
 *  @param starttime  开始时间
 *  @param month      月
 *  @param week       周
 *  @param weekday    周几
 *  @param duration   持续时间
 *  @param oz         量
 *  @param feed_type  喂食方式
 *  @param food_type  食物类型
 *  @param remark     备注
 *  @param more_info
 *  @param createtime 创建时间
 *
 *  @return
 */
-(BOOL)updateFeedRecord:(NSDate*)starttime
                  Month:(int)month
                   Week:(int)week
                WeekDay:(int)weekday
               Duration:(int)duration
                     Oz:(NSString *)oz
               FoodType:(NSString *)food_type
                 Remark:(NSString *)remark
               MoreInfo:(NSString*)more_info
             CreateTime:(long)createtime;

/**
 *  插入玩耍记录
 *
 *  @param create_time 创建时间
 *  @param update_time 更新时间
 *  @param start_time  开始时间
 *  @param month       月
 *  @param week        周
 *  @param weekday     周几
 *  @param duration    持续时间
 *  @param place       地点
 *  @param play_type   如何玩
 *  @param remark      备注
 *  @param more_info
 *
 *  @return
 */
-(BOOL)insertBabyPlayRecord:(long)create_time
                 UpdateTime:(long)update_time
                  StartTime:(NSDate *)start_time
                      Month:(int)month
                       Week:(int)week
                    Weekday:(int)weekday
                   Duration:(int)duration
                      Place:(NSString *)place
                  PlaceType:(NSString *)play_type
                     Remark:(NSString *)remark
                   MoreInfo:(NSString *)more_info;

/**
 *  更新玩耍
 *
 *  @param starttime  开始时间
 *  @param month      月
 *  @param week       周
 *  @param weekday    周几
 *  @param duration   持续时间
 *  @param place      地点
 *  @param play_type  玩耍方式
 *  @param remark     备注
 *  @param more_info
 *  @param createtime 创建时间
 *
 *  @return
 */
-(BOOL)updatePlayRecord:(NSDate*)starttime
                  Month:(int)month
                   Week:(int)week
                WeekDay:(int)weekday
               Duration:(int)duration
                  Place:(NSString *)place
              PlaceType:(NSString *)play_type
                 Remark:(NSString *)remark
               MoreInfo:(NSString*)more_info
             CreateTime:(long)createtime;

/**
 *  新增睡觉记录
 *
 *  @param create_time 创建时间
 *  @param update_time 更新时间
 *  @param start_time  开始时间
 *  @param month       月
 *  @param week        周
 *  @param weekday     周几
 *  @param duration    持续时间
 *  @param posture     姿势
 *  @param place       地点
 *  @param remark
 *  @param more_info
 *
 *  @return
 */
-(BOOL)insertBabySleepRecord:(long)create_time
                 UpdateTime:(long)update_time
                  StartTime:(NSDate *)start_time
                      Month:(int)month
                       Week:(int)week
                    Weekday:(int)weekday
                   Duration:(int)duration
                    Posture:(NSString *)posture
                      Place:(NSString *)place
                     Remark:(NSString *)remark
                   MoreInfo:(NSString *)more_info;

/**
 *  更新睡觉
 *
 *  @param starttime  开始时间
 *  @param month      月
 *  @param week       周
 *  @param weekday    周几
 *  @param duration   持续时间
 *  @param posture    姿势
 *  @param place      地点
 *  @param remark     备注
 *  @param more_info
 *  @param createtime
 *
 *  @return
 */
-(BOOL)updateSleepRecord:(NSDate*)starttime
                  Month:(int)month
                   Week:(int)week
                WeekDay:(int)weekday
               Duration:(int)duration
                Posture:(NSString *)posture
                  Place:(NSString *)place
                 Remark:(NSString *)remark
               MoreInfo:(NSString*)more_info
             CreateTime:(long)createtime;

/**
 *  新增吃药记录
 *
 *  @param create_time 创建时间
 *  @param update_time 更新时间
 *  @param start_time  开始时间
 *  @param month       月
 *  @param week        周
 *  @param weekday     周几
 *  @param medicine    药名
 *  @param descption   描述
 *  @param amount      用量
 *  @param danwei      单位
 *  @param timegap     时间间隔
 *  @param isreminder  提醒
 *  @param more_info
 *
 *  @return
 */
-(BOOL)insertBabyMedicineRecord:(long)create_time
                  UpdateTime:(long)update_time
                   StartTime:(NSDate *)start_time
                       Month:(int)month
                        Week:(int)week
                     Weekday:(int)weekday
                    Medicine:(NSString *)medicine
                 Description:(NSString *)desp
                      Amount:(NSString *)amount
                      Danwei:(NSString *)danwei
                     Timegap:(NSString *)timegap
                  IsReminder:(BOOL)isreminder
                    MoreInfo:(NSString *)more_info;

/**
 *  更新睡觉
 *
 *  @param starttime   开始时间
 *  @param month       月
 *  @param week        周
 *  @param weekday     周几
 *  @param medicine    药名
 *  @param descption   描述
 *  @param amount      用量
 *  @param danwei      单位
 *  @param timegap     时间间隔
 *  @param isreminder  提醒
 *  @param more_info
 *  @param createtime
 *
 *  @return
 */
-(BOOL)updateMedicineRecord:(NSDate*)starttime
                   Month:(int)month
                    Week:(int)week
                 WeekDay:(int)weekday
                Medicine:(NSString *)medicine
             Description:(NSString *)desp
                  Amount:(NSString *)amount
                  Danwei:(NSString *)danwei
                 Timegap:(NSString *)timegap
              IsReminder:(BOOL)isreminder
                MoreInfo:(NSString *)more_info
              CreateTime:(long)createtime;


/**
 *  删除记录
 *
 *  @param create_time 创建时间
 *  @param tablename   针对项目表名
 *
 *  @return
 */
-(BOOL)deleteBabyRecord:(long)create_time
              Tablename:(NSString*)tablename;


/**
 *  更新操作时长
 *
 *  @param create_time 创建时间
 *  @param duration    时长
 *  @param tablename   表名
 *
 *  @return
 */
-(BOOL)updateDuration:(long)create_time
             Duration:(int)duration
            Tablename:(NSString*)tablename;

/**
 *  更新同步时间
 *
 *  @param tablename   表名
 *  @param uploadtime  同步时间
 *  @param create_time 创建时间
 *
 *  @return
 */
-(BOOL)updateUploadtime:(NSString*)tablename andUploadTime:(long)uploadtime andCreateTime:(long)create_time;

@end
