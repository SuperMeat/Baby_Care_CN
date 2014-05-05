//
//  UserTipsDB.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-20.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTipsDB : NSObject
+(id)dataBase;
/**
 *  查询订阅目录信息
 *
 *  @param flagid 0所有 >0 对应订阅信息
 *
 *  @return 订阅信息数组
 */
-(NSArray*)selectTipsCategoryByFlagId:(int)flagid;

/**
 *  贴士列表
 *
 *  @param categoryid 对应目录id
 *
 *  @return 贴士数组
 */
-(NSArray*)selectTipListByCategoryId:(int)categoryid;

/**
 *  某条贴士信息
 *
 *  @param tipid 贴士id
 *
 *  @return 贴士信息字典
 */
-(NSDictionary*)selectTipByTipId:(int)tipid;

@end
