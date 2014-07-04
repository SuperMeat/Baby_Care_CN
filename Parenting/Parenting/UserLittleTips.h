//
//  UserLittleTips.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-6-17.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLittleTips : NSObject
+(id)dataBase;
/**
 *  查询小撇步
 *
 *  @param age 年龄 操作项目condition
 *
 *  @return 订阅信息数组
 */
-(NSArray*)selectLittleTipsByAge:(int)age andCondition:(int)condition;
-(BOOL)updateReadTime:(int)tips_id;
@end
