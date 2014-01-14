//
//  CacheFileUtil.m
//  Parenting
//
//  Created by 爱摩信息科技 on 13-5-18.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "CacheFileUtil.h"

@implementation CacheFileUtil

static CacheFileUtil *sharedInstance;

+ (CacheFileUtil*)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[CacheFileUtil alloc] init];
    }
    return sharedInstance;
}

- (id)init
{
    return [super init];
}

- (NSString*)getUserDocPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *userFolderPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Log/"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:userFolderPath]) {
        [fileManager createDirectoryAtPath:userFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return userFolderPath;
}

@end
