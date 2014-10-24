//
//  BabyMsgTableViewCell.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-10-9.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Tint.h"

@class BCBabyMsg;

@interface BabyMsgTableViewCell : UITableViewCell

#pragma mark 消息实体
@property (nonatomic,strong) BCBabyMsg* babyMsg;

#pragma mark 高度
@property (nonatomic,assign) CGFloat    height;

@end
