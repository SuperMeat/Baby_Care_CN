//
//  DataContract.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-3-28.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "DataContract.h"

@implementation DataContract

+(id)dataContract
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

-(NSDictionary*)UserCreateDict:(int) registerType
                       account:(NSString*) account
                      password:(NSString*) password
{
    NSArray *key = @[@"account",@"password",@"rType"];
    NSArray *data = [[NSArray alloc]initWithObjects:account,password,registerType,nil];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjects:data forKeys:key];
    return dict;
}

@end
