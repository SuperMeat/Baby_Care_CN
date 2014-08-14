//
//  TestController.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TestController.h"
#import "TestView.h"
#import "TestReportController.h"
#import "TestQuestionModel.h"
#import "TestModel.h"
@interface TestController ()
{
    float _unclear_times;
    float _knowledge_times;
    float _active_times;
    float _language_times;
    float _society_times;
    
    float _knowledge_score;
    float _active_score;
    float _language_score;
    float _society_score;
    
    
}
@property(nonatomic,retain)TestView* testView;
@end

@implementation TestController

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
    
    self.title = [NSString stringWithFormat:@"第%d个月测评",_month+1];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem customForTarget:self image:@"btn_back" title:nil action:@selector(doneAction)];
    
    _testView = [[TestView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64)];
    _testView.month = _month;
    [self.view addSubview:_testView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneAction) name:kNotifi_done_test object:nil];
}

- (void)doneAction
{
    // 计算测评分数
    
    NSArray* tests = _testView.middleView.datas;
    float each_score = 100.0f/(float)tests.count;
    float total_score = 0.0f;
    for (TestQuestionModel* model in tests) {
        // 总分
        total_score += [self score:[model.answer intValue] withEachScore:each_score withType:model.type];
        
    }
    
    

    TestModel* model = [[TestModel alloc] init];
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    model.date = [userDef objectForKey:kSelectedDate];
    model.month = [NSNumber numberWithInteger:_month+1];
    model.completed = [NSNumber numberWithBool:YES];
    model.score = [NSNumber numberWithInteger:total_score];
    model.knowledge_score = [NSNumber numberWithFloat:_knowledge_score/(_knowledge_times*each_score)*100.0];
    model.active_score = [NSNumber numberWithFloat:_active_score/(_active_times*each_score)*100.0];
    model.language_score = [NSNumber numberWithFloat:_language_score/(_language_times*each_score)*100.0];
    model.society_score = [NSNumber numberWithFloat:_society_score/(_society_times*each_score)*100.0];
    
    BOOL success = [BaseSQL updateData_test:model];
    if (success) {
        NSLog(@"测评分数计算成功");
        
        // 刷新日历列表
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_SQLDatas object:nil];
        
        // 刷新日历
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_calendarView object:nil];
        
        TestReportController* reportVc = [[TestReportController alloc] init];
        reportVc.month = _month;
        [self.navigationController pushViewController:reportVc animated:YES];
    }
    
    
    
}

- (float)score:(NSInteger)answer withEachScore:(float)each_score withType:(NSString*)type
{
    float value = 0;
    if (answer == kAnswer_can) {
        value = each_score;
    }
    if (answer == kAnswer_cannot) {
        value = 0.0f;
    }
    if (answer == kAnswer_unclear) {
        _unclear_times++;
        if (_unclear_times == 1) {
            value = each_score;
        }else if(_unclear_times == 2)
        {
            value = each_score/2.0f;
        }else
        {
            value = 0.0f;
        }
        
    }
    
    // 属性
    [self type_times:type withScore:value];
    
    return value;
}

- (void)type_times:(NSString*)type withScore:(float)value
{
    if ([type isEqualToString:kTest_type_knowledge]) {
        _knowledge_times++;
        _knowledge_score +=value;
    }
    if ([type isEqualToString:kTest_type_active]) {
        _active_times++;
        _active_score += value;
    }
    if ([type isEqualToString:kTest_type_language]) {
        _language_times++;
        _language_score += value;
    }
    if ([type isEqualToString:kTest_type_society]) {
        _society_times++;
        _society_score += value;
    }
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
