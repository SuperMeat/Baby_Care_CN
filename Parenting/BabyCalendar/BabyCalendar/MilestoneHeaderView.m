//
//  MilestoneHeaderView.m
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "MilestoneHeaderView.h"

@implementation MilestoneHeaderView

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
    
    _photoView.index = 1;
    _photoView.delegate = self;

    _btnDate.enabled = NO;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (IBAction)leftAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(MilestoneHeaderView_left)]) {
        [self.delegate MilestoneHeaderView_left];
    }
}

- (IBAction)rightAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(MilestoneHeaderView_right)]) {
        [self.delegate MilestoneHeaderView_right];
    }
}
- (IBAction)selectDateAction:(id)sender
{
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
#pragma mark - PortraitImageViewDelegate

- (void)PortraitImageView_changeImage:(PortraitImageView*)portraitImageView
{
    if ([self.delegate respondsToSelector:@selector(PortraitImageView_changeImage:)]) {
        [self.delegate PortraitImageView_changeImage:self];
    }
}
@end
