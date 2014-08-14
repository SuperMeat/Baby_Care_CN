//
//  CreatMilestoneHeaderView.h
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreatMilestoneHeaderViewDelegate <NSObject>

- (void)selectDate;

@end

@class MilestoneModel;
@interface CreatMilestoneHeaderView : UIView<CustomIOS7AlertViewDelegate,UITextFieldDelegate>
{
    CustomIOS7AlertView *_alertView;
    UIDatePicker* _datePicker;
}
@property(nonatomic,retain)MilestoneModel* model;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (nonatomic,assign)id<CreatMilestoneHeaderViewDelegate> delegate;
@property(nonatomic,assign)creatMilestoneType type;


- (IBAction)selectDateAction:(id)sender;

@end
