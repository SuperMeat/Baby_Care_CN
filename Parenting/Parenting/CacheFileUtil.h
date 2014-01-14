//
//  CacheFileUtil.h
//  Parenting
//
//  Created by 爱摩信息科技 on 13-5-18.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheFileUtil : NSObject

+ (CacheFileUtil*)sharedInstance;

- (NSString*)getUserDocPath;

@end
