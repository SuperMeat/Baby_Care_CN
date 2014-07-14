//
//  MessageDataDB.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-11.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BabyMessageDataDB : NSObject

+(id)babyMessageDB;
/**
 *  新增宝宝信息
 *
 *  @param create_time           创建时间
 *  @param update_time           更新时间
 *  @param key
 *  @param msg_type              消息类型
 *  @param msg_content           消息内容
 *  @param pic_url               图片地址
 *
 *  @return 创建成功TRUE失败FALSE
 */

-(NSMutableArray*)selectAll;

-(BOOL)insertBabyMessageNormal:(int)create_time
                    UpdateTime:(int)update_time
                           key:(NSString*)key
                          type:(int)msg_type
                       content:(NSString*)msg_content;

-(BOOL)deleteBabyMessage:(NSString*) key;
@end
