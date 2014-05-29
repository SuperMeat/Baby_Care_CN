//
//  save_feedview.h
//  Parenting
//
//  Created by user on 13-5-25.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodTypePickerView.h"
@protocol save_feedviewDelegate<NSObject>
@optional
-(void)sendFeedSaveChanged:(int)duration andstarttime:(NSDate*)newstarttime;
-(void)sendFeedReloadData;
@end

@interface save_feedview : UIView<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,FoodTypePickerViewDelegate>
{
    UIImageView *imageview;
    UITextField *Oztext;
    UITextView *remarktext;
    UITextField *durationtext;
    UITextField *datetext;
    UITextField *starttimetext;
    UITextField *foodtypetext;
    UILabel *Oz;
    UIButton *leftbutton;
    UIButton *rightbutton;
    UILabel *left;
    UILabel *right;
    
    UIDatePicker *datepicker;
    UIActionSheet *action;
    
    UIDatePicker *starttimepicker;
    UIActionSheet *action2;
    
    NSDate* curstarttime;
    long _createtime;
    long _updatetime;
    DurationPickerView *durationpicker;
    FoodTypePickerView *foodtypepicker;
    UIActionSheet *action3;
    UIActionSheet *action4;
    NSMutableArray *hours;
    NSMutableArray *minutes;
    UIImageView *remarkbg;
    UILabel *remark;
    UILabel *foodtypeLabel;
}

@property(nonatomic,strong)NSString *feedway;
@property(nonatomic,strong)NSString *breast;
-(id)initWithFrame:(CGRect)frame FeedWay:(NSString*)way Breasttype:(NSString*)type;
@property(nonatomic,assign)BOOL select;
@property(nonatomic,strong)NSDate *start;
@property int curduration;
@property int durationhour;
@property int durationmin;
@property int durationsec;
@property(nonatomic, copy)NSString *foodtype;
@property(nonatomic,assign)BOOL isshow;
@property (assign) id<save_feedviewDelegate> feedSaveDelegate;
-(id)initWithFrame:(CGRect)frame Select:(BOOL)_select Start:(NSDate*)_start Duration:(NSString*)_curduration UpdateTime:(long)updatetime CreateTime:(long)createtime;
-(void)Save;
-(void)loaddata;
@end
