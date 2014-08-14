//
//  UnTrainView.m
//  BabyCalendar
//
//  Created by will on 14-5-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "UnTrainView.h"
#import "UnTrainCell.h"
#import "TrainModel.h"
#import "RTLabel.h"
#import "PublicDefine.h"
#import "UIViewExt.h"

@implementation UnTrainView

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
    
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _tableView.height = self.height;
    
}

- (void)setDatas:(NSMutableArray *)datas
{
    _datas = datas;
    [_tableView reloadData];
}

#pragma mark -tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTLabel* rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth-40, 10)];
    rtLabel.font = [UIFont fontWithName:kFont size:kFontsize_untrain_content];
    TrainModel* model = self.datas[indexPath.row];
    rtLabel.text = model.content;
    [rtLabel sizeToFit];

    return rtLabel.optimumSize.height + 44+20;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"UnTrainCell";
    UnTrainCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UnTrainCell" owner:self options:nil] lastObject];
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
    
    TrainModel* model = self.datas[indexPath.row];
    BOOL trained = [model.trained boolValue];
    model.trained = [NSNumber numberWithBool:!trained];
    if ([model.trained boolValue]) {
        NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
        NSString* selectedDateStr = [userDef objectForKey:kSelectedDate];
        model.date = selectedDateStr;
    }else
    {
        model.date = @"";
    }
    [self.datas replaceObjectAtIndex:indexPath.row withObject:model];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}
@end
