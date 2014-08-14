//
//  CalendarCell.h
//  BabyCalendar
//
//  Created by will on 14-5-21.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CalendarModel;
@class CKCalendarModel;
@class NoteInfoView;
@interface CalendarCell : UITableViewCell
{
    IBOutlet UILabel *_labDetail;

    __weak IBOutlet UIButton *_btnCell;
    __weak IBOutlet UIImageView *_bgCellView;
    __weak IBOutlet UIImageView *_pointView;
    
    NoteInfoView* _noteInfoView;
}
@property(nonatomic,retain)CalendarModel* model;
@property(nonatomic,retain)CKCalendarModel* ckModel;
@property(nonatomic,assign)NSInteger row;
@end
