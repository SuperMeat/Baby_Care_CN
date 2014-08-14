//
//  VaccineDetailHeaderView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "VaccineDetailHeaderView.h"
#import "VaccineModel.h"
@implementation VaccineDetailHeaderView

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
    
    _labVaccine.textColor = UIColorFromRGB(kColor_val_detail_headText);
    _labIllness.textColor = UIColorFromRGB(kColor_val_detail_headText);
    _labVaccine.font = [UIFont fontWithName:kFont size:15];
    _labIllness.font = [UIFont fontWithName:kFont size:15];
    
    _switchView = [[CustomUISwitchView alloc] initWithImageYES:[UIImage imageNamed:@"vaccine_completed"] WithImageNO:[UIImage imageNamed:@"vaccine_uncompleted"]];
    _switchView.frame = CGRectMake(216, 63, 78, 28);
    _switchView.userInteractionEnabled = YES;
    _switchView.delegate = self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:_switchView];
}
- (void)setModel:(VaccineModel *)model
{
    _model = model;
    
    _labVaccine.text = [NSString stringWithFormat:@"%@(%@)",_model.vaccine,_model.times];
    _labIllness.text = [NSString stringWithFormat:@"可预防：%@",_model.illness];
    
    // 疫苗的接种日早于规定的日期
    if (_model.willDate != nil && ![_model.completed boolValue]) {
        NSDate* date = [BaseMethod dateFormString:_model.willDate];
        NSString* today = [BaseMethod stringFromDate:[NSDate date]];
        _days = [BaseMethod fromStartDate:[BaseMethod dateFormString:today] withEndDate:date];

    }
    
    // 未完成就显示为今天日期
    if (![_model.completed boolValue]) {
        NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
        NSString* today = [userDef objectForKey:kSelectedDate];
        _model.completedDate = today;
    }

    [_btnDate setTitle:_model.completedDate forState:UIControlStateNormal];
    
    if ([_model.completed boolValue]) {
        _switchView.on = YES;
    }else
    {
        _switchView.on = NO;
    }
}

- (IBAction)selectDate:(id)sender {
    
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
        _model.completedDate = dateString;
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

#pragma mark - CustomUISwitchViewDelegate

- (void)customUISwitchViewTap:(CustomUISwitchView*)switchView
{

    if (_days > 0) {
        if (switchView.on) {
            switchView.on = NO;
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"疫苗的接种日期早于规定日期哦，确定宝宝已经接种该疫苗了吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
    }
    _model.completed = [NSNumber numberWithBool:switchView.on];
    if (!switchView.on) {
        _model.completedDate = nil;
    }
}

#pragma mark -  UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _switchView.on = YES;
         _model.completed = [NSNumber numberWithBool:_switchView.on];
    }
}
@end
