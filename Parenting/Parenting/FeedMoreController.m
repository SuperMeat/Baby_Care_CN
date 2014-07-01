//
//  FeedMoreController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-6-30.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "FeedMoreController.h"

@implementation FeedMoreController
+(id)feedmoreCtrller
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init
    });
    return _sharedObject;
}

-(NSArray *)getchooseFeedMoreTypeList:(int)age
{
    NSBundle *bundle = [ NSBundle mainBundle ];
    
    NSString *filePath = [ bundle pathForResource:@"feedmore" ofType:@"plist" ];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *feedMoreList     = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    int index = 0;
    if (age < 2)
    {
        index = 0;
    }
    //2~4月
    else if (age < 5)
    {
        index = 1;
    }
    //5~6月
    else if (age < 7)
    {
        index = 2;
    }
    //7~8月
    else if (age < 9)
    {
        index = 3;
    }
    //9~10月
    else if (age < 11)
    {
        index = 4;
    }
    //11~12,及以后
    else
    {
        index = 5;
    }
    
    for (int i = 0; i<= index; i++) {
        NSArray *tempArray = [feedMoreList objectAtIndex:i];
        [array addObjectsFromArray:tempArray];
    }
    
    return array;
}
@end
