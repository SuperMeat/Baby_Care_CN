//
//  LocalNotify.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-23.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotify : NSObject
@property (strong, nonatomic) NSDate   *createtime;
@property (copy, nonatomic)   NSString *title;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *redundant;
@property int status;
@end
