//
//  VaccineListView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "VaccineListView.h"
#import "VaccineListCell.h"
#import "VaccineDetailController.h"
#import "VaccineModel.h"
@implementation VaccineListView

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
    
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self _initDatas];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_initDatas) name:kNotifi_reload_list_vaccine object:nil];
}

- (void)_initDatas
{
    
    [BaseSQL createTable_vaccine];
    
    NSMutableArray* arr = [BaseSQL queryData_vaccine];
    if (arr.count > 0) {
//        NSArray* array = [[arr reverseObjectEnumerator] allObjects];
        self.SQLDatas = arr;
        for (VaccineModel* model in self.SQLDatas) {
            if ([model.completed boolValue]) {
                _row++;
            }
        }
    
        [_tableView reloadData];
        return;
    }
    
    self.SQLDatas = [NSMutableArray array];
    
    NSDate* birthdayDate = [BaseMethod dateFormString:kBirthday];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"VaccineData" ofType:@"plist"];
    NSArray* datas = [NSArray arrayWithContentsOfFile:filePath];
    int index = 0;
    for (NSDictionary* dic in datas) {
        index++;
        VaccineModel* model = [[VaccineModel alloc] init];
        model.vaccine = [dic objectForKey:@"vaccine"];
        model.illness = [dic objectForKey:@"illness"];
        model.times = [dic objectForKey:@"times"];
        model.inplan = [NSNumber numberWithBool:YES];
        model.completed = [NSNumber numberWithBool:NO];
        model.id = [NSNumber numberWithInt:index];
        
        
        int month = [[dic objectForKey:@"month"] intValue];
        NSDate* date = [BaseMethod fromCurDate:birthdayDate withMonth:month];
        model.willDate = [BaseMethod stringFromDate:date];
        
        //超过接种一天以上时间默认接种
        long curTimeStamp = [ACDate getTimeStampFromDate:[ACDate date]];
        long willDateTimeStamp = [ACDate getTimeStampFromDate:date];
        if ((curTimeStamp - 86400)> willDateTimeStamp)
        {
            model.completedDate = model.willDate;
            model.completed     = [NSNumber numberWithInt:1];
        }
        
        [self.SQLDatas addObject:model];
        
        // 保存数据库
        [BaseSQL insertData_vaccine:model];
        
    }
    
    [_tableView reloadData];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_row > 0) {

        [_tableView setContentOffset:CGPointMake(0, _row*72) animated:YES];
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.SQLDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"VaccineListCell";
    VaccineListCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VaccineListCell" owner:self options:nil] lastObject];
    }
    cell.model = self.SQLDatas[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    VaccineModel* model = self.SQLDatas[indexPath.row];
//    if ([model.completed boolValue]) {
//        return;
//    }
    
    UIViewController* vc = [BaseMethod baseViewController:_tableView];
    VaccineDetailController* detailVc = [[VaccineDetailController alloc] init];
    detailVc.model = self.SQLDatas[indexPath.row];
    [vc.navigationController pushViewController:detailVc animated:YES];
    
}
-(void)tableView:(UITableView*)tableView  willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
