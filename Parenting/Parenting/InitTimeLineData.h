//
//  InitTimeLineData.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-25.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InitTimeLineData : NSObject{
    BabyMessageDataDB *baby;
}

+(id)initTimeLineData;
+(NSArray*)getTimeLineData;//获取时间轴数据

-(void)checkSysMsg;
@end
