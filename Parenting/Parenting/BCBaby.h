//
//  BCBaby.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-9-30.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCBaby : NSObject

#pragma mark 宝宝ID
@property (nonatomic,assign)    long        babyId;

#pragma mark 创建时间
@property (nonatomic,assign)    long        createTime;

#pragma mark 宝贝名字
@property (nonatomic,copy)      NSString*   babyName;

#pragma mark 宝贝名字
@property (nonatomic,copy)      NSString*   babySex;

#pragma mark 出生时间
@property (nonatomic,assign)    long        birthTime;

#pragma mark 出生日数
@property (nonatomic,assign)    long        birthOfDays;

#pragma mark 出生日数文本
@property (nonatomic,copy)      NSString*   birthOfDaysStr;

#pragma mark 生长阶段
@property (nonatomic,copy)      NSString*   growthStage;

#pragma mark 头像路径
@property (nonatomic,copy)      NSString*   babyPhotoPath;

#pragma mark 带参数的构造函数
-(BCBaby*)initWithBabyId:(long)babyId
           andCreateTime:(long)createTime
             andBabyName:(NSString*)babyName
              andBabySex:(NSString*)babySex
            andBirthTime:(long)birthTime
          andBirthOfDays:(long)birthOfDays
       andBirthOfDaysStr:(NSString*)birthOfDaysStr
          andGrowthStage:(NSString*)growthStage
        andBabyPhotoPath:(NSString*)babyPhotoPath;

#pragma mark 带参数的静态对象初始化方法
+(BCBaby*)initWithBabyId:(long)babyId
           andCreateTime:(long)createTime
             andBabyName:(NSString*)babyName
              andBabySex:(NSString*)babySex
            andBirthTime:(long)birthTime
          andBirthOfDays:(long)birthOfDays
       andBirthOfDaysStr:(NSString*)birthOfDaysStr
          andGrowthStage:(NSString*)growthStage
        andBabyPhotoPath:(NSString*)babyPhotoPath;
@end
