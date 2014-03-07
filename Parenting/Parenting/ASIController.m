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
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:state],@"state",ACCOUNTNAME,@"account",nil]; 
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error: &error];
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString* strUrl;
        strUrl = [ASIADDRESS stringByAppendingString:@"/BaseOperation.svc/postLoginState"];
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strUrl];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request setRequestMethod:@"POST"];
        [request setPostBody:tempJsonData];
        
        [request setCompletionBlock :^{
        }];
        [request setFailedBlock :^{
        }];
        [request setTimeOutSeconds:10];
        [request startAsynchronous];
    }
    
    return YES;
}

-(BOOL)createUserLocationMap:(NSString*)name andLocation:(MAUserLocation *)mylocation andStatus:(NSString*)status
{
    
    NSString *str = [NSString stringWithFormat:@"key=%@&tableid=%d&loctype=1&data=%@",
                     AMAP_KEY,
                     123321,
                     [NSString stringWithFormat:@"{\"_name\":\"%@\",\"_location\":\"%lf,%lf\",\"status\":\"%@\"}",name, mylocation.coordinate.latitude, mylocation.coordinate.longitude,status]];
    NSData *jsonData = [[NSData alloc]initWithBase64Encoding:str];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    NSString* strUrl;
    strUrl = @"http://yuntuapi.amap.com/datamanage/data/create";
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/x-www-form-urlencoded"];
    [request setRequestMethod:@"POST"];
    [request setPostBody:tempJsonData];
    
    [request setCompletionBlock :^{
    }];
    [request setFailedBlock :^{
    }];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    
    return YES;
}

@end
