//
//  ASIHTTPController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-23.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

#pragma mark 弃用了,等待改装
@interface ASIHTTPController : NSObject
{
    int syncCount;
    int beginCount;
    NSString *lastSyncTime;
}

-(void)getSyncCount;
-(BOOL)postLoginState:(int)state;
@end
