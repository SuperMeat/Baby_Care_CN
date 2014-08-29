

#import "PhotoAreaView.h"
#import "TipsMainViewController.h"

@implementation PhotoAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib{
    [self initView];
}

-(void)initView{
    _imageViewHeadPic.layer.masksToBounds = YES;
    _imageViewHeadPic.layer.cornerRadius = 57.0;
    _imageViewHeadPic.userInteractionEnabled=YES;
    _imageViewHeadPic.clipsToBounds=YES;
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ActionSheetShow)];
    [_imageViewHeadPic addGestureRecognizer:tapgesture];
    
    imagePicker=[[UIImagePickerController alloc]init];
}

-(void)initData{
    NSDictionary *dict = [[BabyDataDB babyinfoDB]selectBabyInfoByBabyId:BABYID];
    if (dict) {
        //姓名
        if (![[dict objectForKey:@"nickname"] isEqual: @""]) {
            _labelBabyName.text = [dict objectForKey:@"nickname"];
        }
        
        //生日
        if ([[dict objectForKey:@"birth"] intValue] != 0){
            _labelDays.text = [self getbabyage:[[dict objectForKey:@"birth"] intValue]];
        }
        
        //设置照片
        NSFileManager *fileManage = [[NSFileManager alloc] init];
        if ([fileManage fileExistsAtPath:BABYICONPATH(ACCOUNTUID, BABYID)]) {
            _imageViewHeadPic.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:BABYICONPATH(ACCOUNTUID, BABYID)]];
        }
    }
}

#pragma 获取view所属viewController
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
            [self.superview.superview addSubview:imagePicker.view];
            
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
            [self.superview.superview addSubview:imagePicker.view];
        }
        else
        {
            //[self presentViewController:imagePicker animated:NO completion:nil];
            [imagePicker.view setFrame:CGRectMake(0, -20, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [imagePicker.view setFrame:CGRectMake(0, -20, 320, 568)];
            }
            [[self viewController].tabBarController.tabBar setHidden:YES];
            [self.superview.superview addSubview:imagePicker.view];
            
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
    
    if (picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary) {
        [self initData];
    }
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
- (NSString*)getbabyage:(int)birth
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
    comps=  [calendar components:unitFlags fromDate:date toDate:[ACDate date] options:nil];
    if ([comps year] == 0 && [comps month] == 0 && [comps day]==0) {
        return @"1天";
    }
    else if ([comps year]==0 && [comps month] == 0)
    {
        return [NSString stringWithFormat:@"%d天",[comps day]];
    }
    else if ([comps year]==0)
    {
        return [NSString stringWithFormat:@"%d月 %d天",[comps month],[comps day]];
    }
    else if ([comps year]!=0 && [comps month] == 0 && [comps day] != 0){
        return [NSString stringWithFormat:@"%d年 %d天",[comps year],[comps day]];
    }
    else if ([comps year]!=0 && [comps month] == 0 && [comps day] == 0){
        return [NSString stringWithFormat:@"%d年整",[comps year]];
    }
    else
    {
        return [NSString stringWithFormat:@"%d年 %d月 %d天",[comps year],[comps month],[comps day]];
    }
    
}

- (IBAction)goTips:(id)sender {
    TipsMainViewController *tipsMasterViewController = [[TipsMainViewController alloc] init];
    [self viewController].navigationController.navigationBar.hidden = NO;
    [[self viewController].navigationController pushViewController:tipsMasterViewController animated:YES];
}



@end
