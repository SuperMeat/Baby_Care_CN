//
//  MilestoneController.m
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "MilestoneController.h"
#import "MilestoneView.h"
#import "AddMilestoneController.h"
#import "MilestoneModel.h"
#import "EditeView.h"
#import "AddIemView.h"
#import "MilestoneContentView.h"
#import "MilestoneHeaderView.h"
#import "ShareInfoView.h"
@interface MilestoneController ()<EditeViewDelegate,AddIemViewDelegate,MilestoneViewDelegate>
{
    MilestoneView* _milestoneView;
    
    AddIemView* _addItemView;
    EditeView*  _editeView;
//    BOOL _noneData;
}

@end

@implementation MilestoneController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"里程碑";
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem customForTarget:self image:@"btn_add" title:nil action:@selector(addAction)];
    
    _addItemView = [[[NSBundle mainBundle] loadNibNamed:@"AddItemView" owner:self options:nil] lastObject];
    _addItemView.delegate = self;
    
    _editeView = [[[NSBundle mainBundle] loadNibNamed:@"EditeView" owner:self options:nil] lastObject];
    _editeView.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_addItemView];
    
    _milestoneView = [[MilestoneView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64)];
    _milestoneView.delegate = self;
    [self.view addSubview:_milestoneView];
    
    [self _initDatas];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_initDatas) name:kNotifi_milestone_initDatas object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (_noneData) {
//        _noneData = NO;
//        [self addAction];
//    }
    
}

- (void)_initDatas
{
    // 创建数据库
    [BaseSQL createTable_milestone];
    // 获取数据库数据
    NSArray* milestoneDatas_sql = [BaseSQL queryData_milestone];
    NSMutableArray* milestoneDatas = [NSMutableArray array];
    // 过滤获取已经完成的里程碑
    for (MilestoneModel* model in milestoneDatas_sql) {
        if ([model.completed boolValue]) {
            [milestoneDatas addObject:model];
        }
    }
    //是否有已完成的里程碑
    if (milestoneDatas.count == 0) {
//        _noneData = YES;
        _milestoneView.SQLDatas = nil;
    }else
    {
        _milestoneView.SQLDatas = milestoneDatas;
    }
    
    
}
- (void)addAction
{
    AddMilestoneController* addVc = [[AddMilestoneController alloc] init];
    [self.navigationController pushViewController:addVc animated:YES];
}

#pragma mark - EditeViewDelegate

- (void)editeViewDidCancel
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_addItemView];
    _milestoneView.headerView.photoView.canTap = NO;
    _milestoneView.contentView.textView.editable = NO;
    _milestoneView.headerView.btnDate.enabled = NO;
}
- (void)editeViewDidDone
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_addItemView];
    _milestoneView.headerView.photoView.canTap = NO;
    _milestoneView.contentView.textView.editable = NO;
    _milestoneView.headerView.btnDate.enabled = NO;
    
    // 更新数据
    if (_milestoneView.SQLDatas.count > 0) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* timeStr = [formatter stringFromDate:[NSDate date]];
        NSString *photoName = [NSString stringWithFormat:@"%@.jpg",timeStr];
        
        MilestoneModel* model = _milestoneView.SQLDatas[_milestoneView.index];
        model.content = _milestoneView.contentView.textView.text;
        NSString* old_photo = model.photo_path;
        model.photo_path = photoName;
        model.date = _milestoneView.headerView.btnDate.titleLabel.text;
        
        [_milestoneView.SQLDatas replaceObjectAtIndex:_milestoneView.index withObject:model];
        
        
        // 更新数据库
        [BaseSQL updateData_milestone:model];
        
        // 保存新照片
        [BaseMethod saveNewPhoto:_milestoneView.headerView.photoView.image withPhotoName:photoName];
        // 删除旧照片
        [BaseMethod deleteOldPhoto:old_photo];
        
        // 刷新日历列表
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_SQLDatas object:nil];
        
        // 刷新日历
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_calendarView object:nil];

        
    }
    
}

#pragma mark - AddIemViewDelegate

- (void)addIemViewDidEdite
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_editeView];
    
    _milestoneView.headerView.photoView.canTap = YES;
    _milestoneView.contentView.textView.editable = YES;
    _milestoneView.headerView.btnDate.enabled = YES;
}
- (void)addIemViewDidAdd
{
    [self addAction];
}

#pragma mark - MilestonViewDelegate
- (void)ShareToFriend
{
    UIImage *detailImage = [ACFunction cutView:self.view andWidth:kShareImageWidth_Milestone andHeight:kShareImageHeight_Milestone];
    ShareInfoView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"ShareInfoView" owner:self options:nil] lastObject];
    [shareView.shareInfoImageView setFrame:CGRectMake((320-193)/2.0, shareView.shareInfoImageView.origin.y, 217, 342)];
    [shareView.shareInfoImageView setImage:detailImage];
    shareView.titleDetail.text = [NSString stringWithFormat:kShareMilestoneTitle,[BabyinfoViewController getbabyname],[BabyinfoViewController getbabyage],_milestoneView.contentView.labTitle.text];;
    UIImage *shareimage = [ACFunction cutView:shareView andWidth:shareView.width andHeight:shareView.height];
    [ACShare shareImage:self andshareTitle:@"" andshareImage:shareimage anddelegate:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
