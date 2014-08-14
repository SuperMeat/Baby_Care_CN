//
//  UnTrainController.m
//  BabyCalendar
//
//  Created by will on 14-5-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "UnTrainController.h"
#import "UnTrainView.h"
#import "TrainedController.h"
#import "TrainModel.h"
@interface UnTrainController ()
@property(nonatomic,retain)UnTrainView* unTrainView;
@end

@implementation UnTrainController

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
    
    self.title = @"未完成训练";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem customForTarget3:self image:@"item_train_done" title:nil action:@selector(doneAction)];

    
    _unTrainView = [[[NSBundle mainBundle] loadNibNamed:@"UnTrainView" owner:self options:nil] lastObject];
    _unTrainView.height = kDeviceHeight-64;
    [self.view addSubview:_unTrainView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (TrainModel* model in _unTrainView.datas) {
        BOOL success = [BaseSQL updateData_train:model];
        if (!success) {
            NSLog(@"更新失败");
        }
    }
    // 刷新日历列表
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_SQLDatas object:nil];
    
    // 刷新日历
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_calendarView object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _unTrainView.datas = [self unTrainData];
}

- (NSMutableArray*)unTrainData
{
    NSMutableArray* mutabArr = [NSMutableArray array];
    NSMutableArray* arr = [BaseSQL queryData_train];
    if (arr.count > 0) {
        
        NSArray* knows = [BaseSQL queryData_train:kKnowledge withTrained:[NSNumber numberWithBool:NO]];
        [mutabArr addObject:knows];
        NSArray* actives = [BaseSQL queryData_train:kActive withTrained:[NSNumber numberWithBool:NO]];
        [mutabArr addObject:actives];
        NSArray* lives = [BaseSQL queryData_train:kLive withTrained:[NSNumber numberWithBool:NO]];
        [mutabArr addObject:lives];
        NSArray* society = [BaseSQL queryData_train:kSociety withTrained:[NSNumber numberWithBool:NO]];
        [mutabArr addObject:society];
        
    }
    return mutabArr[_index];
    
}
- (void)doneAction
{
    
    TrainedController* trainedVc = [[TrainedController alloc] init];
    trainedVc.index = _index;
    [self.navigationController pushViewController:trainedVc animated:YES];
}

@end
