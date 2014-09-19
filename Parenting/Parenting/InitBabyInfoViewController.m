//
//  InitBabyInfoViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-28.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "InitBabyInfoViewController.h"
#import "InitCreateDB.h"
#define _SHOW_HEIGHT 170

@interface InitBabyInfoViewController ()

@end

@implementation InitBabyInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        //self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)initView{
    
    #define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
    
    if (DEVICE_IS_IPHONE5) {
        _TopView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
        
    }else{
        _TopView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170);
    }
    
    
    _mainScrollView.frame = CGRectMake(0, _TopView.height,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _TopView.height);
    
    _imageViewPic.layer.masksToBounds = YES;
    _imageViewPic.layer.cornerRadius = 57.0;
    _imageViewPic.userInteractionEnabled=YES;
    _imageViewPic.clipsToBounds=YES;
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ActionSheetShow)];
    [_imageViewPic addGestureRecognizer:tapgesture];
    _imagePicker=[[UIImagePickerController alloc]init];
    
    [_mainScrollView setContentSize:CGSizeMake(320, 500)];
    
    _textFiledName.leftViewMode=UITextFieldViewModeAlways;
    _textFiledBirth.leftViewMode=UITextFieldViewModeAlways;
    _textFiledHeight.leftViewMode=UITextFieldViewModeAlways;
    _textFiledWeight.leftViewMode=UITextFieldViewModeAlways;
    _textFiledHS.leftViewMode=UITextFieldViewModeAlways;
    _textFiledSex.leftViewMode=UITextFieldViewModeAlways;
    
    UILabel *lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    lable1.text= @"姓名";
    lable1.textAlignment=NSTextAlignmentRight;
    lable1.backgroundColor=[UIColor clearColor];
    lable1.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    _textFiledName.leftView=lable1;
    
    [_textFiledName setValue:[NSNumber numberWithInt:2] forKey:@"paddingTop"];
    [_textFiledName setValue:[NSNumber numberWithInt:15] forKey:@"paddingLeft"];
    [_textFiledName setValue:[NSNumber numberWithInt:0] forKey:@"paddingBottom"];
    [_textFiledName setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    [_textFiledName setTextColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]];
    
    
    UILabel *lable2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    lable2.text=@"出生日期";
    lable2.textAlignment=NSTextAlignmentRight;
    lable2.backgroundColor=[UIColor clearColor];
    lable2.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    _textFiledBirth.leftView=lable2;
    
    [_textFiledBirth setValue:[NSNumber numberWithInt:2] forKey:@"paddingTop"];
    [_textFiledBirth setValue:[NSNumber numberWithInt:15] forKey:@"paddingLeft"];
    [_textFiledBirth setValue:[NSNumber numberWithInt:0] forKey:@"paddingBottom"];
    [_textFiledBirth setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    [_textFiledBirth setTextColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]];
    
    _textFiledBirth.userInteractionEnabled=YES;
    
    
    UILabel *lable4=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    lable4.text=@"当前身高";
    lable4.textAlignment=NSTextAlignmentRight;
    lable4.backgroundColor=[UIColor clearColor];
    lable4.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    _textFiledHeight.leftView=lable4;
    
    [_textFiledHeight setValue:[NSNumber numberWithInt:2] forKey:@"paddingTop"];
    [_textFiledHeight setValue:[NSNumber numberWithInt:15] forKey:@"paddingLeft"];
    [_textFiledHeight setValue:[NSNumber numberWithInt:0] forKey:@"paddingBottom"];
    [_textFiledHeight setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    [_textFiledHeight setTextColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]];
    
    
    UILabel *lable5=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    lable5.text=@"当前体重";
    lable5.textAlignment=NSTextAlignmentRight;
    lable5.backgroundColor=[UIColor clearColor];
    lable5.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    _textFiledWeight.leftView=lable5;
    
    [_textFiledWeight setValue:[NSNumber numberWithInt:2] forKey:@"paddingTop"];
    [_textFiledWeight setValue:[NSNumber numberWithInt:15] forKey:@"paddingLeft"];
    [_textFiledWeight setValue:[NSNumber numberWithInt:0] forKey:@"paddingBottom"];
    [_textFiledWeight setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    [_textFiledWeight setTextColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]];
    
    
    UILabel *lable6=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    lable6.text=@"当前头围";
    lable6.textAlignment=NSTextAlignmentRight;
    lable6.backgroundColor=[UIColor clearColor];
    lable6.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    _textFiledHS.leftView=lable6;
    
    [_textFiledHS setValue:[NSNumber numberWithInt:2] forKey:@"paddingTop"];
    [_textFiledHS setValue:[NSNumber numberWithInt:15] forKey:@"paddingLeft"];
    [_textFiledHS setValue:[NSNumber numberWithInt:0] forKey:@"paddingBottom"];
    [_textFiledHS setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    [_textFiledHS setTextColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]];
    
    
    UILabel *lable3=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    lable3.text=@"性别";
    lable3.textAlignment=NSTextAlignmentRight;
    lable3.backgroundColor=[UIColor clearColor];
    lable3.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    _textFiledSex.leftView=lable3;
    
    
    _buttonMale.tag=101;
    _buttonFemale.tag=102;
    [_buttonMale setTitleColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0] forState:UIControlStateNormal];
    [_buttonFemale setTitleColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]forState:UIControlStateNormal];
    
    [_buttonMale setImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
    [_buttonFemale setImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
    _buttonMale.contentMode=UIViewContentModeScaleAspectFit;
    _buttonFemale.contentMode=UIViewContentModeScaleAspectFit;
    [_buttonFemale setImage:[UIImage imageNamed:@"radio_focus.png"] forState:UIControlStateDisabled];
    [_buttonMale setImage:[UIImage imageNamed:@"radio_focus.png"] forState:UIControlStateDisabled];
    
    [_buttonSave setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    _buttonSave.layer.cornerRadius = 5.0f;
    [_buttonSave setTitle:NSLocalizedString(@"Save",nil) forState:UIControlStateNormal];
}

- (IBAction)Radiobuttonselect:(id)sender {
    UIButton *button=(UIButton*)sender;
    button.enabled=NO;
    button.titleLabel.textColor=[UIColor whiteColor];
    UIButton *another;
    
    if (button.tag==101) {
        another=(UIButton*)[self.view viewWithTag:102];
        
    }
    else
    {
        another=(UIButton*)[self.view viewWithTag:101];
    }
    another.enabled=YES;
    another.titleLabel.textColor=[UIColor grayColor];
    
}

- (IBAction)save:(id)sender {
    if ([_textFiledBirth.text  isEqual: @""] || [_textFiledName.text isEqual:@""] || (_buttonMale.enabled == YES && _buttonFemale.enabled == YES)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"亲爱的粑粑麻麻,宝宝姓名、出生日期及性别一定要填写哦!" delegate:nil cancelButtonTitle:@"马上更正" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (![_textFiledBirth.text  isEqual: @""]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *birth = [formatter dateFromString:_textFiledBirth.text];
        [[BabyDataDB babyinfoDB] updateBabyBirth:[ACDate getTimeStampFromDate:birth] BabyId:BABYID];
    }
    if (![_textFiledName.text isEqual:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:_textFiledName.text forKey:@"kBabyNickname"]; 
        [[BabyDataDB babyinfoDB] updateBabyInfoName:_textFiledName.text BabyId:BABYID];
    }
    if (_buttonMale.enabled == NO) {
        [[BabyDataDB babyinfoDB] updateBabySex:1 BabyId:BABYID];
    }
    else if (_buttonFemale.enabled == NO) {
        [[BabyDataDB babyinfoDB] updateBabySex:0 BabyId:BABYID];
    }
    
    if (![_textFiledHeight.text isEqualToString:@""]) {
        [[BabyDataDB babyinfoDB] insertBabyPhysiology:[ACDate getTimeStampFromDate:[ACDate date]] UpdateTime:[ACDate getTimeStampFromDate:[ACDate date]] MeasureTime:[ACDate getTimeStampFromDate:[ACDate date]] Type:0 Value:[_textFiledHeight.text doubleValue]];
    }
    
    if (![_textFiledWeight.text isEqualToString:@""]) {
        [[BabyDataDB babyinfoDB] insertBabyPhysiology:[ACDate getTimeStampFromDate:[ACDate date]] UpdateTime:[ACDate getTimeStampFromDate:[ACDate date]] MeasureTime:[ACDate getTimeStampFromDate:[ACDate date]] Type:1 Value:[_textFiledWeight.text doubleValue]];
    }
    
    if (![_textFiledHS.text isEqualToString:@""]) {
        [[BabyDataDB babyinfoDB] insertBabyPhysiology:[ACDate getTimeStampFromDate:[ACDate date]] UpdateTime:[ACDate getTimeStampFromDate:[ACDate date]] MeasureTime:[ACDate getTimeStampFromDate:[ACDate date]] Type:3 Value:[_textFiledHS.text doubleValue]];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
    //日历相关数据创建
    [InitCreateDB create_CalendarDB];
    
    [self.initBabyInfoDelegate initHomeData];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _tempTextField = textField;
    if (textField == _textFiledBirth)
    {
        [self actionsheetShow];
        [_textFiledBirth resignFirstResponder];
    }
}


-(void)actionsheetShow
{
    if (_action == nil) {
        _action = [[CustomIOS7AlertView alloc] init];
        [_action setContainerView:[self createDateView]];
        [_action setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        [_action setDelegate:self];
    }
    
    [_action show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView == _action)
        {
            [self updatebirsthday:_datepicker];
        }
    }
    
    [alertView close];
    
}

- (UIDatePicker*)createDateView
{
    if (_datepicker==nil) {
        _datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, _textFiledBirth.frame.origin.y+45+G_YADDONVERSION, 320, 162)];
        _datepicker.datePickerMode=UIDatePickerModeDate;
        [_datepicker addTarget:self action:@selector(updatebirsthday:) forControlEvents:UIControlEventValueChanged];
    }
    
    _datepicker.frame=CGRectMake(0, 0, 320, 162);
    
    return _datepicker;
}


-(void)updatebirsthday:(UIDatePicker*)sender{
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    _textFiledBirth.text=[dateFormater stringFromDate:sender.date];
}

-(void)keyboradshow
{
    _oldYOffset = _mainScrollView.contentOffset.y;
    _yOffset = 0;
    if (_textFiledName == _tempTextField) {
        _yOffset = 0;
    }
    else if (_textFiledHeight == _tempTextField){
        _yOffset = 90;
    }
    else if (_textFiledWeight == _tempTextField){
        _yOffset = 135;
    }
    else if (_textFiledHS == _tempTextField){
        _yOffset = 180;
    }
    if (_yOffset != 0) {
        [_mainScrollView setContentOffset:CGPointMake(0, _yOffset) animated:YES];
    }
}

-(void)keyboradhidden
{
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    _mainScrollView.contentOffset=CGPointMake(_mainScrollView.contentOffset.x, _oldYOffset);
    [UIView commitAnimations];
}

- (void)keyboardWillShown:(NSNotification*)aNotification{
//    [self keyboradshow];
}

-(void)keyboardWillHidden:(NSNotification*)aNotification
{
    //[self keyboradhidden];
}

- (IBAction)selectPic:(id)sender {
    [self ActionSheetShow];
}

- (IBAction)selectMale:(id)sender {
}

- (IBAction)selectFemale:(id)sender {
}

-(void)refreshPic{
    NSFileManager *fileManage = [[NSFileManager alloc] init];
    if ([fileManage fileExistsAtPath:BABYICONPATH(ACCOUNTUID, BABYID)]) {
        _imageViewPic.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:BABYICONPATH(ACCOUNTUID, BABYID)]];
    }
}

-(void)ActionSheetShow
{
    UIActionSheet *action1=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle",nil) destructiveButtonTitle:NSLocalizedString(@"Camera",nil) otherButtonTitles:NSLocalizedString(@"Photo",nil), nil];
    [action1 showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==[actionSheet destructiveButtonIndex]) {
        [self imageSelectFromCamera];
    }
    else if (buttonIndex==1)
    {
        [self imageSelect];
    }
}

-(void)imageSelectFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        _imagePicker.allowsEditing=YES;
        _imagePicker.delegate=self;
        
        if ([ACFunction getSystemVersion] >= 7.0) {
            [_imagePicker.view setFrame:CGRectMake(0, 0, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [_imagePicker.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
            
            [self.view addSubview:_imagePicker.view];
        }
        else
        {
            [_imagePicker.view setFrame:CGRectMake(0, 0, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [_imagePicker.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
            
            [self.view addSubview:_imagePicker.view];
            
        }
    }
    else
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"相机不可用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    }
}
-(void)imageSelect
{
    //NSLog(@"imageselect");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
        if ([ACFunction getSystemVersion] >= 7.0) {
            [_imagePicker.view setFrame:CGRectMake(0, 0, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [_imagePicker.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
            [self.view addSubview:_imagePicker.view];
        }
        else
        {
            //[self presentViewController:imagePicker animated:NO completion:nil];
            [_imagePicker.view setFrame:CGRectMake(0, -20, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [_imagePicker.view setFrame:CGRectMake(0, -20, 320, 568)];
            }
            [self.view addSubview:_imagePicker.view];
            
        }
    }
    else
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"相册不可用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleLightContent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
        //NSLog(@"camare");
    }
    
    //创建BABYID 路径 照片
    NSData *imagedata=UIImagePNGRepresentation(image);
    [imagedata writeToFile:BABYICONPATH(ACCOUNTUID,BABYID) atomically:NO];
    [[BabyDataDB babyinfoDB]updateBabyIcon:[NSString stringWithFormat:@"%d_%d.png",ACCOUNTUID,BABYID] BabyId:BABYID];
    
    if ([ACFunction getSystemVersion] < 7.0) {
        [_imagePicker.view removeFromSuperview];
    }
    else
    {
        [_imagePicker.view removeFromSuperview];
    }
    
    if (picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary) {
        [self refreshPic];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //[imagePicker dismissViewControllerAnimated:YES completion:nil];
    if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleLightContent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } 
    [_imagePicker.view removeFromSuperview];
}


-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    if (error == nil)
    {
        [self refreshPic];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"添加头像出错,请重新尝试" delegate:nil cancelButtonTitle:@"OK." otherButtonTitles:nil];
        [alert show];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == _textFiledHeight && ![self isPureFloat:_textFiledHeight.text]) || (textField == _textFiledWeight && ![self isPureFloat:_textFiledWeight.text]) || (textField == _textFiledHS && ![self isPureFloat:_textFiledHS.text])) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"输入异常,必须为数字哦!"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        textField.text = @"";
        return NO;
    }
    
    [textField resignFirstResponder];
    return YES;
}

#pragma 判断是否为浮点数
- (BOOL)isPureFloat:(NSString*)string{
    //允许空值
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
