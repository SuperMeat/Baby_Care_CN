//
//  MilestoneModel.h
//  BabyCalendar
//
//  Created by Will on 14-6-7.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <Foundation/Foundation.h>
//id int,date text,month text,title text,content text,photo_path text,completed bool
@interface MilestoneModel : NSObject
@property(nonatomic,copy)NSString* id;
@property(nonatomic,copy)NSString* date;
@property(nonatomic,copy)NSNumber* month;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* content;
@property(nonatomic,copy)NSString* photo_path;
@property(nonatomic,retain)NSNumber* completed;
@end
