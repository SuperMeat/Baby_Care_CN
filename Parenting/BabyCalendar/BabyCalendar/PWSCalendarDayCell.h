//
//  PWSCalendarDayCell.h
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CKCalendarModel;
@interface PWSCalendarDayCell : UICollectionViewCell


@property(nonatomic,retain)CKCalendarModel* model;
@property(nonatomic,retain)NSDate* date;
@property(nonatomic,assign)NSInteger todayRow;
@end
