//
//  BabyBaseInfoView.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BabyBaseInfoView : UIView<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIImageView *imageview;
    UITextField *textNickname;
    UITextField *textBirth;
    UITextField *textSex;
    UIButton *buttonFemale;
    UIButton *buttonMale;
    UIButton *buttonSave;
    UIButton *buttonCancel;
    
    UIDatePicker *datepicker;
    UIActionSheet *action;
}

@end
