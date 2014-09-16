//
//  InitCreateDB.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-9-16.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "InitCreateDB.h"

@implementation InitCreateDB



+(void)create_CalendarDB{
    InitCreateDB *initDb = [[InitCreateDB alloc]init];
    [initDb create_testDB];
    [initDb create_vaccineDB];
    [initDb create_note];
}

-(void)create_testDB{
    [BaseSQL addDatas_test];
}

-(void)create_vaccineDB{
    [BaseSQL createTable_vaccine];
    NSDate* birthdayDate = [BaseMethod dateFormString:kBirthday];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"VaccineData" ofType:@"plist"];
    NSArray* datas = [NSArray arrayWithContentsOfFile:filePath];
    int index = 0;
    for (NSDictionary* dic in datas) {
        index++;
        VaccineModel* model = [[VaccineModel alloc] init];
        model.vaccine = [dic objectForKey:@"vaccine"];
        model.illness = [dic objectForKey:@"illness"];
        model.times = [dic objectForKey:@"times"];
        model.inplan = [NSNumber numberWithBool:YES];
        model.completed = [NSNumber numberWithBool:NO];
        model.id = [NSNumber numberWithInt:index];
        
        
        int month = [[dic objectForKey:@"month"] intValue];
        NSDate* date = [BaseMethod fromCurDate:birthdayDate withMonth:month];
        model.willDate = [BaseMethod stringFromDate:date];
        
        //超过接种一天以上时间默认接种
        long curTimeStamp = [ACDate getTimeStampFromDate:[ACDate date]];
        long willDateTimeStamp = [ACDate getTimeStampFromDate:date];
        if ((curTimeStamp - 86400)> willDateTimeStamp)
        {
            model.completedDate = model.willDate;
            model.completed     = [NSNumber numberWithInt:1];
        }
         
        // 保存数据库
        [BaseSQL insertData_vaccine:model];
        
    }
}

-(void)create_note{
    [BaseSQL createTable_note];
}
@end
