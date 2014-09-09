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
#import "ShareInfoView.h"

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
    
    _creatMilestoneView.type = _type;
    _creatMilestoneView.model = _model;
    if ([_model.completed intValue] == 1) {
        self.title = @"已完成";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem customForTarget:self image:@"item_share" title:nil action:@selector(ShareToFriend)];
        
        UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
        [backbutton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        backbutton.frame=CGRectMake(0, 0, 50, 41);
        backbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
        [backbutton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
        self.navigationItem.leftBarButtonItem=backbar;
    }
    else
    {
        self.title = @"新建里程碑";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem customForTarget:self image:@"btn_done" title:nil action:@selector(doneAction)];

    }
    
    [self.view addSubview:_creatMilestoneView];
    

}

- (void)goBack
{
    BOOL result  = [self doneAction];
    if (result) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)ShareToFriend
{
    UIImage *detailImage = [ACFunction cutView:self.view andWidth:kShareImageWidth_Milestone andHeight:kDeviceHeight-64];
    ShareInfoView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"ShareInfoView" owner:self options:nil] lastObject];
    [shareView.shareInfoImageView setFrame:CGRectMake((320-217)/2.0, shareView.shareInfoImageView.origin.y, 217, (kDeviceHeight-64)*217/320.0)];
    [shareView.shareInfoImageView setImage:detailImage];
    shareView.titleDetail.text = [NSString stringWithFormat:kShareMilestoneTitle,[BabyinfoViewController getbabyname],[BabyinfoViewController getbabyage],_model.title];;
    UIImage *shareimage = [ACFunction cutView:shareView andWidth:shareView.width andHeight:kDeviceHeight];
    [ACShare shareImage:self andshareTitle:@"" andshareImage:shareimage anddelegate:self];
}

// 保存里程碑
- (BOOL)doneAction
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
        return NO;
    }
    
    if ( content == nil || [content isEqualToString:@""]) {
        [self alertView:kContent_none];
        return NO;
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
        return NO;
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
    
    return YES;
}

- (void)back:(NSTimer*)timer
{

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    
}
@end
