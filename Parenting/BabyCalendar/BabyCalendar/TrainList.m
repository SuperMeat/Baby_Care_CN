//
//  TrainList.m
//  BabyCalendar
//
//  Created by will on 14-5-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TrainList.h"
#import "TrainListModel.h"
#import "TrainListCell.h"
#import "UnTrainController.h"
#import "TrainModel.h"
@implementation TrainList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;

    
    
    self.datas = [NSMutableArray array];
    
    NSArray* images= @[@"icon_knowledge",@"icon_active",@"icon_ custom",@"icon_ society"];
    NSArray* titles= @[@"认知能力的培养",@"动作能力的培养",@"习惯和生活能力的培养",@"社会交往能力的培养"];
    for (int index = 0; index < images.count; index++) {
        TrainListModel* model = [[TrainListModel alloc] init];
        model.image = images[index];
        model.title = titles[index];
        [self.datas addObject:model];
    }
    
    
    [self _initDatas];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _tableView.height = self.height;
}

- (void)_initDatas
{
    
    // 列表数据
    [BaseSQL createTable_train];
    
    NSMutableArray* arr = [BaseSQL queryData_train];
    
    if (arr.count == 0) {
        int index = 0;
        int i = 0;
        NSArray* types = @[kKnowledge,kActive,kLive,kSociety];
        NSString* path = [[NSBundle mainBundle] pathForResource:@"TrainData" ofType:@"plist"];
        NSArray* trainDatas = [NSArray arrayWithContentsOfFile:path];
        for (NSArray* trainData in trainDatas)
        {
            for (NSDictionary* dic in trainData[0])
            {
                index++;
                TrainModel* model = [[TrainModel alloc] init];
                model.id = [NSNumber numberWithInt:index];
                model.type = types[i];
                model.title = [dic objectForKey:@"title"];
                model.content = [dic objectForKey:@"content"];
                model.trained = [NSNumber numberWithBool:NO];
                model.date = @"";
                model.month = [NSNumber numberWithInt:3];
                [BaseSQL insertData_train:model];
           
            }
            
            for (NSDictionary* dic in trainData[1])
            {
                index++;
                TrainModel* model = [[TrainModel alloc] init];
                model.id = [NSNumber numberWithInt:index];
                model.type = types[i];
                model.title = [dic objectForKey:@"title"];
                model.content = [dic objectForKey:@"content"];
                model.trained = [NSNumber numberWithBool:NO];
                model.date = @"";
                model.month = [NSNumber numberWithInt:6];
                [BaseSQL insertData_train:model];
                
            }
            
            for (NSDictionary* dic in trainData[2])
            {
                index++;
                TrainModel* model = [[TrainModel alloc] init];
                model.id = [NSNumber numberWithInt:index];
                model.type = types[i];
                model.title = [dic objectForKey:@"title"];
                model.content = [dic objectForKey:@"content"];
                model.trained = [NSNumber numberWithBool:NO];
                model.date = @"";
                model.month = [NSNumber numberWithInt:9];
                [BaseSQL insertData_train:model];
                
            }
            
            for (NSDictionary* dic in trainData[3])
            {
                index++;
                TrainModel* model = [[TrainModel alloc] init];
                model.id = [NSNumber numberWithInt:index];
                model.type = types[i];
                model.title = [dic objectForKey:@"title"];
                model.content = [dic objectForKey:@"content"];
                model.trained = [NSNumber numberWithBool:NO];
                model.date = @"";
                model.month = [NSNumber numberWithInt:12];
                [BaseSQL insertData_train:model];
                
            }
            i++;
        }
        
    }
}

#pragma mark -tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"TrainListCell";
    TrainListCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TrainListCell" owner:self options:nil] lastObject];
    }
    cell.model = self.datas[indexPath.row];
    
    return cell;
    
}
-(void)tableView:(UITableView*)tableView  willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController* vc = [BaseMethod baseViewController:_tableView];
    UnTrainController* unTrainVc = [[UnTrainController alloc] init];
    unTrainVc.index = indexPath.row;
    [vc.navigationController pushViewController:unTrainVc animated:YES];
    
}
@end
