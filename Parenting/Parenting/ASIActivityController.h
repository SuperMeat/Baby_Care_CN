//
//  ASIActivityController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-2-28.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

@interface ASIActivityController : NSObject

+(id)ASIActivityController;
-(int)postDiaperRecordAccount:(NSString*)account
                       Upload:(int)upload
                     Starttime:(NSDate*)starttime
                         Month:(int)month
                          Week:(int)week
                       WeekDay:(int)weekday
                        Status:(NSString*)status
                         Color:(NSString *)color
                        Remark:(NSString *)remark;

@end