//
//  ASIController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-3-5.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASIController : NSObject

+(id)asiController;
-(BOOL)postLoginState:(int)state;
-(BOOL)createUserLocationMap:(NSString*)name andLocation:(MAUserLocation *)mylocation andStatus:(NSString*)status;

@end
