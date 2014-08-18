//
//  AddMilestoneController.m
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "AddMilestoneController.h"
#import "AddMilestoneView.h"


@interface AddMilestoneController ()
@property(nonatomic,retain)AddMilestoneView* addMilestoneView;
@end

@implementation AddMilestoneController

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
    
    self.title = @"添加里程碑";
    
    _addMilestoneView = [[[NSBundle mainBundle] loadNibNamed:@"AddMilestoneView" owner:self options:nil] lastObject];
    [_addMilestoneView setFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64)];
    [self.view addSubview:_addMilestoneView];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:kNotifi_milestone_home object:nil];
}


//- (void)back
//{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end
