//
//  UpLoadController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-2-28.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpLoadController : NSObject
+(id)uploadCtrller;
+(void)checkDiaperUpload:(int)flag;
+(NSArray*)PostActivityRecord:(NSArray*) records Type:(int)type;
@end
