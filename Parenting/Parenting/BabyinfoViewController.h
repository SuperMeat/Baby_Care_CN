//
//  BabyinfoViewController.h
//  Parenting
//
//  Created by user on 13-5-31.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BabyinfoViewController : UIViewController< UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIDatePicker *datepicker;
    UIImagePickerController *imagePicker;
    UIActionSheet *action;
    
}
@property (weak, nonatomic) IBOutlet UITextField *nametextfield;
@property (weak, nonatomic) IBOutlet UITextField *birthdaytextfield;
@property (weak, nonatomic) IBOutlet UIImageView *babyimageview;
@property (weak, nonatomic) IBOutlet UITextField *heighttextfield;
@property (weak, nonatomic) IBOutlet UITextField *weighttextfield;
@property (weak, nonatomic) IBOutlet UITextField *Headtextfield;
@property (weak, nonatomic) IBOutlet UITextField *standardheighttextfield;
@property (weak, nonatomic) IBOutlet UITextField *standardweighttextfield;
@property (weak, nonatomic) IBOutlet UITextField *standardhctextfield;

@property (weak, nonatomic) IBOutlet UIButton *SaveButton;
@property (weak, nonatomic) IBOutlet UITextField *gendertextfield;
@property (weak, nonatomic) IBOutlet UITextField *save;
@property (weak, nonatomic) IBOutlet UIButton *Femalebutton;
@property (weak, nonatomic) IBOutlet UIButton *Malebutton;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollview;
- (IBAction)Save:(id)sender;
- (IBAction)Radiobuttonselect:(id)sender;

+ (NSString*)getbabyage;

@end
