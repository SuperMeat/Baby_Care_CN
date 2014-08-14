//
//  VaccineListCell.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VaccineModel;
@interface VaccineListCell : UITableViewCell
{
    __weak IBOutlet UILabel *_labVaccine;
    __weak IBOutlet UILabel *_labInplan;
    __weak IBOutlet UILabel *_labCompleted;
    __weak IBOutlet UILabel *_labDate;
    
}
@property(nonatomic,retain)VaccineModel* model;
@end
