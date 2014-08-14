//
//  AddMilestoneModel.h
//  BabyCalendar
//
//  Created by Will on 14-6-8.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddMilestoneModel : NSObject
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* month;
@property(nonatomic,copy)NSString* date;
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,assign)BOOL completed;
@end
