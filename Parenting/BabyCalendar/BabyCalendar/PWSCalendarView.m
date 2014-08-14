//
//  PWSCalendarView.m
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////
#import "PWSCalendarView.h"
#import "PWSCalendarSegmentView.h"
#import "PWSCalendarViewCell.h"
#import "CalendarCell.h"

#import "CalendarModel.h"
#import "NoteController.h"
#import "TrainController.h"
#import "MilestoneController.h"
#import "VaccineController.h"
#import "TestController.h"
#import "TestModel.h"
#import "TestReportController.h"
#import "AddMilestoneController.h"
#import "BackTodayView.h"
#import "CKCalendarModel.h"

#import "NoteModel.h"
#import "MilestoneModel.h"
#import "VaccineModel.h"
#import "TrainModel.h"
#import "TestModel.h"

const float PWSCalendarTimeHeadViewHeight = 60;
//const float PWSCalendarDataHeadViewHeight = 60;
const float PWSCalendarSegmentHeight = 25;
const float PWSCalendarSeperateLineHeight= 0;
const float PWSCalendarWeekDaysHeight = 25;

extern NSString* PWSCalendarViewCellId;
const int   PWSCalendarViewNumber = 10000;
//////////////////////////////////////////////////////////////////////////////
@interface PWSCalendarView()
<PWSCalendarSegmentDelegate,
PWSCalendarDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,BackTodayViewDelegate>
{
    // data
    NSDate*            m_current_date;
    
    
    // head view
    UIView*            m_view_head;
    UILabel*           m_label_time;       // the label
    UIView*            m_time_head_view;   // the time view
    UIView*            m_data_head_view;   // the data view
    PWSCalendarSegmentView*  m_segment;
    UIView*            m_view_weekdays;
    
    
    UITableView* _tableView;
    BackTodayView* _backTodayView;
    UIImageView* _tableHeaderView;
    
    NSInteger _selectedRow;
    float _tableTop;
    
    BOOL isSelectedDate;
    

}

@property (nonatomic, retain) NSMutableArray* datas;

@property (nonatomic,retain)NSMutableArray* notes;
@property (nonatomic,retain)NSMutableArray* milestones;
@property (nonatomic,retain)NSMutableArray* vaccines;
@property (nonatomic,retain)NSMutableArray* trains;
@property (nonatomic,retain)NSMutableArray* tests;

@end
//////////////////////////////////////////////////////////////////////////////
@implementation PWSCalendarView

- (id) initWithFrame:(CGRect)frame
{
    id rt = [self initWithFrame:frame CalendarType:en_calendar_type_month];
    return rt;
}

- (id) initWithFrame:(CGRect)frame CalendarType:(enCalendarViewType)pType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.type = pType;
        self.headType = en_calendar_head_type_default;
        m_current_date = [NSDate date];
        [self SetInitialValue];
        
        [BaseMethod saveSelectedDate:m_current_date];
        
        // 数据
        self.datas = [NSMutableArray array];
        [self tableDatas];
        //
        
        [self reloadSQLDatas];
        
        _isResetFrame = YES;
        
        // 通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSQLDatas) name:kNotifi_reload_SQLDatas object:nil];
    }
    return self;
}



- (void)reloadSQLDatas
{
    self.notes = [BaseSQL queryData_note];
    self.milestones = [BaseSQL queryData_milestone];
    self.vaccines = [BaseSQL queryData_vaccine];
    self.trains = [BaseSQL queryData_train];
    self.tests = [BaseSQL queryData_test];
    
    [_tableView reloadData];
    [_m_view_calendar reloadData];
}
- (void)tableDatas
{
    NSArray* icons = @[@"icon_note",@"icon_ milestone",@"icon_ vaccine",@"icon_ training",@"icon_ measurement"/*,@"icon_setting"*/];
    NSArray* titles = @[@"日记",@"里程碑",@"疫苗",@"训练",@"测评"];
//    NSArray* details = @[@"",@"...",@"...",@"...",@"...",@"..."];
    for (int index = 0; index < icons.count; index++) {
        CalendarModel* model = [[CalendarModel alloc] init];
        model.iconName = icons[index];
        model.title = titles[index];
//        model.detail = details[index];
        [self.datas addObject:model];
    }
    
    [_tableView reloadData];
}

- (float) GetCalendarViewHeight
{
    PWSCalendarViewCell* the_cell = [[_m_view_calendar visibleCells] lastObject];
    float rt = the_cell.getCalendarHeight;
    rt += [self GetHeaderViewHeight];
    return rt;
}

- (void) setHeadType:(enCalendarViewHeaderViewType)headType
{
    _headType = headType;
    if (headType == en_calendar_head_type_default)
    {
        // if set to default, remove the custom views
        if (_customDataView)
        {
            [_customDataView removeFromSuperview];
        }
        if (_customTimeView)
        {
            [_customTimeView removeFromSuperview];
        }
        
    }
}


- (float) GetHeaderViewHeight
{
//    float rt = [self GetDataHeadViewHeight] + [self GetTimeHeadViewHeight];
    return 24;
}


- (void) SetInitialValue
{

    // 日期背景
    UIImageView* weekView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 24)];
    weekView.backgroundColor = [UIColor whiteColor];
    [weekView setImage:[UIImage imageNamed:@"calendar_headView"]];
    [self addSubview:weekView];
    
    // 日历
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:0];
    [layout setItemSize:CGSizeMake(width, height-[self GetHeaderViewHeight])];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _m_view_calendar = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, width, height-[self GetHeaderViewHeight]) collectionViewLayout:layout];
    [_m_view_calendar setShowsHorizontalScrollIndicator:NO];
    [_m_view_calendar setDelegate:self];
    [_m_view_calendar setDataSource:self];
    [_m_view_calendar setBackgroundColor:[UIColor clearColor]];
    [self insertSubview:_m_view_calendar belowSubview:weekView];
    _m_view_calendar.pagingEnabled = YES;
    
    [_m_view_calendar registerClass:[PWSCalendarViewCell class] forCellWithReuseIdentifier:PWSCalendarViewCellId.copy];
    
    _m_current_page = PWSCalendarViewNumber/2;
    NSIndexPath* mid_index = [NSIndexPath indexPathForRow:_m_current_page inSection:0];
    [_m_view_calendar scrollToItemAtIndexPath:mid_index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    [self SetLabelDate:[NSDate date]];
    
    // 列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64-24-45)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = UIColorFromRGB(kColor_baseView);

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self insertSubview:_tableView aboveSubview:_m_view_calendar];
    
    //
    _tableHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 8)];
    [_tableHeaderView setImage:[UIImage imageNamed:@"btn_arrow_up"]];
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _tableHeaderView;
    _tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    
    // 回到今天
    _backTodayView = [[[NSBundle mainBundle] loadNibNamed:@"BackTodayView" owner:self options:nil] lastObject];
    _backTodayView.delegate = self;
    [_backTodayView setHidden:YES];
    [self addSubview:_backTodayView];
    
    UIPanGestureRecognizer* tablePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tableUpGestureAction:)];
    [_tableView addGestureRecognizer:tablePan];
}


- (void) SetLabelDate:(NSDate*)_date
{
//    if ([self.delegate respondsToSelector:@selector(PWSCalendar:titleDate:)]) {
        [self.delegate PWSCalendar:self titleDate:_date];
//    }
}

#pragma mark - table tapped
- (void)tableUpGestureAction:(UIPanGestureRecognizer*)tap
{
    if (!isSelectedDate) {
        // 初始化选中的行数
        NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
        _selectedRow = [[userDef objectForKey:kTodayRow] integerValue];
    }
    
    
    CGPoint velocity = [tap velocityInView:_tableView];
    
    if (velocity.y < 0) { // 下
        // week
        [UIView animateWithDuration:.3f animations:^{
            _m_view_calendar.top = -(45*(_selectedRow/7-1))-24-2;
            _tableView.top = 24+45+2;
            _backTodayView.top = _tableView.top;
        }];
        
        [_tableHeaderView setImage:[UIImage imageNamed:@"btn_arrow_down"]];
        
    }else// 上
    {
        // month
        [self changeCalendarHeight];
        
        [_tableHeaderView setImage:[UIImage imageNamed:@"btn_arrow_up"]];

    }
    
}

- (PWSCalendarSegmentItem*) GetSegmentItemWithTitle:(NSString*)pTitle
{
    UILabel* label = [[UILabel alloc] init];
    [label setText:pTitle];
    [label setTextAlignment:NSTextAlignmentCenter];
    PWSCalendarSegmentItem* rt = [PWSCalendarSegmentItem CreateWithImage:nil HighLightedImage:nil Label:label LabelColor:[UIColor blackColor] LabelHighlightedColor:kPWSDefaultColor];
    return rt;
}



// collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return PWSCalendarViewNumber;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PWSCalendarViewCell* cell = [_m_view_calendar dequeueReusableCellWithReuseIdentifier:PWSCalendarViewCellId.copy forIndexPath:indexPath];
    
    NSDate* cell_date = m_current_date;
    
    if (indexPath.row != _m_current_page)
    {
        if (self.type == en_calendar_type_month)
        {
            if (indexPath.row > _m_current_page)
            {
                cell_date = [PWSHelper GetNextMonth:m_current_date];
            }
            else
            {
                cell_date = [PWSHelper GetPreviousMonth:m_current_date];
            }
        }
        else if (self.type == en_calendar_type_week)
        {
            if (indexPath.row > _m_current_page)
            {
                cell_date = [PWSHelper GetNextWeek:m_current_date];
            }
            else
            {
                cell_date = [PWSHelper GetPreviousWeek:m_current_date];
            }
        }
    }
    [cell setDelegate:self];
    [cell SetWithDate:cell_date ShowType:self.type];
    return cell;
}
/*
 BabyCalendar[1370:60b] ==========5000
 2014-08-09 14:25:19.341 BabyCalendar[1370:60b] ==========5000
 2014-08-09 14:25:26.399 BabyCalendar[1370:60b] 5000===5001
 */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    float cell_width = collectionView.frame.size.width;
    int pos_x = collectionView.contentOffset.x;
    int index = (pos_x+20)/cell_width;
    
    NSLog(@"%d===%d",_m_current_page,index);
    if (_m_current_page != index)
    {
        if (self.type == en_calendar_type_month)
        {
            if (_m_current_page > index)
            {
                m_current_date = [PWSHelper GetPreviousMonth:m_current_date];
            }
            else if (_m_current_page < index)
            {
                m_current_date = [PWSHelper GetNextMonth:m_current_date];
            }
            _m_current_page = index;
        }
//        else if (self.type == en_calendar_type_week)
//        {
//            if (_m_current_page > index)
//            {
//                m_current_date = [PWSHelper GetPreviousWeek:m_current_date];
//            }
//            else if (_m_current_page < index)
//            {
//                m_current_date = [PWSHelper GetNextWeek:m_current_date];
//            }
//            _m_current_page = index;
//        }
    }
    
    [self SetLabelDate:m_current_date];
    [self PWSCalendar:nil didChangeViewHeight:0];
}

- (void) ScrollToToday
{
    [_tableView setHidden:NO];
    [_backTodayView setHidden:YES];
    
    isSelectedDate = NO;
    
    NSDate* today = [NSDate date];
    if (self.type == en_calendar_type_month)
    {
        // max scroll 2 page
        if (![PWSHelper CheckSameMonth:today AnotherMonth:m_current_date])
        {
            int scroll_pages = 0;
//            NSComparisonResult result = [today compare:m_current_date];
//            if (result == NSOrderedDescending)
//            {
//                if ([PWSHelper CheckThisMonth:m_current_date NextMonth:today])
//                {
//                    scroll_pages = 1;
//                    m_current_date = [PWSHelper GetPreviousMonth:today];
//                }
//                else
//                {
//                    scroll_pages = 2;
//                    m_current_date = [PWSHelper GetPreviousMonth:today];
//                    m_current_date = [PWSHelper GetPreviousMonth:m_current_date];
//                }
//            }
//            else if (result == NSOrderedAscending)
//            {
//                if ([PWSHelper CheckThisMonth:today NextMonth:m_current_date])
//                {
                    scroll_pages = -1;
                    m_current_date = [PWSHelper GetNextMonth:today];
//                }
//                else
//                {
//                    scroll_pages = -2;
//                    m_current_date = [PWSHelper GetNextMonth:today];
//                    m_current_date = [PWSHelper GetNextMonth:m_current_date];
//                }
//            }
            
            NSIndexPath* indexpath = [NSIndexPath indexPathForRow:_m_current_page+scroll_pages inSection:0];
            [_m_view_calendar scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
    else if (self.type == en_calendar_type_week)
    {
        if (![PWSHelper CheckSameWeek:m_current_date AnotherWeek:today])
        {
            int scroll_pages = 0;
//            NSComparisonResult result = [today compare:m_current_date];
//            if (result == NSOrderedDescending)
//            {
//                if ([PWSHelper CheckThisWeek:m_current_date NextWeek:today])
//                {
//                    scroll_pages = 1;
//                    m_current_date = [PWSHelper GetPreviousWeek:today];
//                }
//                else
//                {
//                    scroll_pages = 2;
//                    m_current_date = [PWSHelper GetPreviousWeek:today];
//                    m_current_date = [PWSHelper GetPreviousWeek:m_current_date];
//                }
//            }
//            else if (result == NSOrderedAscending)
//            {
//                if ([PWSHelper CheckThisWeek:today NextWeek:m_current_date])
//                {
                    scroll_pages = -1;
                    m_current_date = [PWSHelper GetNextWeek:today];
//                }
//                else
//                {
//                    scroll_pages = -2;
//                    m_current_date = [PWSHelper GetNextWeek:today];
//                    m_current_date = [PWSHelper GetNextWeek:m_current_date];
//                }
//            }
            
            NSIndexPath* indexpath = [NSIndexPath indexPathForRow:_m_current_page+scroll_pages inSection:0];
            [_m_view_calendar scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
    
     [BaseMethod saveSelectedDate:today];
    [_tableView reloadData];
//
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_calendarView object:nil];

    
}


// calendar delegate
- (void) PWSCalendar:(PWSCalendarView*)_calendar didSelecteDate:(NSDate*)_date atIndexPath:(NSIndexPath*)indexPath
{

    isSelectedDate = YES;
    
    _selectedRow = indexPath.row;
    
    [BaseMethod saveSelectedDate:_date];
    
    m_current_date = _date;
    [self SetLabelDate:_date];
    
    if ([self.delegate respondsToSelector:@selector(PWSCalendar:didSelecteDate:atIndexPath:)])
    {
        [self.delegate PWSCalendar:self didSelecteDate:_date atIndexPath:indexPath];
    }
    
    
    [self futureDate:_date];
    
    [_tableView reloadData];
    
    
    
}

- (void)futureDate:(NSDate*)selectedDate
{
    NSDate* todayDate         = [NSDate date];
    NSString* selectedDateStr = [BaseMethod stringFromDate:selectedDate];
    NSString* todayDateStr    = [BaseMethod stringFromDate:todayDate];
    selectedDate = [BaseMethod dateFormString:selectedDateStr];
    todayDate = [BaseMethod dateFormString:todayDateStr];
    int days = [BaseMethod fromStartDate:todayDate withEndDate:selectedDate];
    
    NSDate* birthDate   = [BaseMethod dateFormString:kBirthday];
    int before_birthday = [BaseMethod fromStartDate:selectedDate withEndDate:birthDate];
    if (days > 0 || before_birthday > 0) {
        _tableView.hidden = YES;
        _backTodayView.hidden = NO;
        if (days > 0) {
            _backTodayView.infoLab.text = @"日子还没到来呢！";
        }
        if (before_birthday > 0) {
            _backTodayView.infoLab.text = @"宝宝还没出生呢！";
        }
    }else
    {
        _tableView.hidden = NO;
        _backTodayView.hidden = YES;
    }

}

- (void) PWSCalendar:(PWSCalendarView *)_calendar didChangeViewHeight:(CGFloat)_height
{
    NSLog(@"==========%d",_m_current_page);
    if (_isResetFrame) {
        [self changeCalendarHeight];
    }
    
}

- (void)setM_current_page:(int)m_current_page
{
    if (_m_current_page > m_current_page) {
        _m_current_page++;
        NSIndexPath* indexpath = [NSIndexPath indexPathForRow:_m_current_page inSection:0];
        [_m_view_calendar scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }else if(_m_current_page < m_current_page)
    {
        _m_current_page--;
        NSIndexPath* indexpath = [NSIndexPath indexPathForRow:_m_current_page inSection:0];
        [_m_view_calendar scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
    

    _m_current_page = m_current_page;
    


}
- (void)changeCalendarHeight
{
    float height = [self GetCalendarViewHeight];
    
    [UIView animateWithDuration:.3f animations:^{
        
        _m_view_calendar.top = 20;
        _tableView.top = height-3;
        _backTodayView.top = height-3;
    }];
    
    
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"CalendarCell";
    CalendarCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CalendarCell" owner:self options:nil] lastObject];
    }
    
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSString* date = [userDef objectForKey:kSelectedDate];
    
    cell.row = indexPath.row;
    cell.ckModel = [self eventsFromSQLWtihDate:date];
    cell.model = self.datas[indexPath.row];

    return cell;
}
-(void)tableView:(UITableView*)tableView  willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [cell setBackgroundColor:UIColorFromRGB(kColor_baseView)];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController* vc = [BaseMethod baseViewController:_tableView];
    // 宝宝日记
    if (indexPath.row == 0) {
        NoteController* noteVc = [[NoteController alloc] init];
        [vc.navigationController pushViewController:noteVc animated:YES];
    }
    // 里程碑
    if (indexPath.row == 1) {
        
        // 创建数据库
        [BaseSQL createTable_milestone];
        // 获取数据库数据
        NSArray* milestoneDatas_sql = [BaseSQL queryData_milestone];

        // 过滤获取已经完成的里程碑
        BOOL completed = NO;
        for (MilestoneModel* model in milestoneDatas_sql) {
            if ([model.completed boolValue]) {
                NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
                NSString* selectedDateStr = [userDef objectForKey:kSelectedDate];
                if ([model.date isEqualToString:selectedDateStr]) {
                    completed = YES;
                    break;
                }
               
            }
        }
        //是否有已完成的里程碑
        if (!completed) {

            AddMilestoneController* addVc = [[AddMilestoneController alloc] init];
            [vc.navigationController pushViewController:addVc animated:YES];
            
        }else
        {
            MilestoneController* milestoneVc = [[MilestoneController alloc] init];
            [vc.navigationController pushViewController:milestoneVc animated:YES];
        }
        
        
       
    }
    // 疫苗
    if (indexPath.row == 2) {
        VaccineController* vaccineVc = [[VaccineController alloc] init];
        [vc.navigationController pushViewController:vaccineVc animated:YES];
    }
    // 训练
    if (indexPath.row == 3) {
        TrainController* trainVc = [[TrainController alloc] init];
        [vc.navigationController pushViewController:trainVc animated:YES];
    }
    // 测评
    if (indexPath.row == 4) {
        
        NSDate* birthDate = [BaseMethod dateFormString:kBirthday];
        NSDate* selectedDate = [BaseMethod beijingDate:m_current_date];
        
        int days = [BaseMethod fromStartDate:birthDate withEndDate:selectedDate];
        int month = days/30; // 第几个月
        
        NSArray* tests = [BaseSQL queryData_test];
        
        NSLog(@"====%d",month);
        
        if (month < [BaseMethod month_test]) {
            
            TestModel* model = tests[month];
            if ([model.completed boolValue]) {
                TestReportController* reportVc = [[TestReportController alloc] init];
                reportVc.month = month;
                [vc.navigationController pushViewController:reportVc animated:YES];
            }else
            {
                TestController* testVc = [[TestController alloc] init];
                testVc.month = month;
                [vc.navigationController pushViewController:testVc animated:YES];
            }
            
        }else
        {
            [self alertView:@"暂无该月份的测评题"];
        }
    }
}

#pragma mark - BackToday delegate
- (void)backTodayViewDidBackToday
{
    
    [self ScrollToToday];
}

- (CKCalendarModel*)eventsFromSQLWtihDate:(NSString*)dateStr
{
    CKCalendarModel* model = [[CKCalendarModel alloc] init];
    
    for (NoteModel* n_model in self.notes) {
        if ([n_model.date isEqualToString:dateStr]) {
            model.noteModel = n_model;
        }
    }
    
    for (MilestoneModel* m_model in self.milestones) {
        if ([m_model.date isEqualToString:dateStr]) {
            model.milestone = [NSNumber numberWithBool:YES];
            model.milestoneModel = m_model;
        }
    }
    
    int vaccineNum = 0;
    
    for (VaccineModel* v_model in self.vaccines) {
        if ([v_model.completedDate isEqualToString:dateStr] && [v_model.completed boolValue]) {
            model.vaccine = [NSNumber numberWithBool:YES];
            model.vaccineModel = v_model;
            vaccineNum++;
            model.vaccineNum = vaccineNum;
        }
    }
    for (TrainModel* t_model in self.trains) {
        if ([t_model.date isEqualToString:dateStr]) {
            model.train = [NSNumber numberWithBool:YES];
            
        }
    }
    for (TestModel* t_model in self.tests) {
        NSDate* birthDate = [BaseMethod dateFormString:kBirthday];
        NSDate* testDate = [BaseMethod dateFormString:t_model.date];
        NSDate* selectedDate = [BaseMethod dateFormString:dateStr];
        
        
        int days_bith_test =  [BaseMethod fromStartDate:birthDate withEndDate:testDate]/30;
        
        int days_bith_selected = [BaseMethod fromStartDate:birthDate withEndDate:selectedDate]/30;
        
        if (days_bith_test == days_bith_selected) {
            model.test = [NSNumber numberWithBool:YES];
            model.testModel = t_model;
        }
        
    }
    
    return model;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
