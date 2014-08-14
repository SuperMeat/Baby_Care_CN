//
//  VaccineDetailHeaderView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "CustomUISwitchView.h"
@class VaccineModel;
@interface VaccineDetailHeaderView : UIView<CustomIOS7AlertViewDelegate,UIAlertViewDelegate,CustomUISwitchViewDelegate>
{
    __weak IBOutlet UILabel *_labVaccine;
    __weak IBOutlet UILabel *_labIllness;

    __strong IBOutlet CustomUISwitchView *_switchView;
    __weak IBOutlet UIButton *_btnDate;
    
    CustomIOS7AlertView* _alertView;
    UIDatePicker* _datePicker;
    
    int _days;
    
}
@property(nonatomic,retain)VaccineModel* model;

- (IBAction)selectDate:(id)sender;

@end
