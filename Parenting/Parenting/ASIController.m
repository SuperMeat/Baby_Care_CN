//
//  ASIController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-3-5.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "ASIController.h"
#import "ASIHTTPRequest.h"

@implementation ASIController

+(id)asiController{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

#pragma mark 更新登录状态
//state:1-在线 0-待机 -1-离线
-(BOOL)postLoginState:(int)state{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:state],"state",ACCOUNTNAME,"account",nil];
    NSMutableArray *result;
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error: &error];
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString* strUrl;
        strUrl = [ASIADDRESS stringByAppendingString:@"/BaseOperation.svc/postLoginState/"];
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strUrl];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request setRequestMethod:@"POST"];
        [request setPostBody:tempJsonData];
        [request startSynchronous];
        [request setTimeOutSeconds:10];
        NSError *error1 = [request error];
        if (!error1) {
            NSData *data = [request responseData];
            result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if ([[result objectAtIndex:0]intValue] == 1) {
                return YES;
            }
            else{
                return NO;
            }
        }
    }
    
    return NO;
}


@end
