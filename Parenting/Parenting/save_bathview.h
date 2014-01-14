//
//  save_bathview.h
//  Parenting
//
//  Created by user on 13-5-25.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DurationPickerView.h"
@protocol save_bathviewDelegate<NSObject>
@optional
-(void)sendBathSaveChanged:(int)duration andstarttime:(NSDate*)newstarttime;
@end


@interface save_bathview : UIView<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIImageView *imageview;
    UITextView *remarktext;
    UITextField *durationtext;
    UITextField *datetext;
    UITextField *starttimetext;
    
    UIDatePicker *datepicker;
    UIActionSheet *action;
    
    UIDatePicker *starttimepicker;
    UIActionSheet *action2;
    
    NSDate* curstarttime;
    
    DurationPickerView *durationpicker;
    UIActionSheet *action3;
    NSMutableArray *hours;
    NSMutableArray *minutes;

}
@property(nonatomic,assign)BOOL select;
@property(nonatomic,strong)NSDate *start;
@property int curduration;
@property int durationhour;
@property int durationmin;
@property int durationsec;
@property(nonatomic,assign)BOOL isshow;
@property (assign) id<save_bathviewDelegate> bathSaveDelegate;
-(id)initWithFrame:(CGRect)frame Select:(BOOL)_select Start:(NSDate*)_start Duration:(NSString*)_curduration;
-(void)Save;
-(void)loaddata;
@end
