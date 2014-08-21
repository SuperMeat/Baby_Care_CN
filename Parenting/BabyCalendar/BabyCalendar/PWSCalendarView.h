//
//  PWSCalendarView.h
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//
/////////////////////////////////////////////////////////////////////////////////////////////
#import "BaseView.h"
#import "PWSHelper.h"
@class PWSCalendarView;
/////////////////////////////////////////////////////////////////////////////////////////////
@protocol PWSCalendarDelegate <NSObject>

@optional
- (void) PWSCalendar:(PWSCalendarView*)_calendar didSelecteDate:(NSDate*)_date atIndexPath:(NSIndexPath*)indexPath;

- (void) PWSCalendar:(PWSCalendarView*)_calendar didChangeViewHeight:(CGFloat)_height;

- (void) PWSCalendar:(PWSCalendarView*)_calendar titleDate:(NSDate*)date;

@end

/////////////////////////////////////////////////////////////////////////////////////////////
@interface PWSCalendarView : BaseView

@property (nonatomic, assign) id<PWSCalendarDelegate> delegate;
@property (nonatomic, assign) enCalendarViewType      type;
@property (nonatomic, assign) enCalendarViewHeaderViewType headType;
@property (nonatomic, strong) UIView*                 customTimeView;
@property (nonatomic, strong) UIView*                 customDataView;
@property(nonatomic,assign)int                m_current_page;
@property(nonatomic,assign)int                m_init_page;
@property(nonatomic,retain)UICollectionView*  m_view_calendar;
@property(nonatomic,assign)BOOL  isResetFrame;

- (id) initWithFrame:(CGRect)frame CalendarType:(enCalendarViewType)pType;

- (float) GetCalendarViewHeight;

- (void) ScrollToToday;


@end
