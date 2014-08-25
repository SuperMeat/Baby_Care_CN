//
//  CreatMilestoneHeaderView.m
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "CreatMilestoneHeaderView.h"
#import "MilestoneModel.h"
@implementation CreatMilestoneHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _textField.delegate = self;
    _textField.font = [UIFont fontWithName:kFont size:18.0f];

    
    [_btnDate.titleLabel setFont:_textField.font = [UIFont fontWithName:kFont size:15.0f]];
    [_btnDate setTitleColor:UIColorFromRGB(kColor_milestone_add_date) forState:UIControlStateNormal];
    
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSString* selectedDateStr = [userDef objectForKey:kSelectedDate];
    [_btnDate setTitle:selectedDateStr forState:UIControlStateNormal];
    
}

- (void)setModel:(MilestoneModel *)model
{
    _model = model;
    
    if (_model.title == nil) {
        _textField.text = _model.title;
    }
    else
    {
        _textField.text = [NSString stringWithFormat:_model.title,[BaseMethod getBabyNickname]];
    }
    
    if (_model.date == nil || [_model.date isEqualToString:@""]) {
        
        _model.date = [BaseMethod selectedDateFromSave];
    }
    [_btnDate setTitle:_model.date forState:UIControlStateNormal];
}
- (void)setType:(creatMilestoneType)type
{
    _type = type;
    
    if (_type == creatMilestoneType_model) {
        _textField.enabled = NO;
    }
    if (_type == creatMilestoneType_new) {
        _textField.enabled = YES;
    }
}

- (IBAction)selectDateAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectDate)]) {
        [self.delegate selectDate];
    }

    if (_alertView == nil) {
        _alertView = [[CustomIOS7AlertView alloc] init];
        [_alertView setContainerView:[self createDemoView]];
        [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        [_alertView setDelegate:self];
    }
    
    [_alertView show];
}

#pragma mark - CustomIOS7AlertView delegate
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    // 确定
    if (buttonIndex == 1) {
        NSDate* selectedDate = _datePicker.date;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:kDateFormat];
        NSString* dateString = [formatter stringFromDate:selectedDate];
        [_btnDate setTitle:dateString forState:UIControlStateNormal];
    }
    
    [_alertView close];
}
- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 216)];

    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_datePicker setMaximumDate:[NSDate date]];
    [demoView addSubview:_datePicker];
    
    return demoView;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
