//
//  TestReportHeaderView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestModel;
@class TestReportScoreView;
@interface TestReportHeaderView : UIView
{
    __weak IBOutlet UILabel *_labMonth;
    TestReportScoreView* _scoreView;
    
}
@property(nonatomic,retain)TestModel* model;
@end
