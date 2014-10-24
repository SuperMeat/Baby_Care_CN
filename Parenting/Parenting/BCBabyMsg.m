//
//  BCBabyMsg.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-10-9.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "BCBabyMsg.h"

@implementation BCBabyMsg

-(BCBabyMsg*)initWithDictionary:(NSDictionary*)dic{
    if (self = [super init]) {
        self.msgType = [dic[@"msg_type"] intValue];
        self.msgContent = dic[@"msg_content"];
        self.key = dic[@"key"];
        self.picUrl = dic[@"pic_url"];
        self.createTime = [dic[@"create_time"] longValue];
        
        self.icon = dic[@"icon"];
        self.time = dic[@"time"];
    }
    return self;
}

+(BCBabyMsg*)babyMsgWithDictionary:(NSDictionary*)dic{
    BCBabyMsg *babyMsg = [[BCBabyMsg alloc]initWithDictionary:dic];
    return babyMsg;
}

@end
