//
//  TestReportController.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TestReportController.h"
#import "TestReportView.h"
#import "ShareInfoView.h"
#import "TestModel.h"

@interface TestReportController ()

@end

@implementation TestReportController

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
    
    self.title = @"测评报告";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem customForTarget:self image:@"item_share" title:nil action:@selector(shareAction)];
    
    reportView = [[TestReportView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64)];
    reportView.month = _month;
    [self.view addSubview:reportView];
    
}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//
//    
//}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:[NSNumber numberWithBool:YES] forKey:kPush_testReportVc];
    [userDef synchronize];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:[NSNumber numberWithBool:NO] forKey:kPush_testReportVc];
    [userDef synchronize];
}

- (void)shareAction
{
    UIImage *detailImage = [ACFunction cutScrollView:reportView];
    [reportView setNeedsDisplay];
    ShareInfoView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"ShareInfoView" owner:self options:nil] lastObject];
    [shareView.shareInfoImageView setFrame:CGRectMake((320-193)/2.0, shareView.shareInfoImageView.origin.y, 193, 342)];
    [shareView.shareInfoImageView setImage:detailImage];
    TestModel *testmodel = reportView.datas[_month];
    shareView.titleDetail.text = [NSString stringWithFormat:kShareTestTitle,[BabyinfoViewController getbabyname],_month+1,testmodel.score];
    UIImage *shareimage = [ACFunction cutView:shareView andWidth:shareView.width andHeight:shareView.height];
    [ACShare shareImage:self andshareTitle:@"" andshareImage:shareimage anddelegate:self];

}

@end
