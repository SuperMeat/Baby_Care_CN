//
//  ASIActivityController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-2-28.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "ASIActivityController.h"
#import "Reachability.h"
#import "MD5.h"

@implementation ASIActivityController
+(id)ASIActivityController
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
        
    });
    return _sharedObject;
}


-(int)postDiaperRecordAccount:(NSString*)account
                       Upload:(int)upload
                     Starttime:(NSDate*)starttime
                         Month:(int)month
                          Week:(int)week
                       WeekDay:(int)weekday
                        Status:(NSString*)status
                         Color:(NSString *)color
                       Remark:(NSString *)remark
{
    if (![self CheckNetWorkStatus]) {
        return 0;
    }
    NSString* content = [@"PostDiaperRecord/" stringByAppendingString:[MD5 md5:ASIHTTPTOKEN]];
    //acount
    content = [content stringByAppendingString:[NSString stringWithFormat:@"/%@", account]];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"/%d", upload]];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"/%d", (int)[starttime timeIntervalSince1970]]];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"/%d", month]];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"/%d", week]];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"/%d", weekday]];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"/%@", status]];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"/%@", remark]];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"/%@", color]];
    content = [content stringByAppendingString:@"/0"];
    content = [content stringByAppendingString:@"/0"];
    
    NSString* strUrl = [ASIHTTPADDRESS stringByAppendingString:content];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        if(![response isEqualToString:@"-1"])
        {
            return [response intValue];
        }
        else
        {
            return 0;
        }
    }
    return 0;
}

-(BOOL)CheckNetWorkStatus{
    Reachability *r=[Reachability reachabilityWithHostName:@"www.apple.com"];
    BOOL status;
    switch ([r currentReachabilityStatus]) {
        case NotReachable: // 没有网络连接
        {
            status = NO;
        }
            break;
        case ReachableViaWWAN:
        {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"2G/3GBackUp"] == TRUE)
            {
                status = YES;
            }
        }
            break;
        case ReachableViaWiFi:
        {
            status = YES;
        }
            break;
    }
    return  status;
}

@end
