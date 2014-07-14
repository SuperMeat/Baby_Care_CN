//
//  SummaryDB.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-26.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SummaryDB : NSObject
+(id)dataBase;

-(NSArray*)selectAll;
-(NSArray*)selectAllforsummary;
-(NSArray*)selectfeedforsummary;
-(NSArray*)selectdiaperforsummary;
-(NSArray*)selectbathforsummary;
-(NSArray*)selectsleepforsummary;
-(NSArray*)selectplayforsummary;
-(NSArray*)selectmedicineforsummary;

-(NSString*)selectFromfeed;
-(NSString*)selectFrombath;
-(NSString*)selectFromsleep;
-(NSString*)selectFromplay;
-(NSString*)selectFromdiaper;
-(NSString*)selectFrommedicine;

-(NSArray*)searchFromfeed:(NSDate*)start;
-(NSArray*)searchFromdiaper:(NSDate*)start;
-(NSArray*)searchFromdiaperNoUpload;
-(NSArray*)searchFrombath:(NSDate*)start;
-(NSArray*)searchFromplay:(NSDate*)start;
-(NSArray*)searchFromsleep:(NSDate*)start;
-(NSArray*)searchFrommedicine:(NSDate*)start;

-(NSDictionary*)searchTodayDiaperStatusList;
-(NSDictionary*)searchYesterdayDiaperStatusList;

-(NSDictionary*)searchCurFeedStatusList;
-(NSDictionary*)searchLastFeedStatusList;

-(NSDictionary*)searchCurSleepStatusList;
-(NSDictionary*)searchLastSleepStatusList;

-(BOOL)deleteWithStarttime:(NSDate*)starttime;

+ (int)scrollWidth:(int)tag;
+ (int)scrollWidthWithTag:(int)tag andTableName:(NSString*)tablename;
+ (NSArray *)scrollData:(int)scrollpage andTable:(NSString *)table andFieldTag:(int)fileTag;
+ (int)getMonthMax:(int)scrollpage;
@end
