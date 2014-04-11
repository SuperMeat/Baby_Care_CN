//
//  HomeTopView.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-7.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "HomeTopView.h"

@implementation HomeTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
        [self initData];
    }
    return self;
}

#pragma 创建视图
-(void)initView{
    //整体背景
    [self setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    image_bg_top = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top.png"]];
    image_bg_top.frame = CGRectMake(0, 0, 320, 215);
    [self addSubview:image_bg_top];
    
    //头像
    image_headPic = [[UIImageView alloc]init];
    image_headPic.frame = CGRectMake(102.5, 55.5, 115, 115);
    image_headPic.layer.masksToBounds = YES;
    image_headPic.layer.cornerRadius = 57.5;
    [self addSubview:image_headPic];
    
    //天数背景
    image_days = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_days.png"]];
    image_days.frame = CGRectMake(90, 50, 38, 38);
    [self addSubview:image_days];
    
    //天数
    label_days = [[UILabel alloc]init];
    label_days.frame = CGRectMake(90, 57, 38, 24);
    label_days.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    label_days.textColor = [UIColor whiteColor];
    label_days.textAlignment = CPTTextAlignmentCenter;
    [self addSubview:label_days];
    
    //姓名
    label_babyName = [[UILabel alloc]init];
    label_babyName.frame = CGRectMake(60, 172, 200, 24);
    label_babyName.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    label_babyName.textColor = [UIColor whiteColor];
    label_babyName.textAlignment = CPTTextAlignmentCenter;
    [self addSubview:label_babyName];
}

#pragma 加载数据
-(void)initData{
//    label_days.text = @"";
//    label_babyName.text = @"";
//    image_headPic.image = [UIImage imageNamed:@"114.png"];
}

@end
