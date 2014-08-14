//
//  TestReportView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestReportHeaderView;
@class TestReportMiddleView;
@class TestReportFootView;
@interface TestReportView : UIScrollView
{
    TestReportHeaderView* _headerView;
    TestReportMiddleView* _middleView;
    TestReportFootView*   _footView;
}
@property(nonatomic,assign)NSInteger month;
@property(nonatomic,retain)NSMutableArray* datas;
@end
