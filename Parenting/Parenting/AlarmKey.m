//
//  AlarmKey.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-27.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "AlarmKey.h"

@implementation AlarmKey

-(id) copyWithZone:(NSZone *)zone //创建一个复制的接收器,储存zone 
{
    AlarmKey *newalarmkey = [[AlarmKey allocWithZone:zone]init];
    
    return newalarmkey;
}
@end
