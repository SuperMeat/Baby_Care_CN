//
//  TipCategoryDB.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-5-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TipCategoryDB : NSObject

+(id)tipCategoryDB;

+(NSArray*)selectAllCategoryList;

+(BOOL)checkUpdateState:(int)categoryId
             UpdateTime:(int)updateTime;

+(BOOL)insertCategoryDB:(int)categoryId
             CreateTime:(int)createTime
             UpdateTime:(int)updateTime
               ParentId:(int)parentId
                   name:(NSString*)name
                describe:(NSString*)describe
                   icon:(NSString*)icon;

+(BOOL)checkExist:(int)categoryId;
+(BOOL)checkSubscribe:(int)UserID
           categoryId:(int)categoryId;
@end
