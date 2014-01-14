//
//  EnvironmentAdviceDataBase.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-11-28.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvironmentAdviceDataBase : NSObject
+(id)dataBase;

/**
 *	根据温度选择建议
 *
 *	@param	temp	当前温度值
 *
 *	@return	对应温度建议id
 */
+(NSArray*)selectFeedSuggestionByTemp:(int)temp;
+(NSArray*)selectPlaySuggestionByTemp:(int)temp;
+(NSArray*)selectBathSuggestionByTemp:(int)temp;
+(NSArray*)selectSleepSuggestionByTemp:(int)temp;
+(NSArray*)selectDiaperSuggestionByTemp:(int)temp;

/**
 *	湿度建议
 *
 *	@param	humi	当前湿度值
 *
 *	@return	湿度建议ID
 */
+(NSArray*)selectFeedSuggestionByHumi:(int)humi;
+(NSArray*)selectPlaySuggestionByHumi:(int)humi;
+(NSArray*)selectBathSuggestionByHumi:(int)humi;
+(NSArray*)selectSleepSuggestionByHumi:(int)humi;
+(NSArray*)selectDiaperSuggestionByHumi:(int)humi;

/**
 *	空气质量建议
 *
 *	@param	pm25	空气质量值
 *
 *	@return	空气质量建议ID
 */
+(NSArray*)selectFeedSuggestionByPM25:(int)pm25;
+(NSArray*)selectPlaySuggestionByPM25:(int)pm25;
+(NSArray*)selectBathSuggestionByPM25:(int)pm25;
+(NSArray*)selectSleepSuggestionByPM25:(int)pm25;
+(NSArray*)selectDiaperSuggestionByPM25:(int)pm25;

+(NSArray*)selectsuggestiontemp:(int)sid;
+(NSArray*)selectsuggestionhumi:(int)sid;
+(NSArray*)selectsuggestionlight:(int)sid;
+(NSArray*)selectsuggestionnoice:(int)sid;
+(NSArray*)selectsuggestionpm25:(int)sid;
+(NSArray*)selectsuggestionuv:(int)sid;

@end
