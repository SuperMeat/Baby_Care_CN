//
//  WhoDataBase.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-18.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WhoDataBase : NSObject

+(id)whoDB;
+(NSArray*)getDataArrayByXposition:(NSArray*)xPosition Condition:(NSString*)condition TableName:(NSString*) tableName;
@end
