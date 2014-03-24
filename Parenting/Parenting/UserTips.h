//
//  UserTips.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-20.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTips : NSObject
+(id)dataBase;
-(NSArray*)selectTipsCategoryByFlagId:(int)flagid;
-(NSArray*)selectTipListByCategoryId:(int)categoryid;
-(NSDictionary*)selectTipByTipId:(int)tipid;
@end
