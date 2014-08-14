//
//  CKCalendarCalendarView.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarView.h"

//  Auxiliary Views
#import "CKCalendarHeaderView.h"
#import "CKCalendarCell.h"

#import "NSCalendarCategories.h"
#import "NSDate+Description.h"
#import "UIView+AnimatedFrame.h"

#import <QuartzCore/QuartzCore.h>
#import "CalendarCell.h"
#import "CalendarModel.h"
#import "NoteController.h"
#import "TrainController.h"
#import "MilestoneController.h"
#import "VaccineController.h"
#import "TestController.h"
#import "TestModel.h"
#import "TestReportController.h"
#import "BackTodayView.h"
#import "CKCalendarModel.h"

#import "NoteModel.h"
#import "MilestoneModel.h"
#import "VaccineModel.h"
#import "TrainModel.h"
#import "TestModel.h"

@interface CKCalendarView () <CKCalendarHeaderViewDataSource, CKCalendarHeaderViewDelegate,BackTodayViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableSet* spareCells;
@property (nonatomic, strong) NSMutableSet* usedCells;

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong) CKCalendarHeaderView *headerView;

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic,retain)BackTodayView* backTodayView;

//  The index of the highlighted cell
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer* leftGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer* rightGesture;
@property (nonatomic, strong) UIView *wrapper;
@property (nonatomic, strong) NSDate *previousDate;
@property (nonatomic, assign) BOOL isAnimating;


@property (nonatomic, retain) NSMutableArray* datas;

@property (nonatomic,retain)NSMutableArray* notes;
@property (nonatomic,retain)NSMutableArray* milestones;
@property (nonatomic,retain)NSMutableArray* vaccines;
@property (nonatomic,retain)NSMutableArray* trains;
@property (nonatomic,retain)NSMutableArray* tests;

@end

@implementation CKCalendarView

#pragma mark - Initializers

// Designated Initializer
- (id)init
{
    self = [super init];
    
    if (self) {
        _locale = [NSLocale currentLocale];
        _calendar = [NSCalendar currentCalendar];
        [_calendar setLocale:_locale];
        _timeZone = nil;
        _date = [NSDate date];
        _displayMode = CKCalendarViewModeMonth;
        _spareCells = [NSMutableSet new];
        _usedCells = [NSMutableSet new];
        _selectedIndex = [_calendar daysFromDate:[self _firstVisibleDateForDisplayMode:_displayMode] toDate:_date];
        
        [BaseMethod saveSelectedDate:_date];
        
        

        //  Events for selected date
        _events = [NSMutableArray new];
        
        //  Used for animation
        _previousDate = [NSDate date];
        _wrapper = [UIView new];
        _isAnimating = NO;
        
        //  Date bounds
        _minimumDate = nil;
        _maximumDate = nil;
        
       
        
        //  Accessory Table
        _table = [UITableView new];
        [_table setDelegate:self];
        [_table setDataSource:self];
        _table.width = kDeviceWidth;
        _table.height = kDeviceHeight-64-64-49;
        
        // 回到今天
        _backTodayView = [[[NSBundle mainBundle] loadNibNamed:@"BackTodayView" owner:self options:nil] lastObject];
        _backTodayView.delegate = self;
        [_backTodayView setHidden:YES];
        
        // 手势
        _leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(forwardTapped)];
        _leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:_leftGesture];
        
        _rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backwardTapped)];
        _rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_rightGesture];
        
        UIPanGestureRecognizer* tablePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tableUpGestureAction:)];
        [self.table addGestureRecognizer:tablePan];
        
        // 数据
        self.datas = [NSMutableArray array];
        [self tableDatas];
        
        
        //
        
        [self reloadSQLDatas];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSQLDatas) name:kNotifi_reload_SQLDatas object:nil];
    }
    return self;
}

- (id)initWithMode:(CKCalendarDisplayMode)CalendarDisplayMode
{
    self = [self init];
    if (self) {
        _displayMode = CalendarDisplayMode;
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
}
- (void)tableDatas
{
    NSArray* icons = @[@"icon_note",@"icon_ milestone",@"icon_ vaccine",@"icon_ training",@"icon_ measurement",@"icon_setting"];
    NSArray* titles = @[@"日记",@"里程碑",@"疫苗",@"训练",@"测评",@"设置"];
//    NSArray* details = @[@"",@"...",@"...",@"...",@"...",@"..."];
    for (int index = 0; index < icons.count; index++) {
        CalendarModel* model = [[CalendarModel alloc] init];
        model.iconName = icons[index];
        model.title = titles[index];
//        model.detail = details[index];
        [self.datas addObject:model];
    }
    
    [_table reloadData];
}
#pragma mark - table tapped
- (void)tableUpGestureAction:(UIPanGestureRecognizer*)tap
{
    
    CGPoint velocity = [tap velocityInView:self.superview];
    
    if (velocity.y > 0) { // 下

//        [self setDisplayMode:CKCalendarViewModeMonth animated:YES];
        [self setDisplayMode_table:CKCalendarViewModeMonth animated:YES];
        
    }else// 上
    {
        [self setDisplayMode_table:CKCalendarViewModeWeek animated:YES];
//        [self setDisplayMode:CKCalendarViewModeWeek animated:YES];
        

    }

}
#pragma mark - Reload

- (void)reload
{
    [self reloadAnimated:NO];
}

- (void)reloadAnimated:(BOOL)animated
{
    if ([[self dataSource] respondsToSelector:@selector(calendarView:eventsForDate:)]) {
        NSArray *sortedArray = [[[self dataSource] calendarView:self eventsForDate:[self date]] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDate *d1 = [obj1 date];
            NSDate *d2 = [obj2 date];
            
            return [d1 compare:d2];
        }];
        
        [self setEvents:sortedArray];
    }
    
    [[self table] reloadData];
    
    [self layoutSubviewsAnimated:animated];
}

#pragma mark - View Hierarchy

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [[self layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [[self layer] setShadowOffset:CGSizeMake(0, 3)];
    [[self layer] setShadowOpacity:1.0];
    
    [self reloadAnimated:NO];
    
    [super willMoveToSuperview:newSuperview];
}

-(void)removeFromSuperview
{
    for (CKCalendarCell *cell in [self usedCells]) {
        [cell removeFromSuperview];
    }
    
    [[self headerView] removeFromSuperview];
    
    [super removeFromSuperview];
}

#pragma mark - Size


- (CGRect)_rectForCellsForDisplayMode:(CKCalendarDisplayMode)displayMode
{
    CGSize cellSize = [self _cellSize];
    
    if (displayMode == CKCalendarViewModeDay) {
        return CGRectZero;
    }
    else if(displayMode == CKCalendarViewModeWeek)
    {
        NSUInteger daysPerWeek = [[self calendar] daysPerWeekUsingReferenceDate:[self date]];
        return CGRectMake(0, 0, (CGFloat)daysPerWeek*cellSize.width, cellSize.height+24);
    }
    else if(displayMode == CKCalendarViewModeMonth)
    {
        CGFloat width = (CGFloat)[self _columnCountForDisplayMode:CKCalendarViewModeMonth] * cellSize.width;
        CGFloat height = (CGFloat)[self _rowCountForDisplayMode:CKCalendarViewModeMonth] * cellSize.height;
        return CGRectMake(0, 0, width, height+24);
    }
    return CGRectZero;
}

- (CGSize)_cellSize
{
    return CGSizeMake(46, 44);
}

#pragma mark - Layout

- (void)layoutSubviews
{
    self.width = kDeviceWidth;
    self.height = kDeviceHeight-64-49-20;
    
    [self layoutSubviewsAnimated:NO];
    
    [_table reloadData];
    
}

- (void)layoutSubviewsAnimated:(BOOL)animated
{
    
    [self addSubview:_backTodayView];
    
    /* Show the cells */
   
    [self _layoutCellsAnimated:animated];

    
    /* Install the header */
    _headerView = [CKCalendarHeaderView new];
    CKCalendarHeaderView *header = [self headerView];
    
    CGRect headerFrame = CGRectMake(0, 0, kDeviceWidth, 24);
    [header setFrame:headerFrame];
    [header setDelegate:self];
    [header setDataSource:self];
    [self addSubview:[self headerView]];
    /* Install a wrapper */
    
    _wrapper.width = kDeviceWidth;
    self.wrapper.top = 0;
    [[self wrapper] setClipsToBounds:YES];
    [self insertSubview:_wrapper belowSubview:_headerView];
    
    
    // 设置列表位置
    [self insertSubview:_table aboveSubview:_wrapper];
    
//    if (!_isUp) {
        [UIView animateWithDuration:.3f animations:^{
            self.table.top = _wrapper.bottom;
            _backTodayView.top = _wrapper.bottom;
        }];
        
//    }
    
    
}



- (void)_layoutCells
{
    [self _layoutCellsAnimated:YES];
}

- (void)_layoutCellsAnimated:(BOOL)animated
{
    
    if ([self isAnimating]) {
        return;
    }
    
    [self setIsAnimating:YES];
    
    NSMutableSet *cellsToRemoveAfterAnimation = [NSMutableSet setWithSet:[self usedCells]];
    NSMutableSet *cellsBeingAnimatedIntoView = [NSMutableSet new];
    
    /* Calculate the pre-animation offset */
    
//    CGFloat yOffset = 0;

    CGFloat xOffset = 0;
    
    BOOL isDifferentMonth = ![[self calendar] date:[self date] isSameMonthAs:[self previousDate]];
    BOOL isNextMonth = isDifferentMonth && ([[self date] timeIntervalSinceDate:[self previousDate]] > 0);
    BOOL isPreviousMonth = isDifferentMonth && (!isNextMonth);
    
    // If the next month is about to be shown, we want to add the new cells at the bottom of the calendar
    if (isNextMonth) {
//        yOffset = [self _rectForCellsForDisplayMode:[self displayMode]].size.height - [self _cellSize].height;
        xOffset = 320;

       
    }
    
    //  If we're showing the previous month, add the cells at the top
    else if(isPreviousMonth)
    {
//        yOffset = -([self _rectForCellsForDisplayMode:[self displayMode]].size.height) + [self _cellSize].height;
        
        xOffset = -320;

      
    }
    
    else if ([[self calendar] date:[self previousDate] isSameDayAs:[self date]])
    {
//        yOffset = 0;
        xOffset = 0;
  
    }
    
    //  Count the rows and columns that we'll need
    NSUInteger rowCount = [self _rowCountForDisplayMode:[self displayMode]];
    NSUInteger columnCount = [self _columnCountForDisplayMode:[self displayMode]];

    //  Cache the cell values for easier readability below
    CGFloat width = [self _cellSize].width;
    CGFloat height = [self _cellSize].height;
    
    //  Cache the start date & header offset
    NSDate *workingDate = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    
//    CGFloat headerOffset = [[self headerView] frame].size.height;

    //  A working index...
    NSUInteger cellIndex = 0;
    
    for (NSUInteger row = 0; row < rowCount; row++) {
        for (NSUInteger column = 0; column < columnCount; column++) {
            
            /* STEP 1: create and position the cell */
            
            CKCalendarCell *cell = [self _dequeueCell:workingDate];
            
            CGRect frame = CGRectMake(column*width+xOffset, row*height+24, width, height);
  
            [cell setFrame:frame];
            
            // 2
            
            BOOL cellRepresentsToday = [[self calendar] date:workingDate isSameDayAs:[NSDate date]];
            BOOL isThisMonth = [[self calendar] date:workingDate isSameMonthAs:[self date]];
            BOOL isInRange = [self _dateIsBetweenMinimumAndMaximumDates:workingDate];
            isInRange = isInRange || [[self calendar] date:workingDate isSameDayAs:[self minimumDate]];
            isInRange = isInRange || [[self calendar] date:workingDate isSameDayAs:[self maximumDate]];
            
            // 3
            if (cellRepresentsToday && isThisMonth && isInRange) {
                [cell setState:CKCalendarMonthCellStateTodayDeselected];
            }
            else if(!isInRange)
            {
                [cell setOutOfRange];
            }
            else if (!isThisMonth) {
                [cell setState:CKCalendarMonthCellStateInactive];
            }
            else
            {
                [cell setState:CKCalendarMonthCellStateNormal];
            }
            
            /* STEP 4: Show the day of the month in the cell. */
            
            NSUInteger day = [[self calendar] daysInDate:workingDate];
            [cell setNumber:@(day)];
            
            
            /* STEP 5: Show event dots */
            
            if([[self dataSource] respondsToSelector:@selector(calendarView:eventsForDate:)])
            {
                BOOL showDot = ([[[self dataSource] calendarView:self eventsForDate:workingDate] count] > 0);
                [cell setShowDot:showDot];
            }
            else
            {
                [cell setShowDot:NO];
            }
            
            /* STEP 6: Set the index */
            [cell setIndex:cellIndex];
            
            if (cellIndex == [self selectedIndex]) {
                [cell setSelected];
            }
            
            /* Step 7: Prepare the cell for animation */
            [cellsBeingAnimatedIntoView addObject:cell];
            
            /* STEP 8: Install the cell in the view hierarchy. */
            _wrapper.height = (row+1)*height+24;
            [[self wrapper] insertSubview:cell belowSubview:[self headerView]];
            
            /* STEP 9: Move to the next date before we continue iterating. */
            
            workingDate = [[self calendar] dateByAddingDays:1 toDate:workingDate];
            cellIndex++;
        }
    }
    
    /* Perform the animation */
    
    if (animated) {
        [UIView
         animateWithDuration:.4
         animations:^{
             
             [self _moveCellsIntoView:cellsBeingAnimatedIntoView andCellsOutOfView:cellsToRemoveAfterAnimation usingOffset:xOffset];
             
         }
         completion:^(BOOL finished) {
             
             [self _cleanupCells:cellsToRemoveAfterAnimation];
             [cellsBeingAnimatedIntoView removeAllObjects];
             [self setIsAnimating:NO];
         }];
    }
    else
    {
        [self _moveCellsIntoView:cellsBeingAnimatedIntoView andCellsOutOfView:cellsToRemoveAfterAnimation usingOffset:xOffset];
        [self _cleanupCells:cellsToRemoveAfterAnimation];
        [cellsBeingAnimatedIntoView removeAllObjects];
        [self setIsAnimating:NO];        
    }
    
    
}

#pragma mark - Cell Animation

- (void)_moveCellsIntoView:(NSMutableSet *)cellsBeingAnimatedIntoView andCellsOutOfView:(NSMutableSet *)cellsToRemoveAfterAnimation usingOffset:(CGFloat)xOffset
{
    for (CKCalendarCell *cell in cellsBeingAnimatedIntoView) {
        CGRect frame = [cell frame];
        frame.origin.x -= xOffset;
        [cell setFrame:frame];
    }
    for (CKCalendarCell *cell in cellsToRemoveAfterAnimation) {
        CGRect frame = [cell frame];
        frame.origin.x -= xOffset;
        [cell setFrame:frame];
    }
}

- (void)_cleanupCells:(NSMutableSet *)cellsToCleanup
{
    for (CKCalendarCell *cell in cellsToCleanup) {
        [self _moveCellFromUsedToSpare:cell];
        [cell removeFromSuperview];
    }
    
    [cellsToCleanup removeAllObjects];
}

- (CKCalendarModel*)eventsFromSQLWtihDate:(NSString*)date
{
    CKCalendarModel* model = [[CKCalendarModel alloc] init];

    for (NoteModel* n_model in self.notes) {
        if ([n_model.date isEqualToString:date]) {
            model.noteModel = n_model;
        }
    }
    
    for (MilestoneModel* m_model in self.milestones) {
        if ([m_model.date isEqualToString:date]) {
            model.milestone = [NSNumber numberWithBool:YES];
            model.milestoneModel = m_model;
        }
    }
    for (VaccineModel* v_model in self.vaccines) {
        if ([v_model.completedDate isEqualToString:date] && [v_model.completed boolValue]) {
            model.vaccine = [NSNumber numberWithBool:YES];
            model.vaccineModel = v_model;
        }
    }
    for (TrainModel* t_model in self.trains) {
        if ([t_model.date isEqualToString:date]) {
            model.train = [NSNumber numberWithBool:YES];
            
        }
    }
    for (TestModel* t_model in self.tests) {
        if ([t_model.date isEqualToString:date]) {
            model.test = [NSNumber numberWithBool:YES];
            model.testModel = t_model;
        }
    }
    
    return model;
}
#pragma mark - Cell Recycling

- (CKCalendarCell *)_dequeueCell:(NSDate*)workingDate
{
    CKCalendarCell *cell = [[self spareCells] anyObject];
    
    if (!cell) {
        cell = [[CKCalendarCell alloc] initWithSize:[self _cellSize]];
    }

    NSString* workingDateStr = [BaseMethod stringFromDate:workingDate];

    cell.model = [self eventsFromSQLWtihDate:workingDateStr];
    
    [self _moveCellFromSpareToUsed:cell];
    
    [cell prepareForReuse];
    
    return cell;
}

- (void)_moveCellFromSpareToUsed:(CKCalendarCell *)cell
{
    //  Move the used cells to the appropriate set
    [[self usedCells] addObject:cell];
    
    if ([[self spareCells] containsObject:cell]) {
        [[self spareCells] removeObject:cell];
    }
}

- (void)_moveCellFromUsedToSpare:(CKCalendarCell *)cell
{
    //  Move the used cells to the appropriate set
    [[self spareCells] addObject:cell];
    
    if ([[self usedCells] containsObject:cell]) {
        [[self usedCells] removeObject:cell];
    }
}


#pragma mark - Setters

- (void)setCalendar:(NSCalendar *)calendar
{
    [self setCalendar:calendar animated:NO];
}

- (void)setCalendar:(NSCalendar *)calendar animated:(BOOL)animated
{
    if (calendar == nil) {
        calendar = [NSCalendar currentCalendar];
    }
    
    _calendar = calendar;
    [_calendar setLocale:_locale];
    
    [self layoutSubviews];
}

- (void)setLocale:(NSLocale *)locale
{
    [self setLocale:locale animated:NO];
}

- (void)setLocale:(NSLocale *)locale animated:(BOOL)animated
{
    if (locale == nil) {
        locale = [NSLocale currentLocale];
    }
    
    _locale = locale;
    [[self calendar] setLocale:locale];
    
    [self layoutSubviews];
}

- (void)setTimeZone:(NSTimeZone *)timeZone
{
    [self setTimeZone:timeZone animated:NO];
}

- (void)setTimeZone:(NSTimeZone *)timeZone animated:(BOOL)animated
{
    if (!timeZone) {
        timeZone = [NSTimeZone localTimeZone];
    }
    
    [[self calendar] setTimeZone:timeZone];
    
    [self layoutSubviewsAnimated:animated];
}

- (void)setDisplayMode:(CKCalendarDisplayMode)displayMode
{
    [self setDisplayMode:displayMode animated:YES];
}

- (void)setDisplayMode:(CKCalendarDisplayMode)displayMode animated:(BOOL)animated
{
    _displayMode = displayMode;
    _previousDate = _date;
    
    //  Update the index, so that we don't lose selection between mode changes
    NSInteger newIndex = [[self calendar] daysFromDate:[self _firstVisibleDateForDisplayMode:displayMode] toDate:[self date]];
  

    [self setSelectedIndex:newIndex];
    
    [self layoutSubviewsAnimated:animated];
}

- (void)setDisplayMode_table:(CKCalendarDisplayMode)displayMode animated:(BOOL)animated
{
//    _displayMode = displayMode;
    _previousDate = _date;
    
    //  Update the index, so that we don't lose selection between mode changes
//    NSInteger newIndex = [[self calendar] daysFromDate:[self _firstVisibleDateForDisplayMode:displayMode] toDate:[self date]];
//    
//    NSLog(@"newIndex:%d",newIndex);
//    
//    [self setSelectedIndex:newIndex];
    
    if (displayMode == CKCalendarViewModeMonth) {
        _isUp = NO;
        [UIView animateWithDuration:.3f animations:^{
            _table.top = _wrapper.bottom;
            _wrapper.top = 0;
        }];
    }else if(displayMode == CKCalendarViewModeWeek)
    {
        _isUp = YES;
        [UIView animateWithDuration:.3f animations:^{
            _table.top = 68.0f;
            
            // 日历
            NSInteger row = [self rowFromDate];
            _wrapper.top = -row*[self _cellSize].height;
        }];
    }
}



- (void)setDate:(NSDate *)date
{
    
    [self setDate:date animated:NO];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    NSLog(@"===%@",date);
    
    if (!date) {
        date = [NSDate date];
    }
    
    [BaseMethod saveSelectedDate:date];

    
    BOOL minimumIsBeforeMaximum = [self _minimumDateIsBeforeMaximumDate];
    
    if (minimumIsBeforeMaximum) {
        
        if ([self _dateIsBeforeMinimumDate:date]) {
            date = [self minimumDate];
        }
        else if([self _dateIsAfterMaximumDate:date])
        {
            date = [self maximumDate];
        }
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:willSelectDate:)]) {
        [[self delegate] calendarView:self willSelectDate:date];
    }
    
    _previousDate = _date;
    _date = date;
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [[self delegate] calendarView:self didSelectDate:date];
    }
    
    if ([[self dataSource] respondsToSelector:@selector(calendarView:eventsForDate:)]) {
        [self setEvents:[[self dataSource] calendarView:self eventsForDate:date]];
        [[self table] reloadData];
    }
    
    //  Update the index
    NSDate *newFirstVisible = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    NSUInteger index = [[self calendar] daysFromDate:newFirstVisible toDate:date];
    [self setSelectedIndex:index];
    
    _wrapper.top = 0;
    
    [self layoutSubviewsAnimated:animated];
    
    NSDate* selectedDate = _date;
    NSDate* todayDate = [NSDate date];
    NSString* selectedDateStr = [BaseMethod stringFromDate:selectedDate];
    NSString* todayDateStr = [BaseMethod stringFromDate:todayDate];
    selectedDate = [BaseMethod dateFormString:selectedDateStr];
    todayDate = [BaseMethod dateFormString:todayDateStr];
    int days = [BaseMethod fromStartDate:todayDate withEndDate:selectedDate];
    NSLog(@"days=%d",days);
    if (days>0) {
        _table.hidden = YES;
        _backTodayView.hidden = NO;
    }else
    {
        _table.hidden = NO;
        _backTodayView.hidden = YES;
    }
    
}


- (void)setMinimumDate:(NSDate *)minimumDate
{
    [self setMinimumDate:minimumDate animated:NO];
}

- (void)setMinimumDate:(NSDate *)minimumDate animated:(BOOL)animated
{
    _minimumDate = minimumDate;
    [self setDate:[self date] animated:animated];
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    [self setMaximumDate:[self date] animated:NO];
}

- (void)setMaximumDate:(NSDate *)maximumDate animated:(BOOL)animated
{
    _maximumDate = maximumDate;
    [self setDate:[self date] animated:animated];    
}

#pragma mark - CKCalendarHeaderViewDataSource

- (NSString *)titleForHeader:(CKCalendarHeaderView *)header
{
    CKCalendarDisplayMode mode = [self displayMode];
    NSString *string = [NSString new];
    
    if(mode == CKCalendarViewModeMonth)
    {
        string = [[self date] monthAndYearOnCalendar:[self calendar]];
    }
    
    else if (mode == CKCalendarViewModeWeek)
    {
        NSDate *firstVisibleDay = [self _firstVisibleDateForDisplayMode:mode];
        NSDate *lastVisibleDay = [self _lastVisibleDateForDisplayMode:mode];
        
        NSMutableString *result = [NSMutableString new];
        
        [result appendString:[firstVisibleDay monthAndYearOnCalendar:[self calendar]]];
        
        //  Show the day and year
        if (![[self calendar] date:firstVisibleDay isSameMonthAs:lastVisibleDay]) {
            result = [[firstVisibleDay monthAbbreviationAndYearOnCalendar:[self calendar]] mutableCopy];
            [result appendString:@" - "];
            [result appendString:[lastVisibleDay monthAbbreviationAndYearOnCalendar:[self calendar]]];
        }
        
        string = result;

    }else
    {
        //Otherwise, return today's date as a string
        string = [[self date] monthAndDayAndYearOnCalendar:[self calendar]];
    }
    self.strDate = string;
    
    if ([self.dataSource respondsToSelector:@selector(calendarView:title:)]) {
        [self.dataSource calendarView:self title:string];
    }
    return string;
}

- (NSUInteger)numberOfColumnsForHeader:(CKCalendarHeaderView *)header
{
    return [self _columnCountForDisplayMode:[self displayMode]];
}

- (NSString *)header:(CKCalendarHeaderView *)header titleForColumnAtIndex:(NSInteger)index
{
    NSDate *firstDate = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    NSDate *columnToShow = [[self calendar] dateByAddingDays:index toDate:firstDate];
    

    return [columnToShow dayNameOnCalendar:[self calendar]];
}


- (BOOL)headerShouldHighlightTitle:(CKCalendarHeaderView *)header
{
    CKCalendarDisplayMode mode = [self displayMode];
    
    if (mode == CKCalendarViewModeDay) {
        return [[self calendar] date:[NSDate date] isSameDayAs:[self date]];
    }
    
    return NO;
}

- (BOOL)headerShouldDisableBackwardButton:(CKCalendarHeaderView *)header
{
    
    //  Never disable if there's no minimum date
    if (![self minimumDate]) {
        return NO;
    }
    
    CKCalendarDisplayMode mode = [self displayMode];
    
    if (mode == CKCalendarViewModeMonth)
    {
        return [[self calendar] date:[self date] isSameMonthAs:[self minimumDate]];
    }
    else if(mode == CKCalendarViewModeWeek)
    {
        return [[self calendar] date:[self date] isSameWeekAs:[self minimumDate]];
    }

    return [[self calendar] date:[self date] isSameDayAs:[self minimumDate]];
}

- (BOOL)headerShouldDisableForwardButton:(CKCalendarHeaderView *)header
{
    
    //  Never disable if there's no minimum date
    if (![self maximumDate]) {
        return NO;
    }
    
    CKCalendarDisplayMode mode = [self displayMode];
    
    if (mode == CKCalendarViewModeMonth)
    {
        return [[self calendar] date:[self date] isSameMonthAs:[self maximumDate]];
    }
    else if(mode == CKCalendarViewModeWeek)
    {
        return [[self calendar] date:[self date] isSameWeekAs:[self maximumDate]];
    }
    
    return [[self calendar] date:[self date] isSameDayAs:[self maximumDate]];
}

#pragma mark - CKCalendarHeaderViewDelegate

- (void)forwardTapped
{
    NSDate *date = [self date];
    NSDate *today = [NSDate date];

    /* If the cells are animating, don't do anything or we'll break the view */
    
    if ([self isAnimating]) {
        return;
    }
    
    /*
     
     Moving forward or backwards for month mode
     should select the first day of the month,
     unless the newly visible month contains
     [NSDate date], in which case we want to
     highlight that day instead.
     
     */
    
    
    if ([self displayMode] == CKCalendarViewModeMonth) {
        
        NSUInteger maxDays = [[self calendar] daysPerMonthUsingReferenceDate:date];
        NSUInteger todayInMonth =[[self calendar] daysInDate:date];
        
        //  If we're the last day of the month, just roll over a day
        if (maxDays == todayInMonth) {
            date = [[self calendar] dateByAddingDays:1 toDate:date];
        }
        
        //  Otherwise, add a month and then go to the first of the month
        else{
            NSUInteger day = [[self calendar] daysInDate:date];
            date = [[self calendar] dateByAddingMonths:1 toDate:date];              //  Add a month
            date = [[self calendar] dateBySubtractingDays:day-1 fromDate:date];     //  Go to the first of the month
        }
        
        //  If today is in the visible month, jump to today
        if([[self calendar] date:date isSameMonthAs:[NSDate date]]){
            NSUInteger distance = [[self calendar] daysFromDate:date toDate:today];
            date = [[self calendar] dateByAddingDays:distance toDate:date];
        }
    }
    
    /*
     
     For week mode, we move ahead by a week, then jump to
     the first day of the week. If the newly visible week
     contains today, we set today as the active date.
     
     */
    
    else if([self displayMode] == CKCalendarViewModeWeek)
    {
        
        date = [[self calendar] dateByAddingWeeks:1 toDate:date];                   //  Add a week
        
        NSUInteger dayOfWeek = [[self calendar] weekdayInDate:date];
        date = [[self calendar] dateBySubtractingDays:dayOfWeek-1 fromDate:date];   //  Jump to sunday
        
        //  If today is in the visible week, jump to today
        if ([[self calendar] date:date isSameWeekAs:today]) {
            NSUInteger distance = [[self calendar] daysFromDate:date toDate:today];
            date = [[self calendar] dateByAddingDays:distance toDate:date];
        }
        
    }
    
    /*
     
     In day mode, simply move ahead by one day.
     
     */
    
    else{
        date = [[self calendar] dateByAddingDays:1 toDate:date];
    }
    
    //apply the new date
    [self setDate:date animated:YES];
}

- (void)backwardTapped
{
    
    NSDate *date = [self date];
    NSDate *today = [NSDate date];
    
    /* If the cells are animating, don't do anything or we'll break the view */
    
    if ([self isAnimating]) {
        return;
    }
    
    /*
     
     Moving forward or backwards for month mode
     should select the first day of the month,
     unless the newly visible month contains
     [NSDate date], in which case we want to
     highlight that day instead.
     
     */
    
    if ([self displayMode] == CKCalendarViewModeMonth) {
        
        NSUInteger day = [[self calendar] daysInDate:date];
        
        date = [[self calendar] dateBySubtractingMonths:1 fromDate:date];       //  Subtract a month
        date = [[self calendar] dateBySubtractingDays:day-1 fromDate:date];     //  Go to the first of the month
        
        //  If today is in the visible month, jump to today
        if([[self calendar] date:date isSameMonthAs:[NSDate date]]){
            NSUInteger distance = [[self calendar] daysFromDate:date toDate:today];
            date = [[self calendar] dateByAddingDays:distance toDate:date];
        }
    }
    
    /*
     
     For week mode, we move backward by a week, then jump
     to the first day of the week. If the newly visible
     week contains today, we set today as the active date.
     
     */
    
    else if([self displayMode] == CKCalendarViewModeWeek)
    {
        date = [[self calendar] dateBySubtractingWeeks:1 fromDate:date];               //  Add a week
        
        NSUInteger dayOfWeek = [[self calendar] weekdayInDate:date];
        date = [[self calendar] dateBySubtractingDays:dayOfWeek-1 fromDate:date];   //  Jump to sunday
        
        //  If today is in the visible week, jump to today
        if ([[self calendar] date:date isSameWeekAs:today]) {
            NSUInteger distance = [[self calendar] daysFromDate:date toDate:today];
            date = [[self calendar] dateByAddingDays:distance toDate:date];
        }
        
    }
    
    /*
     
     In day mode, simply move backward by one day.
     
     */
    
    else{
        date = [[self calendar] dateBySubtractingDays:1 fromDate:date];
    }
    
    //apply the new date
    [self setDate:date animated:YES];
}

#pragma mark - Rows and Columns

- (NSUInteger)_rowCountForDisplayMode:(CKCalendarDisplayMode)displayMode
{
    if (displayMode == CKCalendarViewModeWeek) {
//        return 1;
        return [[self calendar] weeksPerMonthUsingReferenceDate:[self date]];
    }
    else if(displayMode == CKCalendarViewModeMonth)
    {
        return [[self calendar] weeksPerMonthUsingReferenceDate:[self date]];
    }
    
    return 0;
}

- (NSUInteger)_columnCountForDisplayMode:(NSUInteger)displayMode
{
    if (displayMode == CKCalendarViewModeDay) {
        return 0;
    }
    
    return [[self calendar] daysPerWeekUsingReferenceDate:[self date]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.datas.count;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
   

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if ([[self events] count] == 0) {
//        return;
//    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectEvent:)]) {
        [[self delegate] calendarView:self didSelectEvent:[self events][[indexPath row]]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSDate* selectedDate = [BaseMethod beijingDate:_date];
    
    UIViewController* vc = [BaseMethod baseViewController:_table];
    // 宝宝日记
    if (indexPath.row == 0) {
        NoteController* noteVc = [[NoteController alloc] init];
        [vc.navigationController pushViewController:noteVc animated:YES];
    }
    // 里程碑
    if (indexPath.row == 1) {
        MilestoneController* milestoneVc = [[MilestoneController alloc] init];
        [vc.navigationController pushViewController:milestoneVc animated:YES];
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
        NSDate* selectedDate = [BaseMethod beijingDate:_date];
        
        int days = [BaseMethod fromStartDate:birthDate withEndDate:selectedDate];
        int month = days/30; // 第几个月
        
        NSArray* tests = [BaseSQL queryData_test];
        
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

#pragma mark - Date Calculations

- (NSDate *)firstVisibleDate
{
    return [self _firstVisibleDateForDisplayMode:[self displayMode]];
}

- (NSDate *)_firstVisibleDateForDisplayMode:(CKCalendarDisplayMode)displayMode
{
    // for the day mode, just return today
    if (displayMode == CKCalendarViewModeDay) {
        return [self date];
    }
    else if(displayMode == CKCalendarViewModeWeek)
    {
        return [[self calendar] firstDayOfTheWeekUsingReferenceDate:[self date]];
    }
    else if(displayMode == CKCalendarViewModeMonth)
    {
        NSDate *firstOfTheMonth = [[self calendar] firstDayOfTheMonthUsingReferenceDate:[self date]];
        
        NSDate *firstVisible = [[self calendar] firstDayOfTheWeekUsingReferenceDate:firstOfTheMonth];
        
        return firstVisible;
    }
    
    return [self date];
}

- (NSDate *)lastVisibleDate
{
    return [self _lastVisibleDateForDisplayMode:[self displayMode]];
}

- (NSDate *)_lastVisibleDateForDisplayMode:(CKCalendarDisplayMode)displayMode
{
    // for the day mode, just return today
    if (displayMode == CKCalendarViewModeDay) {
        return [self date];
    }
    else if(displayMode == CKCalendarViewModeWeek)
    {
        return [[self calendar] lastDayOfTheWeekUsingReferenceDate:[self date]];
    }
    else if(displayMode == CKCalendarViewModeMonth)
    {
        NSDate *lastOfTheMonth = [[self calendar] lastDayOfTheMonthUsingReferenceDate:[self date]];
        return [[self calendar] lastDayOfTheWeekUsingReferenceDate:lastOfTheMonth];
    }
    
    return [self date];
}

- (NSUInteger)_numberOfVisibleDaysforDisplayMode:(CKCalendarDisplayMode)displayMode
{
    //  If we're showing one day, well, we only one
    if (displayMode == CKCalendarViewModeDay) {
        return 1;
    }
    
    //  If we're showing a week, count the days per week
    else if (displayMode == CKCalendarViewModeWeek)
    {
        return [[self calendar] daysPerWeek];
    }
    
    //  If we're showing a month, we need to account for the
    //  days that complete the first and last week of the month
    else if (displayMode == CKCalendarViewModeMonth)
    {
        
        NSDate *firstVisible = [self _firstVisibleDateForDisplayMode:CKCalendarViewModeMonth];
        NSDate *lastVisible = [self _lastVisibleDateForDisplayMode:CKCalendarViewModeMonth];
        return [[self calendar] daysFromDate:firstVisible toDate:lastVisible];
    }
    
    //  Default to 1;
    return 1;
}

#pragma mark - Minimum and Maximum Dates

- (BOOL)_minimumDateIsBeforeMaximumDate
{
    //  If either isn't set, return YES
    if (![self _hasNonNilMinimumAndMaximumDates]) {
        return YES;
    }
    
    return [[self calendar] date:[self minimumDate] isBeforeDate:[self maximumDate]];
}

- (BOOL)_hasNonNilMinimumAndMaximumDates
{
    return [self minimumDate] != nil && [self maximumDate] != nil;
}

- (BOOL)_dateIsBeforeMinimumDate:(NSDate *)date
{
    return [[self calendar] date:date isBeforeDate:[self minimumDate]];
}

- (BOOL)_dateIsAfterMaximumDate:(NSDate *)date
{
    return [[self calendar] date:date isAfterDate:[self maximumDate]];
}

- (BOOL)_dateIsBetweenMinimumAndMaximumDates:(NSDate *)date
{
    //  If there are both the minimum and maximum dates are unset,
    //  behave as if all dates are in range.
    if (![self minimumDate] && ![self maximumDate]) {
        return YES;
    }
    
    //  If there's no minimum, treat all dates that are before
    //  the maximum as valid
    else if(![self minimumDate])
    {
        return [[self calendar]date:date isBeforeDate:[self maximumDate]];
    }

    //  If there's no maximum, treat all dates that are before
    //  the minimum as valid
    else if(![self maximumDate])
    {
        return [[self calendar] date:date isAfterDate:[self minimumDate]];
    }
    
    return [[self calendar] date:date isAfterDate:[self minimumDate]] && [[self calendar] date:date isBeforeDate:[self maximumDate]];
}
- (NSInteger)rowFromDate
{
    NSDate *firstVisible = [self firstVisibleDate];
    NSInteger index = [[self calendar] daysFromDate:firstVisible toDate:_date];
    NSInteger row = index/7;
    return row;
}
#pragma mark - Dates & Indices

- (NSInteger)_indexFromDate:(NSDate *)date
{
    NSDate *firstVisible = [self firstVisibleDate];
    return [[self calendar] daysFromDate:firstVisible toDate:date];
}

- (NSDate *)_dateFromIndex:(NSInteger)index
{
    NSDate *firstVisible = [self firstVisibleDate];
    return [[self calendar] dateByAddingDays:index toDate:firstVisible];
}

#pragma mark - Touch Handling

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    
    CGPoint p = [t locationInView:self];
    
    [self pointInside1:p withEvent:event];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    
    CGPoint p = [t locationInView:self];
    
    [self pointInside1:p withEvent:event];
}
- (BOOL)pointInside1:(CGPoint)point withEvent:(UIEvent *)event
{
    
//    CGRect bounds = [self bounds];
//    bounds.origin.y += [self headerView].frame.size.height;
//    bounds.size.height -= [self headerView].frame.size.height;

//    NSInteger row = [self rowFromDate];
//    NSLog(@"row:%d",row);
    
    
    
    if(CGRectContainsPoint([self _rectForCellsForDisplayMode:_displayMode], point)){
        /* Highlight and select the appropriate cell */
        
        NSUInteger index = [self selectedIndex];
        
        //  Get the index from the cell we're in
        for (CKCalendarCell *cell in [self usedCells]) {
            CGRect rect = [cell frame];
            if (CGRectContainsPoint(rect, point)) {
                index = [cell index];
                break;
            }

        }
        
        //  Clip the index to minimum and maximum dates
        NSDate *date = [self _dateFromIndex:index];
        
        if ([self _dateIsAfterMaximumDate:date]) {
            index = [self _indexFromDate:[self maximumDate]];
        }
        else if([self _dateIsBeforeMinimumDate:date])
        {
            index = [self _indexFromDate:[self minimumDate]];
        }

        // Save the new index
        [self setSelectedIndex:index];
        
        //  Update the cell highlighting
        for (CKCalendarCell *cell in [self usedCells]) {
            if ([cell index] == [self selectedIndex]) {
                [cell setSelected];
            }
            else
            {
                [cell setDeselected];
            }
            
        }
    }
    
    return [super pointInside:point withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSDate *firstDate = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    NSDate *dateToSelect = [[self calendar] dateByAddingDays:[self selectedIndex] toDate:firstDate];
    
    BOOL animated = ![[self calendar] date:[self date] isSameMonthAs:dateToSelect];
    
    [self setDate:dateToSelect animated:animated];
}

// If a touch was cancelled, reset the index
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSDate *firstDate = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    
    NSUInteger index = [[self calendar] daysFromDate:firstDate toDate:[self date]];
    
    [self setSelectedIndex:index];
    
    NSDate *dateToSelect = [[self calendar] dateByAddingDays:[self selectedIndex] toDate:firstDate];
    [self setDate:dateToSelect animated:NO];
}

#pragma mark -  BackTodayViewDelegate

- (void)backTodayViewDidBackToday
{
    self.isUp = NO;
    [self setDate:[NSDate date] animated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
