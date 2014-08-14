//
//  CKCalendarDataSource.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/17/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#ifndef MBCalendarKit_CKCalendarDataSource_h
#define MBCalendarKit_CKCalendarDataSource_h

@class CKCalendarView;

@protocol CKCalendarViewDataSource <NSObject>

@optional
- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date;

- (void)calendarView:(CKCalendarView *)CalendarView title:(NSString*)text;
@end



#endif
