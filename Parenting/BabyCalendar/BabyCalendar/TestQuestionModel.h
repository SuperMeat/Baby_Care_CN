//
//  TestQuestionModel.h
//  BabyCalendar
//
//  Created by will on 14-6-13.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestQuestionModel : NSObject
@property(nonatomic,copy)NSString* type;
@property(nonatomic,copy)NSString* content;
@property(nonatomic,copy)NSString* image;
@property(nonatomic,retain)NSNumber* answer;
@end
