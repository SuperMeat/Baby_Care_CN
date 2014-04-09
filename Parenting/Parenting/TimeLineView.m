//
//  TimeLineView.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-9.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "TimeLineView.h"

#define MsgMaxLength 20
#define SingleLine 47.5
#define DoubleLine 79

@implementation TimeLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init TableView
        _timeLineTableView  =
        [[UITableView alloc]initWithFrame:
         CGRectMake(self.bounds.origin.x,
                    self.bounds.origin.y,
                    self.bounds.size.width,
                    self.bounds.size.height) style:UITableViewStylePlain];
        _timeLineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _timeLineTableView.dataSource = self;
        _timeLineTableView.delegate = self;
        [self addSubview:_timeLineTableView];
        //init Data
        [self initData];
    }
    return self;
}

#pragma 加载数据
-(void)initData{
    //DEBUG:test data
    NSArray *arr1 = @[@"1",@"测试数据1",@"",@"",@"4-4"];
    NSArray *arr2 = @[@"2",@"测试数据2",@"",@"",@"4-4"];
    timeLineArray = [[NSMutableArray alloc]initWithObjects:arr1,arr2, nil];
}

#pragma mark table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return [timeLineArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断字体行数（最多两行）
    if ([[[timeLineArray objectAtIndex:indexPath.row] objectAtIndex:1] length] > MsgMaxLength) {
        return DoubleLine;
    }
    else {
        return SingleLine;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[self.timeLineTableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *pointView = [self timeLinePointView:[timeLineArray objectAtIndex:indexPath.row] from:indexPath.row];
        
        //时间轴背景图片
        UIImageView *timelineBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeline.png"]];
        timelineBG.frame = CGRectMake(29.5, 0, 3, cell.bounds.size.height+5);
        
        [cell.contentView addSubview:timelineBG];
        [cell.contentView addSubview:pointView];
    }
    return cell;
}

#pragma mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //根据点击类型跳转到相关页面
    //[self.navigationController pushViewController:viewController animated:YES];
}

- (UIView*) timeLinePointView:(NSArray*) arrayContent from:(NSInteger)fromIndex {
    UIView *returnView = [[UIView alloc]initWithFrame:CGRectZero];
    //类型图片
    UIImage *typeImage = [[UIImage alloc] init];
    NSInteger msgType = [[arrayContent objectAtIndex:0] integerValue];
    switch (msgType) {
        case 0:
            typeImage = [UIImage imageNamed:@"icon_alarm.png"];
            break;
        case 1:
            typeImage = [UIImage imageNamed:@"icon_remind.png"];
            break;
        case 2:
            typeImage = [UIImage imageNamed:@"icon_news.png"];
            break;
        case 3:
            typeImage = [UIImage imageNamed:@"icon_advertisement.png"];
            break;
        case 4:
            typeImage = [UIImage imageNamed:@"icon_message.png.png"];
            break;
        default:
            break;
    }
    UIImageView *typeImageView = [[UIImageView alloc] initWithImage:typeImage];
    typeImageView.frame = CGRectMake(15, 7, 31.5f, 31.5f);
    
    //时间文本
    UILabel *timeLabel = [[UILabel alloc] init];
    UIFont *fontTime = [UIFont systemFontOfSize:8.0f];
    timeLabel.font = fontTime;
    timeLabel.textColor = [UIColor blackColor];
    CGSize timeLabelSize = [timeLabel.text sizeWithAttributes:@{NSFontAttributeName:fontTime}];
    timeLabel.frame = CGRectMake(5.0f,37.0f,timeLabelSize.width, timeLabelSize.height);
    timeLabel.text = [arrayContent objectAtIndex:4];
    
    //内容文本
    NSString *content = [arrayContent objectAtIndex:1];
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    CGSize size = [content sizeWithAttributes: @{NSFontAttributeName:font}];
    
    UILabel *pointText = [[UILabel alloc] init];
    //判断:如果字符数大于单行显示的最大字数，则固定显示两行
    if ([[arrayContent objectAtIndex:1] length] > MsgMaxLength) {
        size = CGSizeMake((320.0f - 90.0f), size.height * 2.0f + 6.0f);
        pointText.numberOfLines = 2;
    }
    pointText.frame = CGRectMake(70.0f, 10.0f, size.width+9.0f, size.height+6.0f);
    pointText.font = font;
    pointText.text = [arrayContent objectAtIndex:1];
    pointText.textColor = [UIColor blackColor];
    //内容文本背景
    UIImage *textBgImage = [UIImage imageNamed:@"input_word.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    // 指定为拉伸模式，伸缩后重新赋值
    textBgImage = [textBgImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    UIImageView *textBgImageView = [[UIImageView alloc]initWithImage:textBgImage];
    textBgImageView.frame = CGRectMake(55.0f, 8.0f, pointText.frame.size.width+20.0f, pointText.frame.size.height+6.0f);
    
    
    [returnView addSubview:typeImageView];
//    [returnView addSubview:timeLabel];
    [returnView addSubview:textBgImageView];
    [returnView addSubview:pointText];
    return returnView;
}


@end
