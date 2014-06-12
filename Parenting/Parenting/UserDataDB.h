//
//  UserDataDB.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-19.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataDB : NSObject
+(id)dataBase;

/**
 *  用户表
 *
 *  @param user_id    用户唯一ID,服务器生成
 *  @param cgids      用户订阅内容
 *  @param icon       头像
 *  @param userType   账户类型(注册,第三方新浪,QQ)
 *  @param account    账户
 *  @param appver     版本号
 *  @param createtime 创建时间
 *  @param updatetime 同步时间
 *
 *  @return 操作成功TRUE失败FALSE
 */
-(BOOL)createNewUser:(int)user_id andCategoryIds:(NSString*)cgids andIcon:(NSString*)icon andUserType:(int)userType andUserAccount:(NSString*)account andAppVer:(NSString*)appver andCreateTime:(long)createtime andUpdateTime:(long)updatetime;

/**
 *  获取用户信息
 *
 *  @param user_id 用户ID
 *
 *  @return 用户信息表字典
 */
-(NSDictionary*)selectUser:(int)user_id;

/**
 *  用户更改订阅目录
 *
 *  @param ids     组合好的订阅目录eg:@"1;2;3;..."
 *  @param user_id 用户id
 *
 *  @return 更新成功true失败false
 */
-(BOOL)updateUserCategoryIds:(NSString*)ids andUserId:(int)user_id;

/**
 *  更新用户头像
 *
 *  @param photo   照片
 *  @param user_id 用户id
 *
 *  @return 返回成功true失败false
 */
-(BOOL)updateUserPhoto:(NSString*)photo andUserId:(int)user_id;

/**
 *  用户收到推送消息
 *
 *  @param msg 小心
 *
 *  @return 插入成功true失败false
 */
-(BOOL)insertNotifyMessage:(NSString*)msg andTitle:(NSString*)title;

/**
 *  更新消息阅读状态
 *
 *  @param userid      用户id
 *  @param create_time 通知的时间
 *
 *  @return 更新成功true失败false
 */
-(BOOL)updateNotifyMessageById:(int)userid andCreateTime:(long)create_time;

/**
 *  更新所有
 *
 *  @return 更新成功true失败false
 */
-(BOOL)updateNotifyMessageAll;

/**
 *	请求所有推送消息如果flagid为0则全部，否则为指定msgid=flagid
 *
 *	@return	封装好的数组对象
 */
-(NSArray*)selectNotifyMessage:(int)flagid;

/**
 *  删除通知,系统控制
 *
 *  @param date 在规定时间内删除
 *
 *  @return
 */
-(BOOL)deleteNotifyMessage:(NSDate*) date;

/**
 *  用户手动删除
 *
 *  @param msgid 消息id
 *
 *  @return 删除成功true失败false
 */
-(BOOL)deleteNotifyMessageById:(int)msgid;
@end
