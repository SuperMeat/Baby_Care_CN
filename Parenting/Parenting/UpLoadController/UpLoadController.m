//
//  UpLoadController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-2-28.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "UpLoadController.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
@implementation UpLoadController
+(id)uploadCtrller
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}

+(BOOL)checkDiaperUpload:(int)flag
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"ACCOUNT_NAME"])
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"麻麻,您还没有登录呦!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else
    {
        BOOL isCanupload = NO;

        //手动同步,直接同步
        if (flag == 0)
        {
            isCanupload = YES;
        }
        //自动同步,需要判断是否可以同步
        else
        {
            Reachability *r=[Reachability reachabilityWithHostName:@"www.apple.com"];
                        switch ([r currentReachabilityStatus]) {
                case NotReachable: // 没有网络连接
                    break;
                case ReachableViaWWAN:
                {
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"2G/3GBackUp"] == TRUE)
                    {
                        isCanupload = YES;
                    }
                }
                    break;
                case ReachableViaWiFi:
                {
                    isCanupload = YES;
                }
                    break;
            }
        }
        
        if (isCanupload)
        {
            //自动更新换尿布
            NSArray *array = [[DataBase dataBase] searchFromdiaperNoUpload];
            NSArray *returnArray = [UpLoadController PostActivityRecord:array Type:QCM_TYPE_DIAPER];
            if (returnArray == nil) {
                return NO;
            }
            
            if ([returnArray count] > 0)
            {
               [[DataBase dataBase] updateUploadtimeByList:returnArray andTableName:TABLE_NAME_DIAPER];
                return YES;
            }
        }
    }

    return NO;
    
}

+(NSArray*)PostActivityRecord:(NSArray*) records Type:(int)type;
{
    NSString *account = [[NSUserDefaults standardUserDefaults]stringForKey:@"ACCOUNT_NAME"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:records,@"records",account,@"account", nil];
    NSMutableArray *returnArr;
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error: &error];
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        NSString* strUrl;
        if (type == 4) {
            strUrl = [ASISYSTEMIP stringByAppendingString:@"/BabyActive.svc/postDiapers/"];
            
        }
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
            returnArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            return returnArr;
        }
    }
    
    return nil;
}


@end
