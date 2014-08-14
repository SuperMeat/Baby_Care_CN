//
//  NoteModel.h
//  BabyCalendar
//
//  Created by Will on 14-6-14.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject

@property(nonatomic,retain)NSNumber* id;
@property(nonatomic,copy)NSString* content;
@property(nonatomic,copy)NSString* date;
@property(nonatomic,retain)NSNumber* mood;
@property(nonatomic,copy)NSString* photo;

@end
