//
//  BCBaby.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-9-30.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "BCBaby.h"

@implementation BCBaby

-(BCBaby*)initWithBabyId:(long)babyId
           andCreateTime:(long)createTime
             andBabyName:(NSString*)babyName
              andBabySex:(NSString*)babySex
            andBirthTime:(long)birthTime
            andBirthOfDays:(long)birthOfDays
         andBirthOfDaysStr:(NSString*)birthOfDaysStr
          andGrowthStage:(NSString*)growthStage
        andBabyPhotoPath:(NSString*)babyPhotoPath{
    if (self = [super init]) {
        self.babyId = babyId;
        self.createTime = createTime;
        self.babyName = babyName;
        self.babySex = babySex;
        self.birthTime = birthTime;
        self.birthOfDays = birthOfDays;
        self.birthOfDaysStr = birthOfDaysStr;
        self.growthStage = growthStage;
        self.babyPhotoPath = babyPhotoPath;
    }
    return self;
}

+(BCBaby*)initWithBabyId:(long)babyId
            andCreateTime:(long)createTime
              andBabyName:(NSString*)babyName
               andBabySex:(NSString*)babySex
             andBirthTime:(long)birthTime
           andBirthOfDays:(long)birthOfDays
        andBirthOfDaysStr:(NSString*)birthOfDaysStr
           andGrowthStage:(NSString*)growthStage
        andBabyPhotoPath:(NSString*)babyPhotoPath{
    BCBaby *bcBaby=[[BCBaby alloc] initWithBabyId:babyId andCreateTime:createTime andBabyName:babyName andBabySex:babySex andBirthTime:birthTime andBirthOfDays:birthOfDays andBirthOfDaysStr:birthOfDaysStr andGrowthStage:growthStage andBabyPhotoPath:babyPhotoPath];
    return bcBaby;
}

@end
