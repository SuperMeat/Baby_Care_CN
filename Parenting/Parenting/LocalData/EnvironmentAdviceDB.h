//
//  EnvironmentAdviceDataBase.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-11-28.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvironmentAdviceDB : NSObject
+(id)dataBase;

/**
 *  获取随机建议
 *
 *  @param condition 建议匹配环境条件
 *  #define ENVIR_SUGGESTION_TYPE_TEMP  0
 *  #define ENVIR_SUGGESTION_TYPE_HUMI  1
 *  #define ENVIR_SUGGESTION_TYPE_LIGHT 2
 *  #define ENVIR_SUGGESTION_TYPE_NOICE 3
 *  #define ENVIR_SUGGESTION_TYPE_UV    4
 *  #define ENVIR_SUGGESTION_TYPE_PM25  5
 *  @param value     环境值
 *
 *  @return 建议数组
 */
+(NSArray*)selectSuggestionByCondition:(int)condition andValue:(NSNumber*) value;

/**
 *  建议信息
 *
 *  @param sid       建议
 *  @param condition 当前环境条件
 *
 *  @return 建议数组
 */
+(NSArray*)selectSuggestionBySid:(int)sid andCondition:(int)condition;

@end
