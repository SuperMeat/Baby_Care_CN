//
//  save_diaperview.h
//  Parenting
//
//  Created by user on 13-5-25.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol save_diaperviewDelegate<NSObject>
@optional
-(void)sendDiaperSaveChanged:(NSString*)newstatus andstarttime:(NSDate*)newstarttime;
@end

@interface save_diaperview : UIView<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    UIImageView *imageview;
    UITextView *remarktext;
    UITextField *datetext;
    UITextField *starttimetext;
    UIButton *dirty;
    UIButton *dry;
    UIButton *wet;

    UIDatePicker *datepicker;
    UIActionSheet *action;
    
    UIDatePicker *starttimepicker;
    UIActionSheet *action2;
    
    NSDate* curstarttime;
    
}
@property(nonatomic,strong)NSString *status;
@property(nonatomic,assign)BOOL select;
@property(nonatomic,strong)NSDate *start;
@property(nonatomic,assign)BOOL isshow;
@property (assign) id<save_diaperviewDelegate> diaperSaveDelegate;
-(id)initWithFrame:(CGRect)frame Select:(BOOL)_select Start:(NSDate*)_start;
-(id)initWithFrame:(CGRect)frame Status:(NSString*)status;
-(void)loaddata;
@end
