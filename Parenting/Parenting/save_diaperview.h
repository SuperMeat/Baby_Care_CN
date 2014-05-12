//
//  save_diaperview.h
//  Parenting
//
//  Created by user on 13-5-25.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaperPickerView.h"

@protocol save_diaperviewDelegate<NSObject>
@optional
-(void)sendDiaperSaveChanged:(NSString*)newstatus andstarttime:(NSDate*)newstarttime;
@end

@interface save_diaperview : UIView<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,DiaperPickerViewDelegate>
{
    UIImageView *imageview;
    UITextView *remarktext;
    UITextField *datetext;
    UITextField *starttimetext;
    UITextField *amounttext;
    UITextField *colortext;
    UITextField *hardtext;
    UIButton *dirty;
    UIButton *dry;
    UIButton *wet;

    UIDatePicker *datepicker;
    UIActionSheet *action;
    
    UIDatePicker *starttimepicker;
    UIActionSheet *action2;
    
    DiaperPickerView *diaperPickerView1;
    DiaperPickerView *diaperPickerView2;
    DiaperPickerView *diaperPickerView3;
    UIActionSheet *action3;
    UIActionSheet *action4;
    UIActionSheet *action5;
    UILabel *Hard;
    long _createtime;
    long _updatetime;
    NSDate* curstarttime;
    
}
@property(nonatomic,strong)NSString *status;
@property(nonatomic,assign)BOOL select;
@property(nonatomic,strong)NSDate *start;
@property(nonatomic,assign)BOOL isshow;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *color;
@property(nonatomic,copy)NSString *hard;

@property (assign) id<save_diaperviewDelegate> diaperSaveDelegate;
-(id)initWithFrame:(CGRect)frame Select:(BOOL)_select Start:(NSDate*)_start UpdateTime:(long)updatetime CreateTime:(long)createtime;
-(id)initWithFrame:(CGRect)frame Status:(NSString*)status;
-(void)loaddata;
@end
