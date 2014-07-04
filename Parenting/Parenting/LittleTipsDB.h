//
//  LittleTipsDB.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-7-2.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LittleTipsDB : NSObject

+(id)littleTipsDB;

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
                   Cry:(int)cry;

@end
