//
//  CKCalendarModel.h
//  BabyCalendar
//
//  Created by will on 14-6-16.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MilestoneModel;
@class VaccineModel;
@class TestModel;
@class NoteModel;
@interface CKCalendarModel : NSObject

@property(nonatomic,retain)NSNumber* milestone;
@property(nonatomic,retain)NSNumber* vaccine;
@property(nonatomic,retain)NSNumber* train;
@property(nonatomic,retain)NSNumber* test;
@property(nonatomic,retain)MilestoneModel* milestoneModel;
@property(nonatomic,retain)VaccineModel* vaccineModel;
@property(nonatomic,retain)TestModel* testModel;
@property(nonatomic,retain)NoteModel* noteModel;
@property(nonatomic,assign)int vaccineNum;


@end
