//
//  save_medicineview.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-7-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol save_medicineviewDelegate<NSObject>
@optional
-(void)sendMedicineSaveChanged:(NSString*)medicinename andAmount:(NSString*)amount andIsReminder:(BOOL)isReminder andstarttime:(NSDate*)newstarttime;
-(void)sendMedicineReloadData;
@end
@interface save_medicineview : UIView<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
UIImageView *imageview;
UITextField *medicinedesptext;
UITextField *datetext;
UITextField *medicinenametext;
UITextField *amounttext;
UITextField *danweitext;
UITextField *timeinternaltext;

UIButton    *setNextTimeButton;
UIDatePicker *datepicker;
UIActionSheet *action;

NSDate* curstarttime;
long _createtime;
long _updatetime;
BOOL isReminder;
}

@property(nonatomic,strong)NSString *feedway;
-(id)initWithFrame:(CGRect)frame FeedWay:(NSString*)way Breasttype:(NSString*)type;
@property(nonatomic,assign)BOOL select;
@property(nonatomic,strong)NSDate *start;
@property int curduration;
@property int durationhour;
@property int durationmin;
@property int durationsec;
@property(nonatomic, copy)NSString *foodtype;
@property(nonatomic,assign)BOOL isshow;
@property (assign) id<save_medicineviewDelegate> medicineSaveDelegate;
-(id)initWithFrame:(CGRect)frame Select:(BOOL)_select Start:(NSDate*)_start Duration:(NSString*)_curduration UpdateTime:(long)updatetime CreateTime:(long)createtime;
-(void)Save;
-(void)loaddata;

@end
