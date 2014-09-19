//
//  InitBabyInfoViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-28.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InitBabyInfoDelegate <NSObject>

@optional
-(void)initHomeData;
@end

@interface InitBabyInfoViewController : UIViewController<UIImagePickerControllerDelegate,CustomIOS7AlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePicker;
    UIDatePicker *_datepicker;
    CustomIOS7AlertView *_action;
    
    __weak IBOutlet UIView *_TopView;
    __weak IBOutlet UIScrollView *_mainScrollView;
    
    
    
    __weak IBOutlet UIButton *_buttonSave;
    __weak IBOutlet UIImageView *_imageViewPic;
    __weak IBOutlet UITextField *_textFiledName;
    __weak IBOutlet UITextField *_textFiledBirth;
    __weak IBOutlet UITextField *_textFiledHeight;
    __weak IBOutlet UITextField *_textFiledWeight;
    __weak IBOutlet UITextField *_textFiledHS;
    __weak IBOutlet UITextField *_textFiledSex;
    __weak IBOutlet UIButton *_buttonMale;
    __weak IBOutlet UIButton *_buttonFemale; 
    
    UITextField* _tempTextField;
    double _oldYOffset;
    double _yOffset;
}
- (IBAction)save:(id)sender;
- (IBAction)selectPic:(id)sender;


- (IBAction)Radiobuttonselect:(id)sender;

@property (assign) id<InitBabyInfoDelegate> initBabyInfoDelegate;
@end
