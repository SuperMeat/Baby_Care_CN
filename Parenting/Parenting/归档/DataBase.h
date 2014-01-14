//
//  DataBase.h
//  Parenting
//
//  Created by user on 13-5-28.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBase : NSObject

typedef enum{
    Play,
    Dath,
    Feed,
    Sleep,
    Diaper
}tableName;

+(id)dataBase;
-(BOOL)insertfeedStarttime:(NSDate*)starttime
                 Month:(int)month
                  Week:(int)week
                WeekDay:(int)weekday
              Duration:(int)duration
               Feedway:(int)feedway
                OzorLR:(NSString*)ozorlr
                Remark:(NSString*)remark;
-(BOOL)insertdiaperStarttime:(NSDate*)starttime
                 Month:(int)month
                  Week:(int)week
               WeekDay:(int)weekday
                Status:(NSString*)status
                Remark:(NSString*)remark;
-(BOOL)insertsleepStarttime:(NSDate*)starttime
                 Month:(int)month
                  Week:(int)week
                WeekDay:(int)weekday
              Duration:(int)duration
                Remark:(NSString*)remark;
-(BOOL)insertplayStarttime:(NSDate*)starttime
                      Month:(int)month
                       Week:(int)week
                    WeekDay:(int)weekday
                   Duration:(int)duration
                     Remark:(NSString*)remark;
-(BOOL)insertbathStarttime:(NSDate*)starttime
                      Month:(int)month
                       Week:(int)week
                    WeekDay:(int)weekday    
                   Duration:(int)duration
                     Remark:(NSString*)remark;

-(BOOL)insertUserAdviseLock;

-(NSArray*)selectAll;
-(NSArray*)selectAllforsummary;
-(NSArray*)selectfeedforsummary;
-(NSArray*)selectdiaperforsummary;
-(NSArray*)selectbathforsummary;
-(NSArray*)selectsleepforsummary;
-(NSArray*)selectplayforsummary;
-(NSString*)selectFromfeed;
-(NSString*)selectFrombath;
-(NSString*)selectFromsleep;
-(NSString*)selectFromplay;
-(NSString*)selectFromdiaper;


-(NSArray*)searchFromfeed:(NSDate*)start;
-(NSArray*)searchFromdiaper:(NSDate*)start;
-(NSArray*)searchFrombath:(NSDate*)start;
-(NSArray*)searchFromplay:(NSDate*)start;
-(NSArray*)searchFromsleep:(NSDate*)start;

+(int)selectFromUserAdvise:(int)advice_type;

-(BOOL)updatefeedOzorlr:(NSString*)ozorlr Remark:(NSString*)remark Starttime:(NSDate*)starttime;
-(BOOL)updatediaperStatus:(NSString*)status Remark:(NSString*)remark Starttime:(NSDate*)starttime;
-(BOOL)updatesleepRemark:(NSString*)remark Starttime:(NSDate*)starttime;
-(BOOL)updateplayRemark:(NSString*)remark Starttime:(NSDate*)starttime;
-(BOOL)updatebathRemark:(NSString*)remark Starttime:(NSDate*)starttime;
-(BOOL)updateUserAdvise:(int)advice_type S_Lock:(int)s_lock;

//Sumary使用
//+ (NSArray *)dataFromTable:(NSString *)table andFieldTag:(int)fileTag;
//+ (NSArray *)dataSourceFromDatabase:(int)fileTag;
+ (int)scrollWidth:(int)tag;
+ (NSArray *)scrollData:(int)scrollpage andTable:(NSString *)table andFieldTag:(int)fileTag;

+(NSArray*)selectbabyinfo:(int)age;

+(NSArray*)selectsuggestionbath:(int)s_lock;
+(NSArray*)selectsuggestiondiaper:(int)s_lock;
+(NSArray*)selectsuggestionsleep:(int)s_lock;
+(NSArray*)selectsuggestionplay:(int)s_lock;
+(NSArray*)selectsuggestionfeed:(int)s_lock;

-(BOOL)deleteWithStarttime:(NSDate*)starttime;
@end
