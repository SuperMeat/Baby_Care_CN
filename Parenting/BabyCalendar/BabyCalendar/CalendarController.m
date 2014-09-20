//
//  CalendarController.m
//  BabyCalendar
//
//  Created by Will on 14-5-18.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "CalendarController.h"
#import "CKCalendarView.h"

#import "CKCalendarEvent.h"

#import "NSCalendarCategories.h"

#import "CkCalendarTitleView.h"

#import "PWSCalendarView.h"

@interface CalendarController ()<PWSCalendarDelegate,CkCalendarTitleViewDelegate>

@property (nonatomic, strong) UISegmentedControl *modePicker;


@property (nonatomic,strong)CkCalendarTitleView* titleView;

@property(nonatomic,retain)PWSCalendarView* pWSCalendarView;

@end

@implementation CalendarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // [self setTitle:@"日历"];
        
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"日历页面"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"日历页面"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 标题日期
    _titleView = [[CkCalendarTitleView alloc] initWithFrame:CGRectMake(0, 0, 220, 44)];
    _titleView.delegate = self;
    _titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = _titleView;
    
    NSDateFormatter* ff = [[NSDateFormatter alloc] init];
    [ff setDateFormat:@"yyyy年MM月"];
    _titleView.labDate.text = [ff stringFromDate:[NSDate date]];
    
    // 日历
    _pWSCalendarView = [[PWSCalendarView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64) CalendarType:en_calendar_type_month];
    [_pWSCalendarView setDelegate:self];
    [self.view addSubview:_pWSCalendarView];
//    _pWSCalendarView.backgroundColor = [UIColor redColor];
    

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(todayAction)];
    [BaseSQL addDatas_test];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self refreshCalendarView];
    
    _pWSCalendarView.isResetFrame = YES;
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _pWSCalendarView.isResetFrame = NO;
}

- (void)refreshCalendarView
{
    // 刷新日历列表
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_SQLDatas object:nil];
    
    // 刷新日历
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_calendarView object:nil];
}

- (void)todayAction
{
    [_pWSCalendarView ScrollToToday];
}



#pragma mark - PWSCalendarView delegate
- (void) PWSCalendar:(PWSCalendarView*)_calendar didSelecteDate:(NSDate*)_date
{
    NSLog(@"select = %@", _date);
}

- (void) PWSCalendar:(PWSCalendarView*)_calendar didChangeViewHeight:(CGFloat)_height
{
    //    [m_view_bottom setFrame:CGRectMake(0, _height+50, kSCREEN_WIDTH, 4)];
//    [UIView animateWithDuration:.3f animations:^{
//        _tableView.top = _height;
//    }];
    
}

- (void) PWSCalendar:(PWSCalendarView*)_calendar titleDate:(NSDate*)date
{
    NSDateFormatter* ff = [[NSDateFormatter alloc] init];
    [ff setDateFormat:@"yyyy年MM月"];
    _titleView.labDate.text = [ff stringFromDate:date];
}

#pragma mark - CkCalendarTitleViewDelegate

- (void)forwardTapped
{

    _pWSCalendarView.m_current_page--;


}
- (void)backwardTapped
{

    _pWSCalendarView.m_current_page++;
    


}

@end
