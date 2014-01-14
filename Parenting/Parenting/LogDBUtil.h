//
//  LogDBUtil.h
//  Parenting
//
//  Created by 爱摩信息科技 on 13-5-18.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface LogDBUtil : NSObject{
    
    sqlite3 *database;
}

+ (LogDBUtil*)sharedInstance;
- (BOOL)db_open;
- (BOOL)createLogTable;
////type(1-feed;2-diaper;3-sleep;4-play;5-bath);
////sign:当type为1时，1-母乳左，2-母乳右，3-奶瓶(capacity为所喂容量)；当type为2时，1-Dry,2-Wet,3-Dirty;当type为其他值是该值为0；
////capacity:只用当奶瓶喂食时该值不为0;
////duration:所用时间(h);
////startTime:开始时间(包含时间);
- (BOOL)insertLogTable:(NSString*)type sign:(NSString*)sign capacity:(NSString*)capacity duration:(NSString*)duration startTime:(NSString*)startTime;

- (NSDictionary*)queryLogTable:(NSString*)topCount;

@end
