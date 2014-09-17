

#import "PhotoAreaView.h"
#import "TipsMainViewController.h"

@implementation PhotoAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)awakeFromNib{
    [self initView];
}

-(void)initView{
    self.backgroundColor = [UIColor colorWithRed:104.0f/255.0f green:191.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    
    _imageViewBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, -15, self.bounds.size.width, 215)];
    _imageViewBG.image = [UIImage imageNamed:@"top.png"];
    [self addSubview:_imageViewBG];
    
    _imageViewHeadPic = [[UIImageView alloc] initWithFrame:CGRectMake(160-57, 41, 114, 114)];
    _imageViewHeadPic.image = [UIImage imageNamed:@"114.png"];
    _imageViewHeadPic.layer.masksToBounds = YES;
    _imageViewHeadPic.layer.cornerRadius = 57.0;
    _imageViewHeadPic.userInteractionEnabled=YES;
    _imageViewHeadPic.clipsToBounds=YES;
    [self addSubview:_imageViewHeadPic];
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ActionSheetShow)];
    [_imageViewHeadPic addGestureRecognizer:tapgesture];
    
    imagePicker=[[UIImagePickerController alloc]init];
    
    _imageViewDayBG = [[UIImageView alloc]initWithFrame:CGRectMake(88, 32, 40, 40)];
    _imageViewDayBG.image = [UIImage imageNamed:@"bg_days.png"];
    [self addSubview:_imageViewDayBG];
    
    _labelDays = [[UILabel alloc] initWithFrame:CGRectMake(89, 40, 38, 24)];
    _labelDays.font = [UIFont fontWithName:@"Arial-BoldMT" size:10];
    _labelDays.textColor = [UIColor whiteColor];
    _labelDays.textAlignment = NSTextAlignmentCenter;
    _labelDays.lineBreakMode = NSLineBreakByWordWrapping;
    _labelDays.text = @"年龄";
    [self addSubview:_labelDays];
    
    _labelBabyName = [[UILabel alloc] initWithFrame:CGRectMake(60, 159, 200, 24)];
    _labelBabyName.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    _labelBabyName.textColor = [UIColor whiteColor];
    _labelBabyName.textAlignment = NSTextAlignmentCenter;
    _labelBabyName.text = @"宝宝昵称";
    [self addSubview:_labelBabyName];
    
    _btnTips = [[UIButton alloc] initWithFrame:CGRectMake(270, 10, 51, 51)];
    [_btnTips setBackgroundImage:[UIImage imageNamed:@"btn_sum2.png"] forState:UIControlStateNormal];
    [_btnTips addTarget:self action:@selector(goTips:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnTips];
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
//    [self viewController].navigationController.navigationBarHidden = NO;
    TipsMainViewController *tipsMasterViewController = [[TipsMainViewController alloc] init];
    [[self viewController].navigationController pushViewController:tipsMasterViewController animated:YES];
}



@end
