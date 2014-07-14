//
//  save_medicineview.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-7-11.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol save_medicineviewDelegate<NSObject>
@optional
-(void)sendMedicineSaveChanged:(int)duration andstarttime:(NSDate*)newstarttime;
-(void)sendMedicineReloadData;
@end
@interface save_medicineview : UIView
<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    UIImageView *imageview;
    UITextView *remarktext;
    UITextField *starttimetext;
    
    UIDatePicker *starttimepicker;
    UIActionSheet *action2;
    
    NSDate* curstarttime;
    long _createtime;
    long _updatetime;
    UIImageView *remarkbg;
    UILabel *remark;
}

@property(nonatomic,assign)BOOL  select;
@property(nonatomic,strong)NSDate *start;
@property int curduration;
@property int durationhour;
@property int durationmin;
@property int durationsec;
@property(nonatomic,assign)BOOL isshow;
@property (assign) id<save_medicineviewDelegate> medicineSaveDelegate;
- (id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame Select:(BOOL)select Start:(NSDate*)start UpdateTime:(long)updatetime CreateTime:(long)createtime;
-(void)Save;
-(void)loaddata;

@end
