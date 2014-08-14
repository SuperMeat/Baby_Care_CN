//
//  VaccineModel.h
//  BabyCalendar
//
//  Created by will on 14-6-11.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VaccineModel : NSObject
@property(nonatomic,retain)NSNumber* id;
@property(nonatomic,copy)NSString* vaccine;
@property(nonatomic,copy)NSString* illness;
@property(nonatomic,copy)NSString* completedDate;
@property(nonatomic,copy)NSString* willDate;
@property(nonatomic,copy)NSString* times;
@property(nonatomic,retain)NSNumber* inplan;
@property(nonatomic,retain)NSNumber* completed;

@end
