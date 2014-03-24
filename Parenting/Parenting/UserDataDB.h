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

-(BOOL)updateUserCategoryIds:(NSString*)ids andUserId:(int)user_id;
-(BOOL)updateUserPhoto:(NSString*)photo andUserId:(int)user_id;

@end
