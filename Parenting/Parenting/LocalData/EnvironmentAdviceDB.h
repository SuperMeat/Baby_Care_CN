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

+(NSArray*)selectSuggestionByCondition:(int)condition andValue:(NSNumber*) value;

+(NSArray*)selectSuggestionBySid:(int)sid andCondition:(int)condition;

@end
