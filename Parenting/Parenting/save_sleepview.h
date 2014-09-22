//
//  save_sleepview.h
//  Parenting
//
//  Created by user on 13-5-25.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DurationPickerView.h"

@protocol save_sleepviewDelegate<NSObject>
@optional
-(void)sendSleepSaveChanged:(int)duration andstarttime:(NSDate*)newstarttime;
-(void)sendSleepReloadData;
@end

@interface save_sleepview : UIView<UITextViewDelegate,UITextFieldDelegate,CustomIOS7AlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIImageView *imageview;
    UITextView  *remarktext;
    UITextField *durationtext;
    UITextField *datetext;
    UITextField *starttimetext;
    
    UIDatePicker *datepicker;
    CustomIOS7AlertView *action;
    
    UIDatePicker *starttimepicker;
    CustomIOS7AlertView *action2;
    
    NSDate* curstarttime;
    long _createtime;
    long _updatetime;
    DurationPickerView *durationpicker;
    CustomIOS7AlertView *action3;
    NSMutableArray *hours;
    NSMutableArray *minutes;
    
    NSString *olddate;
    NSString *oldstarttime;
    NSString *oldduartion;
    
}
@property(nonatomic,assign)BOOL select;
@property(nonatomic,strong)NSDate *start;
@property int curduration;
@property int durationhour;
@property int durationmin;
@property int durationsec;
@property(nonatomic,assign)BOOL isshow;
@property (assign) id<save_sleepviewDelegate> sleepSaveDelegate;
-(id)initWithFrame:(CGRect)frame Select:(BOOL)_select Start:(NSDate*)_start Duration:(NSString*)_curduration UpdateTime:(long)updatetime CreateTime:(long)createtime;
-(void)Save;
-(void)loaddata;
@end
