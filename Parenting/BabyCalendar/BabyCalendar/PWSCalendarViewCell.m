//
//  PWSCalendarViewCell.m
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////
#import "PWSCalendarViewCell.h"
#import "PWSCalendarViewFlowLayout.h"
#import "PWSCalendarDayCell.h"
#import "PWSCalendarView.h"
#import "CKCalendarModel.h"
#import "NoteModel.h"
#import "MilestoneModel.h"
#import "VaccineModel.h"
#import "TrainModel.h"
#import "TestModel.h"
///////////////////////////////////////////////////////////////////////////
extern NSString* PWSCalendarDayCellId;
const NSString* PWSCalendarViewCellId = @"PWSCalendarViewCellId";
///////////////////////////////////////////////////////////////////////////
@interface PWSCalendarViewCell()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
{
    NSCalendar*        m_calendar;
    UICollectionView*  m_collection_view;
    NSDate*            m_first_date;       // if week => select date
}

@property (nonatomic,retain)NSMutableArray* notes;
@property (nonatomic,retain)NSMutableArray* milestones;
@property (nonatomic,retain)NSMutableArray* vaccines;
@property (nonatomic,retain)NSMutableArray* trains;
@property (nonatomic,retain)NSMutableArray* tests;
@end
///////////////////////////////////////////////////////////////////////////
@implementation PWSCalendarViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _firstShow = YES;
        self.type = en_calendar_type_month;
        m_calendar = [NSCalendar currentCalendar];
        m_first_date = [NSDate date];
        [self SetInitialValue];
        
        [self reloadSQLDatas];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSQLDatas) name:kNotifi_reload_calendarView object:nil];
    }
    return self;
}

- (void) SetInitialValue
{
    PWSCalendarViewFlowLayout* layout = [[PWSCalendarViewFlowLayout alloc] init];
    CGFloat itemWidth = floorf(CGRectGetWidth(self.bounds) / 7.0f);
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    m_collection_view = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [self.contentView addSubview:m_collection_view];
    
    [m_collection_view setBackgroundColor:[UIColor clearColor]];
    [m_collection_view setDelegate:self];
    [m_collection_view setDataSource:self];
    [m_collection_view setScrollEnabled:NO];
    
    [m_collection_view registerClass:[PWSCalendarDayCell class] forCellWithReuseIdentifier:PWSCalendarDayCellId.copy];
}
- (void)reloadSQLDatas
{
    self.notes = [BaseSQL queryData_note];
    self.milestones = [BaseSQL queryData_milestone];
    self.vaccines = [BaseSQL queryData_vaccine];
    self.trains = [BaseSQL queryData_train];
    self.tests = [BaseSQL queryData_test];
    
    [m_collection_view reloadData];
    
}
- (void) setType:(enCalendarViewType)type
{
    _type = type;
    [m_collection_view reloadData];
}

- (void) ResetSelfFrame
{
    CGRect collection_view_frame = m_collection_view.frame;
    collection_view_frame.size.height = self.calendarHeight;
    [m_collection_view setFrame:collection_view_frame];
    
    // change view height
    if (_firstShow)
    {
        if ([self.delegate respondsToSelector:@selector(PWSCalendar:didChangeViewHeight:)])
        {
            [self.delegate performSelector:@selector(PWSCalendar:didChangeViewHeight:) withObject:nil withObject:nil];
        }
        _firstShow = NO;
    }
}

- (void) SetWithDate:(NSDate*)pDate ShowType:(enCalendarViewType)pCalendarType
{
    if (pCalendarType == en_calendar_type_month)
    {
        m_first_date = [self GetFirstDayOfMonth:pDate];
    }
    else if (pCalendarType == en_calendar_type_week)
    {
        m_first_date = pDate;
    }
    
    self.type = pCalendarType;
}

// reference
- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *firstOfMonth = [self firstOfMonthForSection:indexPath.section];
    NSInteger ordinalityOfFirstDay = [m_calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:firstOfMonth];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = (1 - ordinalityOfFirstDay) + indexPath.item;
    
    return [m_calendar dateByAddingComponents:dateComponents toDate:firstOfMonth options:0];
}

- (NSDate *)firstOfMonthForSection:(NSInteger)section
{
    NSDateComponents *offset = [NSDateComponents new];
    offset.month = section;
    
    NSDate* rt = [m_calendar dateByAddingComponents:offset toDate:m_first_date options:0];
    return rt;
}

- (NSDate*) GetFirstDayOfMonth:(NSDate*)pDate
{
    NSDateComponents *components = [m_calendar components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:pDate];
    NSDate* rt = [m_calendar dateFromComponents:components];
    return rt;
}

// delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int rt = 0;
    CGFloat itemWidth = floorf(CGRectGetWidth(m_collection_view.bounds) / 7.0f);
    CGFloat itemHeight = itemWidth;
    if (self.type == en_calendar_type_month)
    {
        NSRange rangeOfWeeks = [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:m_first_date];
        self.calendarHeight = itemHeight*rangeOfWeeks.length+10;
        rt = (rangeOfWeeks.length * 7);
    }
    else if (self.type == en_calendar_type_week)
    {
        self.calendarHeight = itemHeight+10;
        rt = 7;
    }

    [self ResetSelfFrame];
    return rt;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PWSCalendarDayCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:PWSCalendarDayCellId.copy forIndexPath:indexPath];
    
    cell.todayRow = indexPath.row;

    NSDate* cell_date = [self dateForCellAtIndexPath:indexPath];

    NSDateComponents *cellDateComponents = [m_calendar components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:cell_date];
    NSDateComponents *firstOfMonthsComponents = [m_calendar components:NSMonthCalendarUnit fromDate:m_first_date];
    
    if (cellDateComponents.month == firstOfMonthsComponents.month)
    {
        cell.date = cell_date;
        
    }
    else
    {
        
        cell.date = nil;
    }

//    if (self.type == en_calendar_type_month)
//    {
//        if (cellDateComponents.month == firstOfMonthsComponents.month)
//        {
//            cell.date = cell_date;
//            
//        }
//        else
//        {
//
//            cell.date = nil;
//        }
//    }
//    else if (self.type == en_calendar_type_week)
//    {
//        if (1)
//        {
//            cell.date = cell_date;
//        }
//    }

    cell.model = [self eventsFromSQLWtihDate:[BaseMethod stringFromDate:cell_date]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(PWSCalendar:didSelecteDate:atIndexPath:)])
    {
        NSDate* date = [self dateForCellAtIndexPath:indexPath];
//        [self.delegate performSelector:@selector(PWSCalendar:didSelecteDate:atIndexPath:) withObject:nil withObject:date withObject:indexPath];
        [self.delegate PWSCalendar:nil didSelecteDate:date atIndexPath:indexPath];
    }
    
    [m_collection_view reloadData];


}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate* selected_date = [self dateForCellAtIndexPath:indexPath];
    BOOL rt = [PWSHelper CheckSameMonth:selected_date AnotherMonth:m_first_date];
    return rt;
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
