//
//  AddMilestoneView.m
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "AddMilestoneView.h"
#import "AddMilestoneCell.h"
#import "CreatMilestoneController.h"
#import "MilestoneModel.h"
@implementation AddMilestoneView

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
    
    _scrollView.scrollEnabled = NO;
    
    
    _completedTable = [[UITableView alloc] init];
    _completedTable.delegate = self;
    _completedTable.dataSource = self;
    _completedTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _completedTable.backgroundColor = [UIColor clearColor];
    _completedTable.backgroundView = nil;

    
    _uncompletedTable = [[UITableView alloc] init];
    _uncompletedTable.delegate = self;
    _uncompletedTable.dataSource = self;
    _uncompletedTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _uncompletedTable.backgroundColor = [UIColor clearColor];
    _uncompletedTable.backgroundView = nil;
    
    _btnSeeCompleted = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSeeCompleted setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSeeCompleted setTitle:@"查看已完成的里程碑" forState:UIControlStateNormal];
    [_btnSeeCompleted addTarget:self action:@selector(seeCompletedAction) forControlEvents:UIControlEventTouchUpInside];
    [_btnSeeCompleted setBackgroundColor:UIColorFromRGB(kColor_milestone_detailText)];
    
    _btnSeeUncompleted = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSeeUncompleted setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnSeeUncompleted setTitle:@"查看未完成的里程碑" forState:UIControlStateNormal];
    [_btnSeeUncompleted addTarget:self action:@selector(seeUncompletedAction) forControlEvents:UIControlEventTouchUpInside];
    [_btnSeeUncompleted setBackgroundColor:UIColorFromRGB(kColor_milestone_detailText)];
    
    
    
    // 自定义按钮
    UIButton* customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBtn setFrame:CGRectMake(0, 0, 320, 60)];
    [customBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [customBtn setTitle:@"自定义添加+" forState:UIControlStateNormal];
    [customBtn addTarget:self action:@selector(customAction) forControlEvents:UIControlEventTouchUpInside];
    _uncompletedTable.tableFooterView = customBtn;

    
    self.completedDatas = [NSMutableArray array];
    self.uncompletedDatas = [NSMutableArray array];
    
    [self _initDatas];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_initDatas) name:kNotifi_milestone_reloadTab object:nil];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _scrollView.height = self.height;
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _scrollView.height*2);
    
    _completedTable.frame = CGRectMake(0, 0, kDeviceWidth, _scrollView.height-40);
    _btnSeeUncompleted.frame = CGRectMake(0, _completedTable.bottom, kDeviceWidth, 40);
    _btnSeeCompleted.frame = CGRectMake(0, _btnSeeUncompleted.bottom, kDeviceWidth, 40);
    _uncompletedTable.frame = CGRectMake(0, _btnSeeCompleted.bottom, kDeviceWidth, _scrollView.height-40);
    
    [_scrollView addSubview:_completedTable];
    [_scrollView addSubview:_uncompletedTable];
    [_scrollView addSubview:_btnSeeCompleted];
    [_scrollView addSubview:_btnSeeUncompleted];
    
    [_scrollView setContentOffset:CGPointMake(0, _scrollView.height) animated:NO];
    
    
}


- (void)_initDatas
{
    [self.completedDatas removeAllObjects];
    [self.uncompletedDatas removeAllObjects];
    
    NSMutableArray* arr = [BaseSQL queryData_milestone];
    if (arr.count > 0) {
        for (MilestoneModel* model in arr) {
            if ([model.completed boolValue]) {
                [self.completedDatas addObject:model];
            }else
            {
                [self.uncompletedDatas addObject:model];
            }
        }
        
        [_completedTable reloadData];
        [_uncompletedTable reloadData];
        return;
    }
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"MilestoneData" ofType:@"plist"];
    NSArray* datas = [NSArray arrayWithContentsOfFile:filePath];
    int index = 0;
    for (NSDictionary* dic in datas) {

        MilestoneModel* model = [[MilestoneModel alloc] init];
        model.id = [NSString stringWithFormat:@"%d",index];
        model.date = nil;
        model.month = [dic objectForKey:@"month"];
        model.title = [dic objectForKey:@"title"];
        model.content = nil;
        model.photo_path = nil;
        model.completed = [NSNumber numberWithBool:NO];
        [BaseSQL insertData_milestone:model];
        
        [self.uncompletedDatas addObject:model];
        index++;
    }
    
    [_completedTable reloadData];
    [_uncompletedTable reloadData];
}

- (void)seeCompletedAction
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)seeUncompletedAction
{    
    [_scrollView setContentOffset:CGPointMake(0, _btnSeeCompleted.top) animated:YES];
}

- (void)customAction
{
    UIViewController* vc = [BaseMethod baseViewController:_uncompletedTable];
    CreatMilestoneController* creatMilestoneVc = [[CreatMilestoneController alloc] init];
    creatMilestoneVc.type = creatMilestoneType_new;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString* timeStr = [formatter stringFromDate:[NSDate date]];

    MilestoneModel* model = [[MilestoneModel alloc] init];
    model.id = timeStr;
    creatMilestoneVc.model = model;
    
    [vc.navigationController pushViewController:creatMilestoneVc animated:YES];
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (tableView == _completedTable) {
        rows = self.completedDatas.count;
    }
    if (tableView == _uncompletedTable) {
        rows = self.uncompletedDatas.count;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString* identifier = @"AddMilestoneCell";
    AddMilestoneCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddMilestoneCell" owner:self options:nil] lastObject];
    }
    cell.row = indexPath.row;
    if (tableView == _completedTable) {
        cell.model = self.completedDatas[indexPath.row];
    }
    if (tableView == _uncompletedTable) {
        cell.model = self.uncompletedDatas[indexPath.row];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    AddMilestoneModel* model = self.datas[indexPath.row];
//    if (model.completed) {
//        return;
//    }
    
    UITableView* table = nil;
    MilestoneModel* model = nil;
    if (tableView == _completedTable) {
        table = _completedTable;
        model = self.completedDatas[indexPath.row];
    }
    if (tableView == _uncompletedTable) {
        table = _uncompletedTable;
        model = self.uncompletedDatas[indexPath.row];
    }
    
    UIViewController* vc = [BaseMethod baseViewController:table];
    CreatMilestoneController* creatMilestoneVc = [[CreatMilestoneController alloc] init];
    creatMilestoneVc.type = creatMilestoneType_model;
    creatMilestoneVc.model = model;
    [vc.navigationController pushViewController:creatMilestoneVc animated:YES];
    
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
