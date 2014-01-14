//
//  CustomNotifyViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-12-18.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalNotify.h"
#import "CustonTimeViewController.h"

@interface CustomNotifyViewController : UIViewController< UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate, CustonTimeViewControllerDelegate>
{
    NSMutableArray *hours;
    NSMutableArray *minutes;
    BOOL isNew;
    
    UIPickerView *durationpicker;
    UIActionSheet *action3;
    
    BOOL ischanged;
}
@property (strong, nonatomic) IBOutlet UILabel *labelRedundant;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UITextField  *textfieldTitleTip;
@property (strong, nonatomic) IBOutlet UITextField  *textfieldTimeTip;
@property (strong, nonatomic) IBOutlet UITextField  *textfieldRedundant;
@property (strong, nonatomic) IBOutlet UIButton     *btnsave;
- (IBAction)save:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton     *btnredundant;
- (IBAction)setredundant:(UIButton *)sender;
@property (strong, nonatomic) LocalNotify *ln;
@property (strong, nonatomic) CustonTimeViewController *ctvc;
@property int durationhour;
@property int durationmin;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) UILabel *labelredundant;
-(void)setLocalNotify:(LocalNotify*)ln;

@end
