//
//  TempSaveView.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-11.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempSaveView : UIView<UITextFieldDelegate,UIActionSheetDelegate>
{
    NSString *strType;
    
    UIImageView *imageview;
    UITextField *textRecordDate;
    UITextField *textRecordTime;
    UITextField *textValue;
    UIButton *buttonSave;
    UIButton *buttonCancel;
    
    UIDatePicker *datepicker;
    UIActionSheet *action;
    UIDatePicker *timepicker;
    UIActionSheet *action2;
}

- (id)initWithFrame:(CGRect)frame Type:(NSString *)type;
@end
