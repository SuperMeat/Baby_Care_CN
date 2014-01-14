//
//  BabyinfoViewController.m
//  Parenting
//
//  Created by user on 13-5-31.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "BabyinfoViewController.h"

static int age = 0;

@interface BabyinfoViewController ()

@end

@implementation BabyinfoViewController
@synthesize nametextfield=_nametextfield,babyimageview=_babyimageview,birthdaytextfield=_birthdaytextfield,gendertextfield=_gendertextfield,save=_save,Femalebutton=_Femalebutton,myScrollview=_myScrollview,Malebutton=_Malebutton,heighttextfield=_heighttextfield,Headtextfield=_Headtextfield,weighttextfield=_weighttextfield,standardhctextfield=_standardhctextfield,standardheighttextfield=_standardheighttextfield,standardweighttextfield=_standardweighttextfield,SaveButton=_SaveButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 200, 20)];
        titleView.backgroundColor=[UIColor clearColor];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        titleText.textColor = [UIColor whiteColor];
        [titleText setTextAlignment:NSTextAlignmentCenter];
        [titleText setText:NSLocalizedString(@"Baby information", nil)];
        [titleView addSubview:titleText];
        
        self.navigationItem.titleView = titleView;
        //self.title  = NSLocalizedString(@"Baby information",nil ) ;
        self.hidesBottomBarWhenPushed=YES;
        //self.automaticallyAdjustsScrollViewInsets = NO;
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleLightContent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"birthday"]) {
        NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[dateFormater stringFromDate:[currentdate date]] forKey:@"birthday"];
        
    }

    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"gender"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"male" forKey:@"gender"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"name"]) {
        self.nametextfield.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    }

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"height"]) {
        self.heighttextfield.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"height"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"weight"]) {
        self.weighttextfield.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"weight"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"head"]) {
        self.Headtextfield.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"head"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"gender"]) {
        NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
        if ([str isEqualToString:@"Female"])
        {
            self.Femalebutton.enabled=NO;
            self.Malebutton.enabled=YES;
        }
        else
        {
            self.Malebutton.enabled=NO;
            self.Femalebutton.enabled=YES;
        }
    }
    
    self.birthdaytextfield.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"birthday"];
    //NSLog(@"birth : %@",self.birthdaytextfield.text);
        age=[currentdate getDurationfromdate:self.birthdaytextfield.text];
        [self loaddataForstandard:age];
    
    
    
}
-(void)loaddataForstandard:(int)age
{
    NSArray *array=[DataBase selectbabyinfo:age];
    if ([array count]>0) {
        
        if ([array objectAtIndex:0]) {
             self.standardheighttextfield.text=[array objectAtIndex:0];
        }
        
        if ([array objectAtIndex:1]) {
            self.standardweighttextfield.text=[array objectAtIndex:1];
        }
        
        if([array objectAtIndex:2]){
            self.standardhctextfield.text=[array objectAtIndex:2];
        }
    }

}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)makeNav
{
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 34, 28)];
    title.backgroundColor = [UIColor clearColor];

    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.text = NSLocalizedString(@"navback", nil);
    title.font = [UIFont systemFontOfSize:14];
    [backbutton addSubview:title];
    
    
    [backbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame=CGRectMake(0, 0, 44, 28);
    
    
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;

    
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_title.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1]];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.myScrollview setFrame:CGRectMake(0, G_YADDONVERSION, 320, 690)];
    [self.view addSubview:self.myScrollview];
    self.myScrollview.contentSize=CGSizeMake(320, 690) ;
    if ([UIScreen mainScreen].bounds.size.height==568) {
        self.myScrollview.contentSize=CGSizeMake(320, 778) ;
        [self.myScrollview setFrame:CGRectMake(0, 0, 320, 568)];
    }
    [self.myScrollview setScrollEnabled:YES];
    _myScrollview.showsHorizontalScrollIndicator=NO;
    [self makeNav];
    self.nametextfield.leftViewMode=UITextFieldViewModeAlways;
    self.birthdaytextfield.leftViewMode=UITextFieldViewModeAlways;
    self.gendertextfield.leftViewMode=UITextFieldViewModeAlways;
    self.heighttextfield.leftViewMode=UITextFieldViewModeAlways;
    self.Headtextfield.leftViewMode=UITextFieldViewModeAlways;
    self.weighttextfield.leftViewMode=UITextFieldViewModeAlways;

    UILabel *lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    lable1.text=NSLocalizedString(@"Name:",nil);
    lable1.textAlignment=NSTextAlignmentRight;
    lable1.backgroundColor=[UIColor clearColor];
    lable1.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    self.nametextfield.leftView=lable1;
    
    [self.nametextfield setValue:[NSNumber numberWithInt:2] forKey:@"paddingTop"];
    [self.nametextfield setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [self.nametextfield setValue:[NSNumber numberWithInt:0] forKey:@"paddingBottom"];
    [self.nametextfield setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    [_nametextfield setTextColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]];
    
    
    UILabel *lable2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    lable2.text=NSLocalizedString(@"Birthday:",nil);
    lable2.textAlignment=NSTextAlignmentRight;
    lable2.backgroundColor=[UIColor clearColor];
    lable2.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    self.birthdaytextfield.leftView=lable2;
    
    [self.birthdaytextfield setValue:[NSNumber numberWithInt:2] forKey:@"paddingTop"];
    [self.birthdaytextfield setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [self.birthdaytextfield setValue:[NSNumber numberWithInt:0] forKey:@"paddingBottom"];
    [self.birthdaytextfield setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    [_birthdaytextfield setTextColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]];

    self.birthdaytextfield.userInteractionEnabled=YES;
    
    
    UILabel *lable4=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    lable4.text=NSLocalizedString(@"Height:",nil);
    lable4.textAlignment=NSTextAlignmentRight;
    lable4.backgroundColor=[UIColor clearColor];
    lable4.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    self.heighttextfield.leftView=lable4;

    [self.heighttextfield setValue:[NSNumber numberWithInt:2] forKey:@"paddingTop"];
    [self.heighttextfield setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [self.heighttextfield setValue:[NSNumber numberWithInt:0] forKey:@"paddingBottom"];
    [self.heighttextfield setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    [_heighttextfield setTextColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]];
    
    
    UILabel *lable5=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    lable5.text=NSLocalizedString(@"Weight:",nil);
    lable5.textAlignment=NSTextAlignmentRight;
    lable5.backgroundColor=[UIColor clearColor];
    lable5.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    self.weighttextfield.leftView=lable5;
    
    [self.weighttextfield setValue:[NSNumber numberWithInt:2] forKey:@"paddingTop"];
    [self.weighttextfield setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [self.weighttextfield setValue:[NSNumber numberWithInt:0] forKey:@"paddingBottom"];
    [self.weighttextfield setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    [_weighttextfield setTextColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]];
    
    
    UILabel *lable6=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    lable6.text=NSLocalizedString(@"HC:",nil);
    lable6.textAlignment=NSTextAlignmentRight;
    lable6.backgroundColor=[UIColor clearColor];
    lable6.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    self.Headtextfield.leftView=lable6;
    
    [self.Headtextfield setValue:[NSNumber numberWithInt:2] forKey:@"paddingTop"];
    [self.Headtextfield setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [self.Headtextfield setValue:[NSNumber numberWithInt:0] forKey:@"paddingBottom"];
    [self.Headtextfield setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
    [_Headtextfield setTextColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]];
    
    
    UILabel *lable3=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    lable3.text=NSLocalizedString(@"Gender:",nil);
    lable3.textAlignment=NSTextAlignmentRight;
    lable3.backgroundColor=[UIColor clearColor];
    lable3.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    self.gendertextfield.leftView=lable3;
    
    [self makeDatePicker];
    
    [self.Malebutton setTitle:NSLocalizedString(@"Male",nil) forState:UIControlStateNormal];
    self.Malebutton.tag=101;
    self.Femalebutton.tag=102;
    [_Malebutton setTitleColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0] forState:UIControlStateNormal];
    [_Femalebutton setTitleColor:[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0]forState:UIControlStateNormal];
    
    [self.Femalebutton setTitle:NSLocalizedString(@"Female",nil) forState:UIControlStateNormal];
    [self.Malebutton setImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
    [self.Femalebutton setImage:[UIImage imageNamed:@"radio.png"] forState:UIControlStateNormal];
    self.Malebutton.contentMode=UIViewContentModeScaleAspectFit;
    self.Femalebutton.contentMode=UIViewContentModeScaleAspectFit;
    [self.Femalebutton setImage:[UIImage imageNamed:@"radio_focus.png"] forState:UIControlStateDisabled];
    [self.Malebutton setImage:[UIImage imageNamed:@"radio_focus.png"] forState:UIControlStateDisabled];
    
    self.babyimageview.userInteractionEnabled=YES;
    _babyimageview.clipsToBounds=YES;

    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ActionSheetShow)];
    [self.babyimageview addGestureRecognizer:tapgesture];
    
    imagePicker=[[UIImagePickerController alloc]init];

    self.babyimageview.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:PHOTOPATH]];
    
    [self.SaveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    
    self.standardhctextfield.textAlignment=NSTextAlignmentCenter;
    self.standardheighttextfield.textAlignment=NSTextAlignmentCenter;
    self.standardweighttextfield.textAlignment=NSTextAlignmentCenter;

    _standardweighttextfield.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    _standardheighttextfield.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    _standardhctextfield.textColor=[UIColor colorWithRed:0xAF/255.0 green:0xAF/255.0 blue:0xAF/255.0 alpha:0xFF/255.0];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)makeDatePicker
{
    [self.view addSubview:datepicker];
    datepicker.hidden=YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (id view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
    
    if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleLightContent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
     return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Save:(id)sender {
    if (!self.nametextfield.text.length>0||!self.birthdaytextfield.text.length>0||!self.heighttextfield.text.length>0||!self.weighttextfield.text.length>0||!self.Headtextfield.text.length>0) {
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"BabyInfoTips", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
        return;
    }

    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.nametextfield.text forKey:@"name"];
        [[NSUserDefaults standardUserDefaults] setObject:self.birthdaytextfield.text forKey:@"birthday"];
        [[NSUserDefaults standardUserDefaults] setObject:self.heighttextfield.text forKey:@"height"];
        [[NSUserDefaults standardUserDefaults]setObject:self.weighttextfield.text forKey:@"weight"];
        [[NSUserDefaults standardUserDefaults]setObject:self.Headtextfield.text forKey:@"head"];
        
        if (self.Malebutton.enabled==NO) {
            [[NSUserDefaults standardUserDefaults] setObject:@"Male" forKey:@"gender"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"Female" forKey:@"gender"];
        }
        UIAlertView *alter=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"Save_Success", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
    
    age=[currentdate getDurationfromdate:self.birthdaytextfield.text];

    [self loaddataForstandard:age];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"IsFirstSaveInfo"] == nil) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsFirstSaveInfo"];
    }

}

-(void)updatebirsthday:(UIDatePicker*)sender
{
    NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];

        self.birthdaytextfield.text=[dateFormater stringFromDate:sender.date];
    [[NSUserDefaults standardUserDefaults] setObject:[dateFormater stringFromDate:sender.date] forKey:@"birthday"];


}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.birthdaytextfield)
    {
        [self actionsheetShow];
        [self.birthdaytextfield resignFirstResponder];
    }
}

-(void)actionsheetShow
{
    action=[[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles: nil];
    
    if (datepicker==nil) {
        datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.birthdaytextfield.frame.origin.y+45+G_YADDONVERSION, 320, 100)];
        datepicker.datePickerMode=UIDatePickerModeDate;
        [datepicker addTarget:self action:@selector(updatebirsthday:) forControlEvents:UIControlEventValueChanged];
    }
    
    datepicker.frame=CGRectMake(0, 0, 320, 100);
    
    action.bounds=CGRectMake(0, 0, 320, 200);
    [action addSubview:datepicker];
    [action showFromTabBar:self.tabBarController.tabBar];
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

-(void)imageSelectFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing=YES;
        imagePicker.delegate=self;
        if ([OpenFunction getSystemVersion] >= 7.0) {
            [imagePicker.view setFrame:CGRectMake(0, 0, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [imagePicker.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.view addSubview:imagePicker.view];

        }
        else
        {
//            [self presentViewController:imagePicker animated:NO completion:nil];
            [imagePicker.view setFrame:CGRectMake(0, 0, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [imagePicker.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.view addSubview:imagePicker.view];

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
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        if ([OpenFunction getSystemVersion] >= 7.0) {
            [imagePicker.view setFrame:CGRectMake(0, 0, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [imagePicker.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.view addSubview:imagePicker.view];
        }
        else
        {
            //[self presentViewController:imagePicker animated:NO completion:nil];
            [imagePicker.view setFrame:CGRectMake(0, -20, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [imagePicker.view setFrame:CGRectMake(0, -20, 320, 568)];
            }
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.view addSubview:imagePicker.view];

        }
    }
    else
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"相册不可用" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)ActionSheetShow
{
    UIActionSheet *action1=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle",nil) destructiveButtonTitle:NSLocalizedString(@"Camera",nil) otherButtonTitles:NSLocalizedString(@"Photo",nil), nil];
    
    [action1 showFromTabBar:self.tabBarController.tabBar];
    
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
    else
    {
        if (actionSheet==action) {
            NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
            [dateFormater setDateFormat:@"yyyy-MM-dd"];
            
            self.birthdaytextfield.text=[dateFormater stringFromDate:datepicker.date];
            [[NSUserDefaults standardUserDefaults] setObject:[dateFormater stringFromDate:datepicker.date] forKey:@"birthday"];
            
        }
        else
        {
            [actionSheet dismissWithClickedButtonIndex:[actionSheet cancelButtonIndex] animated:YES];
        }
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
    NSData *imagedata=UIImagePNGRepresentation(image);
    [imagedata writeToFile:PHOTOPATH atomically:NO];
    [self.babyimageview setImage:image];
    
    if ([OpenFunction getSystemVersion] < 7.0) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        [imagePicker.view removeFromSuperview];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [imagePicker.view removeFromSuperview];

    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //[imagePicker dismissViewControllerAnimated:YES completion:nil];
    if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleLightContent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [imagePicker.view removeFromSuperview];
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    if (error == nil)
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"This picture has been saved to your photo album" delegate:nil cancelButtonTitle:@"OK." otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please try it again later.Saving Failed" delegate:nil cancelButtonTitle:@"OK." otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)keyboradshow
{
    
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    _myScrollview.contentOffset=CGPointMake(_myScrollview.contentOffset.x, _myScrollview.contentOffset.y+150);
    
    [UIView commitAnimations];
    
}

-(void)keyboradhidden
{
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    _myScrollview.contentOffset=CGPointMake(_myScrollview.contentOffset.x, _myScrollview.contentOffset.y-150);
    [UIView commitAnimations];
}

- (void)keyboardWillShown:(NSNotification*)aNotification{
    [self keyboradshow];
}

-(void)keyboardWillHidden:(NSNotification*)aNotification
{
    [self keyboradhidden];
}


- (void)viewDidUnload {
    [self setMyScrollview:nil];
    [self setHeighttextfield:nil];
    [self setWeighttextfield:nil];
    [self setHeadtextfield:nil];
    [self setStandardheighttextfield:nil];
    [self setStandardweighttextfield:nil];
    [self setStandardhctextfield:nil];
    [self setSaveButton:nil];
    [super viewDidUnload];
}

#pragma -mark function#
+ (NSString*)getbabyage
{
    NSString *age = [[NSUserDefaults standardUserDefaults] objectForKey:@"birthday"];
    //NSLog(@"getbabyage: %@",age);
    NSDateFormatter *fomatter=[[NSDateFormatter alloc]init];
    [fomatter setLocale:[NSLocale currentLocale]];
    [fomatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[fomatter dateFromString:age];
    //NSLog(@"getbabyage: %@",date);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    comps=  [calendar components:unitFlags fromDate:date toDate:[currentdate date] options:nil];
    if ([comps year] == 0 && [comps month] == 0 && [comps day]==0) {
        return [NSString stringWithFormat:@"1%@",NSLocalizedString(@"Days", nil)];
    }
    else if ([comps year]==0 && [comps month] == 0)
    {
        return [NSString stringWithFormat:@"%d%@",[comps day],NSLocalizedString(@"Days", nil)];
    }
    else if ([comps year]==0)
    {
        return [NSString stringWithFormat:@"%d%@ %d%@", [comps month],
                NSLocalizedString(@"Months", nil),
                [comps day], NSLocalizedString(@"Days", nil)];
    }
    else
    {
        return [NSString stringWithFormat:@"%d%@ %d%@ %d%@",[comps year],NSLocalizedString(@"Years", nil),[comps month],
                NSLocalizedString(@"Months", nil),
                [comps day], NSLocalizedString(@"Days", nil)];
    }
    
}

@end
