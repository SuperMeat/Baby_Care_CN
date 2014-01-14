//
//  UMFeedbackViewController.h
//  UMeng Analysis
//
//  Created by liu yu on 7/12/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMFeedback.h"
#import "UMEGORefreshTableHeaderView.h"


@interface UMFeedbackViewController : UIViewController <UMFeedbackDataDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate> {
    UMFeedback *feedbackClient;
    BOOL _reloading;
    UMEGORefreshTableHeaderView *_refreshHeaderView;
    CGFloat _tableViewTopMargin;
    BOOL _shouldScrollToBottom;
    
    UIActionSheet *action_age;
    UIActionSheet *action_sex;
}

//性别年龄

@property (retain, nonatomic) IBOutlet UILabel *labelBaseInfo;
@property (retain, nonatomic) IBOutlet UITextField *ageText;
@property (retain, nonatomic) IBOutlet UITextField *sexText;
@property (strong, nonatomic) NSArray *pickerDS_sex;
@property (strong, nonatomic) NSArray *pickerDS_age;
@property (strong, nonatomic) UIPickerView *picker_sex;
@property (strong, nonatomic) UIPickerView *picker_age;
@property (retain, nonatomic) IBOutlet UIView *ageAndsexView;

@property(nonatomic, retain) IBOutlet UITableView *mTableView;
@property(nonatomic, retain) IBOutlet UIToolbar *mToolBar;
@property(nonatomic, retain) IBOutlet UIView *mContactView;


@property(nonatomic, retain) UITextField *mTextField;
@property(nonatomic, retain) UIBarButtonItem *mSendItem;
@property(nonatomic, retain) NSArray *mFeedbackData;
@property(nonatomic, copy) NSString *appkey;

- (IBAction)sendFeedback:(id)sender;
@end
