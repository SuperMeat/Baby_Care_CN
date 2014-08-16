//
//  PublicDefine.h
//  MySafedog
//
//  Created by Will on 13-12-26.
//  Copyright (c) 2013年 will. All rights reserved.
//

#ifndef MySafedog_PublicDefine_h
#define MySafedog_PublicDefine_h

#import "BaseMethod.h"
#import "UIBarButtonItem+CustomForNav.h"
#import "FMDatabase.h"
#import "CustomIOS7AlertView.h"
#import "BaseSQL.h"
#import "LoadingView.h"
#import "BaseView.h"
#import "MyNoteView.h"
#import "BabyinfoViewController.h"

#define kDeviceWidth    [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight   [UIScreen mainScreen].bounds.size.height
#define kSystemVersion  [[UIDevice currentDevice].systemVersion floatValue]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kColor_green                 0x00b26f

/************baseView************/
#define kColor_baseView              0xf6f6f6
/************日记************/
#define kColor_note_line             0x69becd

/************日历************/
#define kColor_calendarDay_num       0x828687
#define kColor_calendar_line         0xcccccc
#define kColor_cal_selectedDate      0x69becd
#define kColor_cal_today             0x69becd
#define kColor_cal_note              0x64acd8
#define kColor_cal_mileastone        0xe2b94a
#define kColor_cal_val               0xf59797
#define kColor_cal_train             0xfe985a
#define kColor_cal_test              0x86be81
#define kColor_cal_set               0x8190ed

/************里程碑************/
#define kColor_milestone_detailText  0x7bc8d3
#define kColor_milestone_add_title   0xfffffd
#define kColor_milestone_add_date    0x3e8d9a

/************疫苗************/
#define kColor_inplan                0x7bc8d3
#define kColor_outplan               0xf477b4
#define kColor_val_infoText          0x888888
#define kColor_val_detail_headText   0x5aacba
#define kColor_val_cell_title        0x7d7d7d
#define kColor_val_headView          0xe6e6e6
/************测评************/
#define kColor_test_knowledge        0x67b3df
#define kColor_test_active           0x8d91ec
#define kColor_test_mood             0xfd9959
#define kColor_test_society          0x85bf80
#define kColor_test_headBg           0x7ed2df
#define kColor_test_TextViewText     0x5f5f5f
#define kColor_testReport_month      0x69becd
#define kColor_testReport_score      0xfe5474
#define kColor_Zheline               0xd6d6d6
#define kColor_Zheline_val           0x909090
#define kColor_testReport_PIBg       0xacacac
/************训练************/
#define kColor_train_cell_title      0x7d7d7d
/************全局************/
#define kColor_textViewText          0x585858
// 字体
// 微软雅黑
#define kFont                        @"MicrosoftYaHei"

#define kDisTime                     15  // 15分钟间隔
#define kConfigDisTime               45
#define kBy                          13  // 单位长度
#define kDis_right_width             20                                    

// 出生日期
#define kBirthday                       ([BabyinfoViewController getbabybirth])

// event/Train
#define kFontsize_untrain_content       12.0f

#define kAnswer_can                     1
#define kAnswer_cannot                  2
#define kAnswer_unclear                 3


#define kSelectedDate                   @"kSelectedDate"
#define kToday_unselected               @"kToday_unselected"
#define kPush_testReportVc              @"kPush_testReportVc"


#define kDateFormat                     @"yyyy年MM月dd日"

#define kTitle_none                     @"标题不能为空"
#define kContent_none                   @"内容不能为空"
#define kSave_success                   @"保存成功"
#define kSave_fail                      @"保存失败"

#define kPhoto_first                    @"已经是第一个里程碑了"
#define kPhoto_last                     @"已经是最后一个里程碑了"

#define kKnowledge                      @"认知能力的培养"
#define kActive                         @"动作能力的培养"
#define kLive                           @"习惯和生活能力的培养"
#define kSociety                        @"社会交往能力的培养"
// notifi
#define kNotifi_milestone_home           @"kNotifi_milestone_home"
#define kNotifi_milestone_initDatas      @"kNotifi_milestone_initDatas"
#define kNotifi_milestone_reloadTab      @"kNotifi_milestone_reloadTab"

#define kNotifi_reload_list_vaccine      @"kNotifi_reload_list_vaccine"
#define kNotifi_reload_add_vaccine       @"kNotifi_reload_add_vaccine"

#define kNotifi_reload_SQLDatas          @"kNotifi_reload_SQLDatas"
#define kNotifi_reload_calendarView      @"kNotifi_reload_calendarView"

#define kNotifi_next_test                @"kNotifi_next_test"
#define kNotifi_done_test                @"kNotifi_done_test"

#define kTest_type_knowledge             @"认知"
#define kTest_type_active                @"动作"
#define kTest_type_language              @"语言"
#define kTest_type_society               @"社交"

#define kTodayRow                        @"kTodayRow"

/**
 *  分享的image尺寸
 */
#define kShareImageWidth_Note 320              //日记分享宽度
#define kShareImageHeight_Note 360             //日记分享高度
#define kShareImageWidth_Milestone  320        //日记分享宽度
#define kShareImageHeight_Milestone 400        //日记分享高度

#define kShareImageFontSize        15
#define kShareImageFontColor       @"#338f9f"
#define kShareImageIconFontColor   @"#858585"
#define kShareImageBackgroundColor @"#ecf4f5"

typedef enum
{
    creatMilestoneType_model,
    creatMilestoneType_new,
}creatMilestoneType;


#endif
