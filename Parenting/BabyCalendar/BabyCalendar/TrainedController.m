//
//  TrainedController.m
//  BabyCalendar
//
//  Created by will on 14-5-29.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TrainedController.h"
#import "UnTrainView.h"
#import "TrainModel.h"
@interface TrainedController ()

@property(nonatomic,retain)UnTrainView* unTrainView;
@end

@implementation TrainedController

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
    
    self.title = @"已完成训练";
    
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
        
        NSArray* knows = [BaseSQL queryData_train:kKnowledge withTrained:[NSNumber numberWithBool:YES]];
        [mutabArr addObject:knows];
        NSArray* actives = [BaseSQL queryData_train:kActive withTrained:[NSNumber numberWithBool:YES]];
        [mutabArr addObject:actives];
        NSArray* lives = [BaseSQL queryData_train:kLive withTrained:[NSNumber numberWithBool:YES]];
        [mutabArr addObject:lives];
        NSArray* society = [BaseSQL queryData_train:kSociety withTrained:[NSNumber numberWithBool:YES]];
        [mutabArr addObject:society];
        
    }
    return mutabArr[_index];
    
}

@end
