//
//  ZhelineView.h
//  MySafedog
//
//  Created by will on 14-2-8.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Zheline : UIView

@property(nonatomic,retain)NSArray* pArray;
// 纵向
@property(nonatomic,retain)NSArray* yDesc;
//点信息组
@property(nonatomic,strong)NSArray* points;
// 颜色组
@property(nonatomic,retain)NSArray* colors;
// 时间
@property(nonatomic,retain)NSArray* times;
// 颜色
@property(nonatomic)BOOL bColorGreen;
@end
