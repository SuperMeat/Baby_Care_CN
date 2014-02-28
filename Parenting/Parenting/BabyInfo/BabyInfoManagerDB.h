//
//  BabyInfoManagerDB.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-2-27.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BabyInfoManagerDB : NSObject
+(id)babyinfoDB;

/**
 *	新增宝宝信息
 */
+(BOOL)createNewBabyInfo:(NSString*)name andBirthday:(NSDate*)birthday andTall:(NSString*)tall andWeight:(NSString*)weight andHC:(NSString*) hc andSex:(NSString*)sex andHeadPhoto:(NSString*)headphoto;

/**
 *	更新宝宝信息
 */
+(BOOL)updateBabyInfoName:(NSString*)name andId:(int)id
{
    
}
@end
