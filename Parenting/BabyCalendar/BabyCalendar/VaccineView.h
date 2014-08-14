//
//  VaccineView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"
@class VaccineHeaderView;
@class VaccineListView;
@interface VaccineView : BaseView
{
    VaccineHeaderView* _headerView;
    VaccineListView* _listView;
}
@end
