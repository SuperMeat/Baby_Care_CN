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

/*
 *  插入数据库
 */
+(BOOL)insertLittleTip:(int)littleTipId
            CreateTime:(int)createTime
            UpdateTime:(int)updateTime
            StartMonth:(int)startMonth
              EndMonth:(int)endMonth
               TipLock:(int)tipLock
            TipContent:(NSString*)tipContent
                  Feed:(int)feed
                 Sleep:(int)sleep
                  Bath:(int)bath
                  Play:(int)play
                Diaper:(int)diaper
                   Medicine:(int)medicine;

/*
 *  获取最后更新时间
 */
+(long)getLastUpdateTime;
@end
