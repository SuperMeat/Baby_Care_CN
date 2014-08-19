//
//  UnTrianModel.h
//  BabyCalendar
//
//  Created by will on 14-5-29.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainModel : NSObject
@property(nonatomic,retain)NSNumber* id;
@property(nonatomic,copy)NSString* type;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* content;
@property(nonatomic,retain)NSNumber *trained;
@property(nonatomic,copy)NSString* date;
@property(nonatomic,retain)NSNumber* month;
@end
