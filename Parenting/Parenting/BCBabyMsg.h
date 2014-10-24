//
//  BCBabyMsg.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-10-9.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCBabyMsg : NSObject

#pragma mark - 属性
#pragma mark 消息类型
@property (nonatomic,assign)    int         msgType;

#pragma mark 消息内容
@property (nonatomic,copy)      NSString*   msgContent;

#pragma mark 图片URL
@property (nonatomic,copy)      NSString*   picUrl;

#pragma mark 消息创建时间
@property (nonatomic,assign)    long        createTime;

#pragma mark key
@property (nonatomic,copy)      NSString*   key;

#pragma mark 图标-处理后数据
@property (nonatomic,copy)      NSString*   icon;
#pragma mark 时间-处理后数据
@property (nonatomic,copy)      NSString*   time;

#pragma mark - 方法
#pragma mark 根据字典初始化对象
-(BCBabyMsg*)initWithDictionary:(NSDictionary*)dic;

#pragma mark 静态初始化构造方法
+(BCBabyMsg*)babyMsgWithDictionary:(NSDictionary*)dic;


@end
