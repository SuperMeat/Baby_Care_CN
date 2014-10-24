//
//  InitTimeLineData.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-25.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabyMessageDataDB.h"
#import "HomeViewController.h"

@protocol RefreshTimeLineDelegate <NSObject>

#pragma mark 刷新时间轴
-(void)willRefreshTimeLine;
-(void)willDeleteMsgsWithTypeID:(int)typeID Key:(NSString*)key;
-(void)willInsertMsg;
@end

@interface InitTimeLineData : NSObject{
    BabyMessageDataDB *baby;
    MBProgressHUD *_hud;
}

@property (weak, nonatomic) UIViewController *targetViewController;
@property (nonatomic,strong) id<RefreshTimeLineDelegate> delegate;

+(InitTimeLineData*)initTimeLine;
-(void)getTimeLineData;//获取时间轴数据
-(void)checkTips:(long)date;

#pragma mark 完成提醒事项后处理
-(void)refreshByFinishItemsWithTypeID:(int)typeID
                              ProTime:(long)proTime
                                  Key:(NSString*)key
                              Content:(NSString*)content;

@end
