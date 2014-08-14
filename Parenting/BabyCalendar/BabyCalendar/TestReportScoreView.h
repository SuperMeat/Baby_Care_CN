//
//  TestReportScoreView.h
//  BabyCalendar
//
//  Created by Will on 14-7-17.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TestModel;
@interface TestReportScoreView : UIView
{
    UILabel* _zeroLab;
    UILabel* _scoreLab;
    UILabel* _levLab;
    UILabel* _levTitleLab;
}
@property(nonatomic,retain)TestModel* model;
@end
