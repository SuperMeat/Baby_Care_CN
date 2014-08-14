//
//  TestModel.h
//  BabyCalendar
//
//  Created by will on 14-6-13.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject
@property(nonatomic,copy)NSString* date;// 测评时间
@property(nonatomic,retain)NSNumber* month;//第几个月
@property(nonatomic,retain)NSNumber* completed; // 测评是否已完成
@property(nonatomic,retain)NSNumber* score;// 测评分数
@property(nonatomic,retain)NSNumber* knowledge_score;// 认知能力得分
@property(nonatomic,retain)NSNumber* active_score;//动作能力得分
@property(nonatomic,retain)NSNumber* language_score;//生活能力得分
@property(nonatomic,retain)NSNumber* society_score;//社交能力得分
@end
