//
//  HomeTopView.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-7.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "HomeTopView.h"
#import "BabyDataDB.h"
#import "BabyinfoViewController.h"

@implementation HomeTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
        [self initData];
    }
    return self;
}

#pragma 创建视图
-(void)initView{
    //整体背景
    [self setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    image_bg_top = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top.png"]];
    image_bg_top.frame = CGRectMake(0, 0, 320, 215);
    [self addSubview:image_bg_top];
    
    //头像
    image_headPic = [[UIImageView alloc]init];
    image_headPic.frame = CGRectMake(102.5, 55.5, 115, 115);
    image_headPic.layer.masksToBounds = YES;
    image_headPic.layer.cornerRadius = 57.5;
    image_headPic.userInteractionEnabled=YES;
    image_headPic.clipsToBounds=YES;
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ActionSheetShow)];
    [image_headPic addGestureRecognizer:tapgesture];
    
    imagePicker=[[UIImagePickerController alloc]init];

    [self addSubview:image_headPic];
    
    //天数背景
    image_days = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_days.png"]];
    image_days.frame = CGRectMake(90, 50, 38, 38);
    [self addSubview:image_days];
    
    //天数
    label_days = [[UILabel alloc]init];
    label_days.frame = CGRectMake(90, 59, 38, 24);
    label_days.font = [UIFont fontWithName:@"Arial-BoldMT" size:10];
    label_days.textColor = [UIColor whiteColor];
    label_days.textAlignment = CPTTextAlignmentCenter;
    //自动折行设置
    label_days.lineBreakMode = NSLineBreakByWordWrapping;
    label_days.numberOfLines = 0;
    [self addSubview:label_days];
    
    //姓名
    label_babyName = [[UILabel alloc]init];
    label_babyName.frame = CGRectMake(60, 174, 200, 24);
    label_babyName.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    label_babyName.textColor = [UIColor whiteColor];
    label_babyName.textAlignment = CPTTextAlignmentCenter;
    [self addSubview:label_babyName];
}

#pragma 加载数据
-(void)initData{
    NSDictionary *dict = [[BabyDataDB babyinfoDB]selectBabyInfoByBabyId:BABYID];
    if (dict) {
        //姓名
        if ([[dict objectForKey:@"nickname"] isEqual: @""]) {
            label_babyName.text = @"宝宝";
        }
        else{
            label_babyName.text = [dict objectForKey:@"nickname"];
        }
        
        //生日
        if ([[dict objectForKey:@"birth"] intValue] == 0) {
            label_days.text = @"?天";
        }
        else{
            label_days.text = [HomeTopView getbabyage:[[dict objectForKey:@"birth"] intValue]];
        }
    
        //设置照片
        NSFileManager *fileManage = [[NSFileManager alloc] init];
        if ([fileManage fileExistsAtPath:BABYICONPATH(ACCOUNTUID, BABYID)]) {
            image_headPic.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:BABYICONPATH(ACCOUNTUID, BABYID)]];
        }
        else{
            image_headPic.image = [UIImage imageNamed:@"114.png"];
        }
        //TODO:更改照片
        
        

    }
}

#pragma 照片相关
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

-(void)ActionSheetShow
{
    UIActionSheet *action1=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle",nil) destructiveButtonTitle:NSLocalizedString(@"Camera",nil) otherButtonTitles:NSLocalizedString(@"Photo",nil), nil];
    [action1 showInView:self];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing=YES;
        imagePicker.delegate=self;
        
        if ([ACFunction getSystemVersion] >= 7.0) {
            [imagePicker.view setFrame:CGRectMake(0, 0, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [imagePicker.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
            
            [[self viewController].tabBarController.tabBar setHidden:YES];
            [self.superview.superview addSubview:imagePicker.view];
        }
        else
        {
            [imagePicker.view setFrame:CGRectMake(0, 0, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [imagePicker.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
            
            [[self viewController].tabBarController.tabBar setHidden:YES];
            [self addSubview:imagePicker.view];
            
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
        if ([ACFunction getSystemVersion] >= 7.0) {
            [imagePicker.view setFrame:CGRectMake(0, 0, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [imagePicker.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
            [[self viewController].tabBarController.tabBar setHidden:YES];
            [self addSubview:imagePicker.view];
        }
        else
        {
            //[self presentViewController:imagePicker animated:NO completion:nil];
            [imagePicker.view setFrame:CGRectMake(0, -20, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [imagePicker.view setFrame:CGRectMake(0, -20, 320, 568)];
            }
            [[self viewController].tabBarController.tabBar setHidden:YES];
            [self addSubview:imagePicker.view];
            
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
        [imagePicker.view removeFromSuperview];
    }
    else
    {
        [imagePicker.view removeFromSuperview];
    }
    [[self viewController].tabBarController.tabBar setHidden:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //[imagePicker dismissViewControllerAnimated:YES completion:nil];
    if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleLightContent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [[self viewController].tabBarController.tabBar setHidden:NO];
    [imagePicker.view removeFromSuperview];
}


-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    if (error == nil)
    {
        [self initData];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"添加头像出错,请重新尝试" delegate:nil cancelButtonTitle:@"OK." otherButtonTitles:nil];
        [alert show];
    }
}

#pragma -mark function#(NSString*)getbabyage:(int)birth
+ (NSString*)getbabyage:(int)birth
{
    //时间戳转date
    NSDate *birthDate = [ACDate getDateFromTimeStamp:birth];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *age = [dateFormatter stringFromDate:birthDate];
    
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
        return @"1天";
    }
    else if ([comps year]==0 && [comps month] == 0)
    {
        return [NSString stringWithFormat:@"0年 0月 %d天",[comps day]];
    }
    else if ([comps year]==0)
    {
        return [NSString stringWithFormat:@"0年 %d月 %d天",[comps month],[comps day]];
    }
    else
    {
        return [NSString stringWithFormat:@"%d年 %d月 %d天",[comps year],[comps month],[comps day]];
    }
    
}

@end
