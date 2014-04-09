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
        [self setBackground];
        [self initController];
    }
    return self;
}

//设置背景颜色、图片
-(void)setBackground{
    [self setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    [image_bg_top setFrame:CGRectMake(0, 15, 320.0f, 215.0f)];
    [self addSubview:image_bg_top];
}

//初始化控件
-(void)initController{
    //
}

@end
