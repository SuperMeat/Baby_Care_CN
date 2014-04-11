//
//  MyPageViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-19.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "MyPageViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"

#import "HomeTopView.h"
#import "TimeLineView.h"
#import "BabyDataDB.h"
#import "UserDataDB.h"
#import "NetWorkConnect.h"
#import "DataContract.h"

@interface MyPageViewController ()

@end

@implementation MyPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"首页"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated    {
    [MobClick beginLogPageView:@"首页"];
    self.navigationController.navigationBarHidden = YES;
    
    //创建子视图
    [self initView];
    //加载数据
    [self LoadData];
    //未创建宝宝
    [self createBaby];
}

#pragma textfield protocol
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //10901:宝贝姓名
    if (textField.tag == 10901) {
        //注册接口
        hud = [MBProgressHUD showHUDAddedTo:guideView animated:YES];
        //隐藏键盘
        [textField resignFirstResponder];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.alpha = 0.5;
        hud.color = [UIColor grayColor];
        hud.labelText = http_requesting;
        //封装数据
        NSMutableDictionary *dictBody = [[DataContract dataContract]BabyCreateByUserIdDict:ACCOUNTUID];
        //Http请求
        [[NetWorkConnect sharedRequest]
         httpRequestWithURL:BABY_CREATEBYUSERID_URL
         data:dictBody
         mode:@"POST"
         HUD:hud
         didFinishBlock:^(NSDictionary *result){
             hud.labelText = [result objectForKey:@"msg"];
             //处理反馈信息: code=1为成功  code=99为失败
             if ([[result objectForKey:@"code"]intValue] == 1) {
                 NSMutableDictionary *resultBody = [result objectForKey:@"body"];
                 //保存Babyid
                 [[NSUserDefaults standardUserDefaults]setObject:[resultBody objectForKey:@"babyId"] forKey:@"BABYID"];
                 //数据库保存Baby信息
                 [BabyDataDB createNewBabyInfo:ACCOUNTUID BabyId:BABYID Nickname:@"" Birthday:nil Sex:nil HeadPhoto:@"" RelationShip:@"" RelationShipNickName:@"" Permission:nil CreateTime:[resultBody objectForKey:@"create_time"] UpdateTime:nil];
                 
                 [hud hide:YES afterDelay:0.5];
                 [self performSelector:@selector(guideToNext) withObject:nil afterDelay:0.8];
             }
             else{
                 [hud hide:YES afterDelay:1.2];
             }
         }
         didFailBlock:^(NSString *error){
             //请求失败处理
             hud.labelText = http_error;
             [hud hide:YES afterDelay:1];
         }
         isShowProgress:YES
         isAsynchronic:YES
         netWorkStatus:YES
         viewController:self];
    }
    return YES;
}

-(void)guideToNext{
    [guideView removeFromSuperview];
    [self createBaby];
}

#pragma 创建宝宝引导遮盖视图
-(void)createBaby{
    guideView = [[UIView alloc]initWithFrame:
                         CGRectMake(0,
                                    0,
                                    320,
                                    568)];
    guideView.alpha = 0.9;
    guideView.backgroundColor = [UIColor blackColor];
    
//    UIButton *buttonGuide = [[UIButton alloc]init];
    UILabel * labelTip = [[UILabel alloc]init];
    labelTip.textColor = [UIColor whiteColor];
    labelTip.textAlignment = CPTTextAlignmentCenter;
    
    UITextField *textFiledItem = [[UITextField alloc]init];
    textFiledItem.textColor = [UIColor blackColor];
    textFiledItem.textAlignment = CPTTextAlignmentCenter;
    
    UIImageView *imageArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tips_arrow.png"]];
    
    if (!BABYID) {
        //处理宝贝名
        imageArrow.frame = CGRectMake(48, 120, 60, 45);
        
        textFiledItem.tag = 10901;
        textFiledItem.delegate = self   ;
        textFiledItem.placeholder = @"编辑宝宝姓名";
        textFiledItem.backgroundColor = [UIColor whiteColor];
        textFiledItem.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        textFiledItem.frame = CGRectMake(100, 165, 120, 20);
        textFiledItem.layer.cornerRadius = 3.0;
        
        [guideView addSubview:imageArrow];
        [guideView addSubview:textFiledItem];
        [self.navigationController.parentViewController.view addSubview:guideView];
    }
    else{
        NSDictionary *babyDict = [[BabyDataDB babyinfoDB]selectBabyInfoByBabyId:BABYID];
        if ([[babyDict objectForKey:@"icon"] isEqual: @""]) {
            //处理头像
            //提示加载头像
            UIImageView *imageHeadBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"114.png"]];
            imageHeadBG.frame = CGRectMake(102.5, 46.5, 114, 114);
            imageHeadBG.layer.masksToBounds = YES;
            imageHeadBG.layer.cornerRadius = 57;
            imageHeadBG.alpha = 1;
            imageHeadBG.userInteractionEnabled=YES;
            imageHeadBG.clipsToBounds=YES;
            
            UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ActionSheetShow)];
            [imageHeadBG addGestureRecognizer:tapgesture];
            
            imagePicker=[[UIImagePickerController alloc]init];
            //        imagePicker.cameraOverlayView.frame = CGRectMake(0, 0, 110, 110);
            
            labelTip.text = @"请选择宝宝照片";
            CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI*-0.16);
            [labelTip setTransform:rotation];
            labelTip.frame = CGRectMake(35,40,140,20);
            
            [guideView addSubview:imageHeadBG];
            [guideView addSubview:labelTip];
            [self.navigationController.parentViewController.view addSubview:guideView];
        }
        if ([[[babyDict objectForKey:@"birth"] stringValue]  isEqual: @""]) {
            //处理生日
        }
    }
    
}

-(void)ActionSheetShow
{
    UIActionSheet *action1=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle",nil) destructiveButtonTitle:NSLocalizedString(@"Camera",nil) otherButtonTitles:NSLocalizedString(@"Photo",nil), nil];
    
    
    [action1 showInView:guideView];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==[actionSheet destructiveButtonIndex]) {
        [self imageSelectFromCamera];
        //设置透明
        guideView.alpha = 1;
    }
    else if (buttonIndex==1)
    {
        [self imageSelect];
        //设置透明
        guideView.alpha = 1;
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
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [guideView addSubview:imagePicker.view];
            
        }
        else
        {
            //            [self presentViewController:imagePicker animated:NO completion:nil];
            [imagePicker.view setFrame:CGRectMake(0, 0, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [imagePicker.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [guideView addSubview:imagePicker.view];
            
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
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [guideView addSubview:imagePicker.view];
        }
        else
        {
            //[self presentViewController:imagePicker animated:NO completion:nil];
            [imagePicker.view setFrame:CGRectMake(0, -20, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [imagePicker.view setFrame:CGRectMake(0, -20, 320, 568)];
            }
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [guideView addSubview:imagePicker.view];
            
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
    

    //TODO:创建BABYID 路径 照片
    NSData *imagedata=UIImagePNGRepresentation(image);
    [imagedata writeToFile:PHOTOPATH atomically:NO];
    
    
    
    if ([ACFunction getSystemVersion] < 7.0) {
        [imagePicker.view removeFromSuperview];
    }
    else
    {
        [imagePicker.view removeFromSuperview];
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //[imagePicker dismissViewControllerAnimated:YES completion:nil];
    if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleLightContent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [imagePicker.view removeFromSuperview];
    guideView.alpha = 0.8;
}


-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    if (error == nil)
    {
        //TODO:结束重读引导
        [guideView removeFromSuperview];
        [self createBaby];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"添加头像出错,请重新尝试" delegate:nil cancelButtonTitle:@"OK." otherButtonTitles:nil];
        [alert show];
    }
}
#pragma END创建宝宝引导

#pragma 加载视图
-(void)initView{
    //加载头像区视图
    HomeTopView *homeTopView = [[HomeTopView alloc]initWithFrame:CGRectMake(0, -10, self.view.bounds.size.width, 200)];
    [self.view addSubview:homeTopView];
    
    //加载时间轴区视图
    TimeLineView *timeLineView =
    [[TimeLineView alloc]initWithFrame:
     CGRectMake(0,
                homeTopView.frame.size.height + homeTopView.frame.origin.y,
                self.view.bounds.size.width,
                self.view.bounds.size.height - (homeTopView.frame.size.height + homeTopView.frame.origin.y))];
    [self.view addSubview:timeLineView];
}

#pragma 加载数据
-(void)LoadData{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
