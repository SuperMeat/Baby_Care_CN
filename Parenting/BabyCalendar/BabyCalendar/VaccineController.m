//
//  VaccineController.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "VaccineController.h"
#import "VaccineView.h"
#import "VaccineAddController.h"
@interface VaccineController ()

@end

@implementation VaccineController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"疫苗页面"];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"疫苗页面"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的疫苗";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem customForTarget3:self image:@"item_planoutside" title:nil action:@selector(planoutsideAction)];
    VaccineView* vaccineView = [[VaccineView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64)];
    [self.view addSubview:vaccineView];
}


- (void)planoutsideAction
{
    VaccineAddController* addVc = [[VaccineAddController alloc] init];
    [self.navigationController pushViewController:addVc animated:YES];
}


@end
