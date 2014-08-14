//
//  TrainView.h
//  BabyCalendar
//
//  Created by will on 14-5-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrainHeaderView;
@class TrainList;
@interface TrainView : UIView
{
    TrainHeaderView* _headerView;
    TrainList*       _list;
}
@end
