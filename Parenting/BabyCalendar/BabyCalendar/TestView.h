//
//  TestView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#include "BaseView.h"
#import "TestMiddleView.h"
#import "TestFootView.h"
@class TestHeaderView;

@interface TestView : BaseView<TestMiddleViewDelegate,TestFootViewDelegate>
{
    UIScrollView* _scrollView;
    TestHeaderView* _headerView;
    TestFootView*   _footView;
    

}
@property(nonatomic,assign)NSInteger month;
@property(nonatomic,retain)TestMiddleView* middleView;
@end
