/*
 *  2014/08/25 - 时间轴内容
 *
 *  0:系统消息
 *
 *  **** 提醒根据时间节点判断进行添删 ****
 *  key:代表该目标ID
 *  1:用户自定义提醒
 *  10:疫苗提醒
 *  11:评测提醒
 *  12:日志提醒
 *  20:生理-身高记录提醒
 *  21:生理-体重记录提醒
 *  22:生理-头围记录提醒
 *
 *  **** 贴士推送 ****
 *  key:代表该贴士ID
 *  99:贴士推送-（根据用户及贴士属性推送）
 *
 */

#import "InitTimeLineData.h"
#import "BaseSQL.h"

@implementation InitTimeLineData

+(id)initTimeLineData
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

+(NSArray*)getTimeLineData{
    InitTimeLineData *initDs = [InitTimeLineData initTimeLineData];
    
    /** 检测用户自定义提醒:1 **/
    [initDs checkUserRemind];
    /** 检测疫苗提醒:10 **/
    [initDs checkBabyVaccine];
    /** 检测评测提醒:11 **/
    [initDs checkBabyEvaluating];
    /** 检测日志提醒:12 **/
    [initDs checkBabyLog];
    /** 检测身高记录提醒:20 **/
    [initDs checkBabyHeight];
    /** 检测体重记录提醒:21 **/
    [initDs checkBabyWeight];
    /** 检测头围记录提醒:22 **/
    [initDs checkBabyHS];
    /** 检测系统消息:0 **/
    [initDs checkSysMsg];
    
    /** 检测贴士推送:99 **/
    [initDs checkTips];
    
    NSArray *res = [[NSMutableArray alloc]initWithArray:[[BabyMessageDataDB babyMessageDB]selectAll]];
    return res;
}

/** 检测系统消息:0 **/
//key = version
-(void)checkSysMsg{
    int msgType = 0;
    NSString *version = [[NSUserDefaults standardUserDefaults] stringForKey:@"GUIDE_V"];
    if (![[BabyMessageDataDB babyMessageDB] isSysUpdateMsgExist:version]) {
        NSString *msgContent = [NSString stringWithFormat:@"欢迎使用母婴助手%@版本!",version];
        [[BabyMessageDataDB babyMessageDB] insertBabyMessageNormal:[ACDate getTimeStampFromDate:[NSDate date]] UpdateTime:[ACDate getTimeStampFromDate:[NSDate date]] key:version type:msgType content:msgContent];
    }
}

/** 检测用户自定义提醒:1 **/
-(void)checkUserRemind{
    
}

 /** 检测疫苗提醒:10 **
 *  一个疫苗只插入一次消息库
 *  在每5、3、1天的时候提醒只更新消息表库中对应消息的内容及create_time
 *  key:id 疫苗ID
 */
-(void)checkBabyVaccine{
    int msgType = 10;
    NSArray *array = [BaseSQL queryData_vaccine_recent];
    if ([array count] == 0)
        return;
    
    for (int i=0; i<[array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        int targetId = [[dic objectForKey:@"id"] intValue];
        int days = [[dic objectForKey:@"days"] intValue];
        NSString* vaccinceName = [dic objectForKey:@"vaccine"];
        
        // res:0 该条提醒未入库->入库 | 1 该条提醒已入库->更新 | -1 不需操作
        int res = [[BabyMessageDataDB babyMessageDB] isVaccineExistWithKey:targetId Days:days];
        NSString *msgContent = [NSString stringWithFormat:@"%d天后宝宝要接种%@哦!",days,vaccinceName];
        if (res == 0 || res == 1) {
            [[BabyMessageDataDB babyMessageDB] insertBabyMessageNormal:[ACDate getTimeStampFromDate:[NSDate date]] UpdateTime:[ACDate getTimeStampFromDate:[NSDate date]] key:[NSString stringWithFormat:@"%d",targetId] type:msgType content:msgContent];
        }
    }
}

/** 检测评测提醒:11 **/
/** key:month 月份 **/
-(void)checkBabyEvaluating{
    int msgType = 11;
    NSDictionary *dict = [[BabyDataDB babyinfoDB]selectBabyInfoByBabyId:BABYID];
    long birth_time = [[dict objectForKey:@"birth"] longValue];
    int months = [ACDate getDiffMonthFromBirth:[ACDate getDateFromTimeStamp:birth_time]];
    int days = [ACDate getday:[NSDate date]];
    //当月评测是否未完成
    if (([BaseSQL isFinishTestWithMonth:months] && days >= 25) && [[BabyMessageDataDB babyMessageDB] isTestExistTodayWithKey:months] == 0) {
        NSString *msgContent = [NSString stringWithFormat:@"宝宝第%d月的评测开始啦!",months];
        [[BabyMessageDataDB babyMessageDB] insertBabyMessageNormal:[ACDate getTimeStampFromDate:[NSDate date]] UpdateTime:[ACDate getTimeStampFromDate:[NSDate date]] key:[NSString stringWithFormat:@"%d",months] type:msgType content:msgContent];
    }
}
/** 检测日志提醒:12 **/
/** key=nil **/
-(void)checkBabyLog{
    int msgType = 12;
    if (![BaseSQL isNoteRecent] && [[BabyMessageDataDB babyMessageDB] isNoteRemind]) {
        NSString *msgContent = @"好久没有记录日志啦,麻麻快点把心情记录下来呗?";
        [[BabyMessageDataDB babyMessageDB] insertBabyMessageNormal:[ACDate getTimeStampFromDate:[NSDate date]] UpdateTime:[ACDate getTimeStampFromDate:[NSDate date]] key:@"" type:msgType content:msgContent];
    }
}
/** 检测身高记录提醒:20 **/
-(void)checkBabyHeight{
    int msgType = 20;
    NSArray *arrHeight = [[BabyDataDB babyinfoDB] selectBabyPhysiologyList:0];
    NSDictionary *dic = [arrHeight firstObject];
    NSDate *lastRecordDate = [ACDate getDateFromTimeStamp:[[dic objectForKey:@"measure_time"] longValue]];
    int days = [ACDate getday:[NSDate date]];
    //case 1:phyHeight表中该月没有记录
    if ([ACDate getDiffMonthFromDate:lastRecordDate] != 0)//该月无记录
    {
        //case 2:本月最后5天且当天未提醒
        if (days >= 25 && ([[BabyMessageDataDB babyMessageDB] isPhyExistTodayWithType:msgType] == 0)) {
            NSString *msgContent = @"本月尚未记录宝宝身高,要记得哦!";
            [[BabyMessageDataDB babyMessageDB] insertBabyMessageNormal:[ACDate getTimeStampFromDate:[NSDate date]] UpdateTime:[ACDate getTimeStampFromDate:[NSDate date]] key:@"" type:msgType content:msgContent];
        }
    }
}
/** 检测体重记录提醒:21 **/
-(void)checkBabyWeight{
    int msgType = 21;
    NSArray *arrHeight = [[BabyDataDB babyinfoDB] selectBabyPhysiologyList:1];
    NSDictionary *dic = [arrHeight firstObject];
    NSDate *lastRecordDate = [ACDate getDateFromTimeStamp:[[dic objectForKey:@"measure_time"] longValue]];
    int days = [ACDate getday:[NSDate date]];
    //case 1:phyHeight表中该月没有记录
    if ([ACDate getDiffMonthFromDate:lastRecordDate] != 0)//该月无记录
    {
        //case 2:本月最后5天且当天未提醒
        if (days >= 25 && ([[BabyMessageDataDB babyMessageDB] isPhyExistTodayWithType:msgType]==0)) {
            NSString *msgContent = @"本月尚未记录宝宝体重,要记得哦!";
            [[BabyMessageDataDB babyMessageDB] insertBabyMessageNormal:[ACDate getTimeStampFromDate:[NSDate date]] UpdateTime:[ACDate getTimeStampFromDate:[NSDate date]] key:@"" type:msgType content:msgContent];
        }
    }
}
/** 检测头围记录提醒:22 **/
-(void)checkBabyHS{
    return;
}
/** 检测贴士推送:99 **/
-(void)checkTips{
    
}

@end
