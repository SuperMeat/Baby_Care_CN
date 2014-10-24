//
//  VaccineDetailController.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "VaccineDetailController.h"
#import "VaccineDetailView.h"
#import "VaccineModel.h"
#import "VaccineDetailHeaderView.h"
@interface VaccineDetailController ()
{
    VaccineDetailView* _detailView;
}
@end

@implementation VaccineDetailController

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
    self.title = @"疫苗详情";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem customForTarget:self image:@"btn_done" title:nil action:@selector(doneAction)];
    
    _detailView = [[VaccineDetailView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64)];
    _detailView.model = _model;
    [self.view addSubview:_detailView];
}


- (void)doneAction
{
    VaccineModel* model = _detailView.headerView.model;

    
    if (![model.inplan boolValue]) {
         // 计划外
        BOOL success = NO;
        if ([model.completed boolValue]) {
            if ([BaseSQL queryData_vaccine_withModel:model]) {
                success = [BaseSQL updateData_vaccine:model];
            }else
            {
                success = [BaseSQL insertData_vaccine:model];
            }
            
        }else
        {
            success = [BaseSQL deleteData_vaccine:model];
        }
        
        if (success) {
            [self alertView:kSave_success];
        }else
        {
            [self alertView:kSave_fail];
            return;
        }
        [self save_outplan:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_add_vaccine object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_list_vaccine object:nil];
    }else
    {
        // 计划内
        BOOL success = [BaseSQL updateData_vaccine:model];
        
        // 如果是A群流脑疫苗第一针，第二针就需要特殊处理,更新接种时间
        if ([model.vaccine isEqualToString:@"A群流脑疫苗"] && [model.times isEqualToString:@"第一针"])
        {
            NSArray* array = [BaseSQL queryData_vaccinebyvaccinename:@"A群流脑疫苗" andTimes:@"第二针"];
            if ([array count]>0 && [array objectAtIndex:0])
            {
                VaccineModel *vaccineModel = [array objectAtIndex:0];
                if (model.completedDate == nil) {
                    NSDate *completeDate = [BaseMethod dateFormString:model.willDate];
                    NSDate *willDate = [BaseMethod fromCurDate:completeDate withMonth:3];
                    vaccineModel.willDate = [BaseMethod stringFromDate:willDate];
                }
                else
                {
                    NSDate *completeDate = [BaseMethod dateFormString:model.completedDate];
                    NSDate *willDate = [BaseMethod fromCurDate:completeDate withMonth:3];
                    vaccineModel.willDate = [BaseMethod stringFromDate:willDate];
                }
                [BaseSQL updateData_vaccineSpecial:vaccineModel];
            }
            
        }
        
        if (success) {
            [self alertView:kSave_success];
            
            /**  edit by cwb  **/
            /**  刷新首页时间轴及数据源  **/
            [[InitTimeLineData initTimeLine]refreshByFinishItemsWithTypeID:10 ProTime:[ACDate getTimeStampFromDate:[BaseMethod dateFormString:model.completedDate]] Key:[NSString stringWithFormat:@"%@",model.id  ] Content:[NSString stringWithFormat:@"宝宝于%@接种%@(%@)。",model.completedDate,model.vaccine,model.times]];
        }else
        {
            [self alertView:kSave_fail];
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_list_vaccine object:nil];
    }
    
    // 刷新日历列表
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_SQLDatas object:nil];
    
    // 刷新日历
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_calendarView object:nil];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back:) userInfo:nil repeats:NO];
}

- (void)back:(NSTimer*)timer
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save_outplan:(VaccineModel*)model
{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSString* key = [NSString stringWithFormat:@"%d",[model.id intValue]];
    if ([model.completed boolValue]) {
        
        [userDef setObject:key forKey:key];

    }else
    {
        [userDef setObject:nil forKey:key];

    }
    [userDef synchronize];
}

@end
