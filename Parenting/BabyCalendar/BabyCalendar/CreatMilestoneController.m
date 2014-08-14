//
//  CreatMilestoneController.m
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "CreatMilestoneController.h"
#import "CreatMilestoneView.h"
#import "PortraitImageView.h"
#import "CreatMilestoneAddphotoView.h"
#import "MilestoneModel.h"
@interface CreatMilestoneController ()
@property(nonatomic,retain)CreatMilestoneView* creatMilestoneView;
@end

@implementation CreatMilestoneController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _creatMilestoneView = [[CreatMilestoneView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64)];
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新建里程碑";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem customForTarget:self image:@"btn_done" title:nil action:@selector(doneAction)];
    
    _creatMilestoneView.type = _type;
    _creatMilestoneView.model = _model;
    [self.view addSubview:_creatMilestoneView];
    

}



// 保存里程碑
- (void)doneAction
{
    
    [self.view endEditing:YES];
    
    NSString* title = _creatMilestoneView.headerView.textField.text;
    NSString* date = _creatMilestoneView.headerView.btnDate.titleLabel.text;
    NSString* content = _creatMilestoneView.contentView.textView.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeStr = [formatter stringFromDate:[NSDate date]];
    NSString *photoName = [NSString stringWithFormat:@"%@.jpg",timeStr];
    
    
    if ( title == nil || [title isEqualToString:@""]) {
        [self alertView:kTitle_none];
        return;
    }
    
    if ( content == nil || [content isEqualToString:@""]) {
        [self alertView:kContent_none];
        return;
    }
    
    NSString* old_PhotoName = _model.photo_path;
    
    BOOL success = NO;
    
    _model.title = title;
    _model.date = date;
    _model.content = content;
    _model.photo_path = photoName;
    _model.completed = [NSNumber numberWithBool:YES];
    
    if (_type == creatMilestoneType_model) {
        success = [BaseSQL updateData_milestone:_model];
    }else if(_type == creatMilestoneType_new)
    {
        success = [BaseSQL insertData_milestone:_model];
    }
    
    if (success) {
        [self alertView:kSave_success];
    }else
    {
        [self alertView:kSave_fail];
        return;
    }
    
    // 保存新图片
    [BaseMethod saveNewPhoto:_creatMilestoneView.addphotoView.addPhotoView.image withPhotoName:photoName];

    // 删除旧照片
    [BaseMethod deleteOldPhoto:old_PhotoName];
    

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_milestone_reloadTab object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_milestone_initDatas object:nil userInfo:nil];
    
    // 刷新日历列表
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_SQLDatas object:nil];

    // 刷新日历
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_calendarView object:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back:) userInfo:nil repeats:NO];
    
    
}

- (void)back:(NSTimer*)timer
{

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    
}
@end
