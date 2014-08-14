//
//  PWSCalendarDayCell.m
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//
////////////////////////////////////////////////////////////////////////
#import "PWSCalendarDayCell.h"
#import "PWSHelper.h"
#import "CKCalendarModel.h"
////////////////////////////////////////////////////////////////////////
const NSString* PWSCalendarDayCellId = @"PWSCalendarDayCellId";
////////////////////////////////////////////////////////////////////////
@interface PWSCalendarDayCell()
{
    UILabel* m_date;
}
@property (nonatomic, strong) NSDate* p_date;

@property (nonatomic,retain)UIImageView* noteView;
@property (nonatomic,retain)UIImageView* milestoneView;
@property (nonatomic,retain)UIImageView* vaccineView;
@property (nonatomic,retain)UIImageView* trainView;
@property (nonatomic,retain)UIImageView* testView;
@end
////////////////////////////////////////////////////////////////////////
@implementation PWSCalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self SetInitialValue];
    }
    return self;
}

- (void) SetInitialValue
{
    
    self.layer.borderColor = UIColorFromRGB(kColor_cal_selectedDate).CGColor;
    
    m_date = [[UILabel alloc] init];
    [m_date setText:@""];
    [m_date setTextAlignment:NSTextAlignmentCenter];
    m_date.font = [UIFont fontWithName:@"Arial" size:18.f];
    
    _noteView = [[UIImageView alloc] init];
    [_noteView setImage:[UIImage imageNamed:@"icon_note"]];
    
    _milestoneView = [[UIImageView alloc] init];
    [_milestoneView setImage:[UIImage imageNamed:@"icon_milestone"]];
    
    _vaccineView = [[UIImageView alloc] init];
    [_vaccineView setImage:[UIImage imageNamed:@"icon_vaccine"]];
    
    _trainView = [[UIImageView alloc] init];
    [_trainView setImage:[UIImage imageNamed:@"icon_train"]];
    
    _testView = [[UIImageView alloc] init];
    [_testView setImage:[UIImage imageNamed:@"icon_test"]];
    

    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    NSString* day = @"";
    
    self.p_date = _date;
    if (_date)
    {
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:_date];
        day = [NSString stringWithFormat:@"%@", @(dateComponents.day)];
    }
    
    if ([PWSHelper CheckSameDay:_date AnotherDate:[NSDate date]])
    {
        [m_date setTextColor:UIColorFromRGB(kColor_cal_today)];
        NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:[NSNumber numberWithInt:_todayRow] forKey:kTodayRow];
        [userDef synchronize];
        
    }
    else
    {
        [m_date setTextColor:UIColorFromRGB(kColor_calendarDay_num)];
    }
    
    [m_date setText:day];
    
    //
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSString* selectedDateStr = [userDef objectForKey:kSelectedDate];
    
    NSString* p_dateStr = [BaseMethod stringFromDate:_date];
    if ([p_dateStr isEqualToString:selectedDateStr]) {
        self.layer.borderWidth = 1.5f;
    }else
    {
        self.layer.borderWidth = 0;
    }
    
}


- (void)setModel:(CKCalendarModel *)model
{
    _model = model;
    
    if (_date == nil) {
        _noteView.hidden = YES;
        _milestoneView.hidden = YES;
        _vaccineView.hidden = YES;
        _trainView.hidden = YES;
        _testView.hidden = YES;
        return;
    }
    
    _noteView.hidden = _model.noteModel == nil ? YES : NO;
    _milestoneView.hidden = _model.milestoneModel == nil ? YES : NO;
    _vaccineView.hidden = _model.vaccineModel == nil ? YES : NO;
    _trainView.hidden = [_model.train boolValue]?NO:YES;
    _testView.hidden = _model.testModel == nil ? YES:NO;
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    m_date.frame = CGRectMake(5, 5, self.width/2, self.height/2);
    
    float width = 12.f;
    float height = 12.f;
    
    
    _noteView.frame = CGRectMake(30, 3, width, height);
    _vaccineView.frame =CGRectMake(30, 18, width, height);
    _milestoneView.frame = CGRectMake(30, 30, width, height);
    _trainView.frame = CGRectMake(16, 30, width, height);
    _testView.frame = CGRectMake(2, 30, width, height);
    
    
    
    [self addSubview:m_date];
    [self addSubview:_noteView];
    [self addSubview:_milestoneView];
    [self addSubview:_vaccineView];
    [self addSubview:_trainView];
    [self addSubview:_testView];
}
@end
