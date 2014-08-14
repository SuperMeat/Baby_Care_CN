//
//  TestReportFootView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TestModel;
@class ZhuView;
@interface TestReportFootView : UIView
{
    ZhuView* _knowledge_zhuView;
    ZhuView* _active_zhuView;
    ZhuView* _language_zhuView;
    ZhuView* _society_zhuView;
    
}
@property(nonatomic,retain)TestModel* model;
@end
