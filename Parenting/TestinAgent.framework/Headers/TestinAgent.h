//
//  FRAppAgent.h
//  FreshRelic
//
//  Created by nbzhou on 14-5-22.
//  Copyright (c) 2014年 Lijinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestinAgent : NSObject


+(void)init:(NSString*)appId;

+(void)setUserInfo:(NSString*) userInfo;
@end
