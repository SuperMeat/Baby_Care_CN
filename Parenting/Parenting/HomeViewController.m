//
//  HomeViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-9-29.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "HomeViewController.h"
#import "BabyMsgTableViewCell.h"

#import "NoteController.h"
#import "VaccineController.h"
#import "TestController.h"
#import "TestReportController.h"
#import "TestModel.h"
#import "PHYDetailViewController.h"
#import "PhysiologyViewController.h"
#import "TipsMainViewController.h"


<<<<<<< HEAD
//**  获取时间轴数据默认条数  **
#define kHomeTimeLineInitCount 5
//**  获取时间轴数据增长条数  **
#define kHomeTimeLinePerIncCount 5
=======
#import <TencentOpenAPI/QQApi.h>
#import <UMSocial_Sdk_Extra_Frameworks/Wechat/WXApi.h>
>>>>>>> 1eddceeaed5df67ca7bd275bcaba33510ca2047f

#define kHomeBottomActivityViewWeight 20
#define kHomeBottomActivityViewHeight kHomeBottomActivityViewWeight
#define kHomeBottomActivitySpaceHeight 44

#define kHomeTopNavigationBarHeight 64

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:UIColorFromRGB(kColor_baseView)];
    _imagePicker=[[UIImagePickerController alloc]init];
    
    //**  加载子view  **
    [self initSubView];
    
    //**  未创建宝宝前不加载数据  **
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kBabyNickname"] != nil){
        [self getTimeLineData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //未登陆跳转
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ACCOUNT_NAME"] == nil){
        //清空原始baby信息
        _bcBaby = nil;
        //清空原始时间轴数据
        [_timeLineDS removeAllObjects];
        [_timeLineCells removeAllObjects];
        _timeLineTableView = nil;
        [_timeLineTableView removeFromSuperview];
        
        [_homeScrollView setContentOffset:CGPointMake(0, 0)];
        
        //加载login视图
        if (_loginView == nil){
            _loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
            _loginView.mainViewController = self;
            _loginView.hud = _hud;
            [self.tabBarController.view.superview addSubview:_loginView];
        }
        [_loginView setHidden:NO];
        
        //加载hub
        if (_isLogining) {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            _hud.mode = MBProgressHUDModeIndeterminate;
            _hud.alpha = 1;
            _hud.color = [UIColor grayColor];
            _hud.labelText = @"数据验证中...";
        }
    }
    //未初始化宝宝基本信息时跳转
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kBabyNickname"] == nil) {
        //卸载login视图
        if (_loginView != nil) {
            _loginView = nil;
            [_loginView removeFromSuperview];
        }
        
        InitBabyInfoViewController *ctr = [[InitBabyInfoViewController alloc]init];
        [self.navigationController pushViewController:ctr animated:NO];
        return;
    }
    else{
<<<<<<< HEAD
        //卸载login视图
        if (_loginView != nil) {
            _loginView = nil;
            [_loginView removeFromSuperview];
        }
        //隐藏hud
        [_hud hide:YES];
        
        if (_timeLineTableView == nil) {
            _timeLineTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _homeHeadView.height, kDeviceWidth, kDeviceHeight - _homeHeadView.bounds.origin.y)];
            _timeLineTableView.dataSource = self;
            _timeLineTableView.delegate = self;
            _timeLineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _timeLineTableView.scrollEnabled= NO;
            [_timeLineTableView setBackgroundColor:UIColorFromRGB(kColor_baseView)];
            [_homeScrollView addSubview:_timeLineTableView];
        }
        
        
        if (_bcBaby == nil) {
            //**  加载时间轴数据  **
            [self getTimeLineData];
            //**  加载头部view数据  **
            [self initBabyInfoData];
        }
=======
        //[self ReviewTheApp];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    if (isPushSocialView) {
        isPushSocialView = NO;
>>>>>>> 1eddceeaed5df67ca7bd275bcaba33510ca2047f
    }

<<<<<<< HEAD
    //初始化
    
}
=======
-(void)initHomeData{
    [_initTimeLineData getTimeLineData];
    [self initData];
}

-(void)initView{
    //LoginView
    _loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _loginView.backgroundColor = [UIColor blackColor];
    _loginView.alpha = 0.9;
    
    UIButton *buttonLogin = [[UIButton alloc]initWithFrame:CGRectMake(45, [UIScreen mainScreen].bounds.size.height - 50 -40 -50-50-50, 230, 38)];
    [buttonLogin setImage:[UIImage imageNamed:@"btn_login.png"] forState:UIControlStateNormal];
    [buttonLogin addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:buttonLogin];
    
    UIButton *buttonTentWeibo = [[UIButton alloc]initWithFrame:CGRectMake(45, [UIScreen mainScreen].bounds.size.height - 50 -40 -50-50, 230, 38)];
    [buttonTentWeibo setImage:[UIImage imageNamed:@"btn_tentweibo"] forState:UIControlStateNormal];
    [buttonTentWeibo addTarget:self action:@selector(doTentWeiboLogin) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:buttonTentWeibo];
    
    UIButton *buttonQQ = [[UIButton alloc]initWithFrame:CGRectMake(45, [UIScreen mainScreen].bounds.size.height - 40 -50, 230, 38)];
    [buttonQQ setImage:[UIImage imageNamed:@"btn_tent"] forState:UIControlStateNormal];
    [buttonQQ addTarget:self action:@selector(doTenLogin) forControlEvents:UIControlEventTouchUpInside];
    if ([QQApi isQQInstalled])
    {
        [_loginView addSubview:buttonQQ];
    }
    
    UIButton *buttonSina = [[UIButton alloc]initWithFrame:CGRectMake(45, [UIScreen mainScreen].bounds.size.height - 50 - 40-50, 230, 38)];
    [buttonSina setImage:[UIImage imageNamed:@"btn_sina.png"] forState:UIControlStateNormal];
    [buttonSina addTarget:self action:@selector(doSinaLogin) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:buttonSina];
    
    UIButton *buttonRegister = [[UIButton alloc]initWithFrame:CGRectMake(200,[UIScreen mainScreen].bounds.size.height - 50, 120, 38)];
    [buttonRegister setTitle:@"注册账号" forState:UIControlStateNormal];
    [buttonRegister.titleLabel setFont:[UIFont systemFontOfSize:MIDTEXT]];
    [buttonRegister setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonRegister addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBarController.view.superview addSubview:_loginView];
    _loginView.hidden = YES;
    //LoginView end
>>>>>>> 1eddceeaed5df67ca7bd275bcaba33510ca2047f

#pragma mark 初始化子view
-(void)initSubView{
    //**  头部导航栏  **
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:@"宝贝计划"];
    [titleView addSubview:titleText];
    
    self.navigationItem.titleView = titleView;
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"btn_sum2"] forState:UIControlStateNormal];
    rightButton.frame=CGRectMake(0, 0, 51, 51);
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -40);
    [rightButton addTarget:self action:@selector(goTips) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    //**  滚动  **
    _homeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _homeScrollView.delegate = self;
    _homeScrollView.scrollEnabled = NO;
    [_homeScrollView setContentSize:CGSizeMake(_homeScrollView.width, _homeScrollView.height)];
    [self.view addSubview:_homeScrollView];
    
    //**  头部view  **
    _homeHeadView = [[HomeHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kHomeheadViewHeight + kBabyPhotoImageWS / 2)];
    _homeHeadView.delegate = self;
    [_homeScrollView addSubview:_homeHeadView];
    
    //**  时间轴  **
    _timeLineTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _homeHeadView.height, kDeviceWidth, kDeviceHeight - _homeHeadView.bounds.origin.y)];
    _timeLineTableView.dataSource = self;
    _timeLineTableView.delegate = self;
    _timeLineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _timeLineTableView.scrollEnabled= NO;
    [_timeLineTableView setBackgroundColor:UIColorFromRGB(kColor_baseView)];
    [_homeScrollView addSubview:_timeLineTableView];
    
    //**  活动指示控件  **
    _actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_homeScrollView addSubview:_actView];
}

#pragma mark 初始化头部数据
-(void)initBabyInfoData{
    NSDictionary *dic = [[BabyDataDB babyinfoDB]selectBabyInfoByBabyId:BABYID];
    _bcBaby = [BCBaby
               initWithBabyId:[dic[@"baby_id"] intValue]
               andCreateTime:[dic[@"create_time"] longValue]
               andBabyName:dic[@"nickname"]
               andBabySex:([dic[@"sex"] intValue] == 1 ? @"男" : @"女")
               andBirthTime:[dic[@"birth"] longValue]
               andBirthOfDays:[ACDate getDiffDayFormNowToDate:[ACDate getDateFromTimeStamp:[dic[@"birth"] longValue]]]
               andBirthOfDaysStr:[ACDate getBabyBirthOfDaysStr:[dic[@"birth"] longValue]]
               andGrowthStage:[self getGrowthState:[dic[@"birth"] longValue]]
               andBabyPhotoPath:BABYICONPATH(ACCOUNTUID, BABYID)];
    [_homeHeadView refreshWithBabyInfo:_bcBaby];
} 
#pragma mark 获取宝贝当前阶段
-(NSString*)getGrowthState:(long)birth{
    NSString *statusStr;
    int birthDays = [ACDate getDiffDayFormNowToDate:[ACDate getDateFromTimeStamp:birth]];
    if (birthDays <= 28) {
        statusStr = @"新生儿期";
    }
    else if (birthDays > 28 && birthDays <= 60*6){
        statusStr = @"婴儿期";
    }
    else if (birthDays > 60*6 && birthDays <= 365*2){
        statusStr = @"幼儿期";
    }
    else{
        statusStr = @"学龄前期";
    }
    return [NSString stringWithFormat:@"现在处于%@",statusStr];
}

#pragma mark 跳转到贴士页面
-(void)goTips{
    TipsMainViewController *tipsMasterViewController = [[TipsMainViewController alloc] init];
    [self.navigationController pushViewController:tipsMasterViewController animated:YES];
}

#pragma mark 刷新头像
-(void)refreshBabyPic{
    [_homeHeadView refreshBabyPic];
}

#pragma mark 初始化时间轴数据源
-(void)getTimeLineData{
    //**  初始化变量  **
    _timeLineCells = [[NSMutableArray alloc]initWithCapacity:5];
    
    [[InitTimeLineData initTimeLine] setTargetViewController:self];
    [[InitTimeLineData initTimeLine] setDelegate:self];
    [[InitTimeLineData initTimeLine] getTimeLineData];
}

//FIXME:临时处理timelineDS
-(NSMutableArray*)proTimeLineDS:(NSMutableArray*)ds{
    for (int i = 0; i<[ds count]; i++) {
        NSMutableDictionary *dic = ds[i];
        //addtion:icon time
        switch ([dic[@"msg_type"] intValue]) {
            case 0:
                [dic setValue:@"icon_news.png" forKey:@"icon"];
                break;
            case 1:
                [dic setValue:@"icon_alarm.png" forKey:@"icon"];
                break;
            case 10:
                [dic setValue:@"icon_alerm_vaccine.png" forKey:@"icon"];
                break;
            case 11:
                [dic setValue:@"icon_alerm_milstone.png" forKey:@"icon"];
                break;
            case 12:
                [dic setValue:@"icon_alerm_dialy.png" forKey:@"icon"];
                break;
            case 20:
                [dic setValue:@"icon_height.png" forKey:@"icon"];
                break;
            case 21:
                [dic setValue:@"icon_weight.png" forKey:@"icon"];
                break;
            default:
                [dic setValue:@"icon_news.png" forKey:@"icon"];
                break;
        }
        if ([dic[@"create_time"] longValue] != 0) {
            NSString *cellTime = [ACDate getMsgTimeSinceDate:[ACDate getDateFromTimeStamp:[dic[@"create_time"] longValue]]];
            [dic setValue:cellTime forKey:@"time"];
        }
        else{
            [dic setValue:@"未知" forKey:@"time"];
        }
    }
    return ds;
}

#pragma mark InitTimeLineData RefreshTimeLineDelegate
#pragma mark 刷新时间轴
-(void)willRefreshTimeLine{
    //**  Step-1:获取时间轴数据源  **
    int oldDSCount = [_timeLineDS count];

    //中间变量,用以获取更新条数
    NSMutableArray *compDS = [[NSMutableArray alloc]initWithCapacity:5];
    if (oldDSCount == 0) {
        compDS = [[BabyMessageDataDB babyMessageDB]selectByLast:0 Count:kHomeTimeLineInitCount];
    }
    else{
        compDS = [[BabyMessageDataDB babyMessageDB]selectByLast:0 Count:oldDSCount + kHomeTimeLinePerIncCount];
    }
    
    //单次实际增长数量
    int incTimeLineCount = [compDS count] - oldDSCount;
    if (incTimeLineCount == 0) {
        //scroll to bottom except activity controller
        [_homeScrollView setContentOffset:CGPointMake(0, _homeScrollView.contentSize.height - _homeScrollView.height) animated:YES];
        
        [_actView stopAnimating];
        _homeScrollView.scrollEnabled = YES;
        return;
    }
    else{
        _timeLineDS = [self proTimeLineDS:compDS];
    }
    
    NSMutableArray *incArr = [[NSMutableArray alloc]initWithCapacity:kHomeTimeLineInitCount];
    if (oldDSCount == 0) {
        //初始化时tableview insert 0 至 kHomeTimeLineInitCount 条
        for (int i=0; i<kHomeTimeLineInitCount; i++) {
            [incArr addObject:[_timeLineDS objectAtIndex:i]];
        }
    }
    else{
        //获取新增条数
        for (int i=[_timeLineDS count] - incTimeLineCount; i<[_timeLineDS count]; i++) {
            [incArr addObject:[_timeLineDS objectAtIndex:i]];
        }
    }
    for (int i = 0; i<[_timeLineDS count]; i++) {
        //替换成BabyMsg实体
        [_timeLineDS replaceObjectAtIndex:i withObject:[BCBabyMsg babyMsgWithDictionary:_timeLineDS[i]]];
    }
    
    [self insertIntoTimeLine:incArr];
    [self resetTimeLineFrame];
    
    [_actView stopAnimating];
    _homeScrollView.scrollEnabled = YES;
}

#pragma mark 时间轴插入记录
-(void)insertIntoTimeLine:(NSMutableArray*)incArr{
    //**  Step-2:Insert into TableView **
    NSMutableArray *insertion = [[NSMutableArray alloc] init];
    int cellCount = [_timeLineCells count];
    for (int i=0; i<[incArr count]; i++) {
        BabyMsgTableViewCell *cell = [[BabyMsgTableViewCell alloc]init];
        [_timeLineCells addObject:cell];
        [insertion addObject:[NSIndexPath indexPathForRow:(cellCount + i) inSection:0]];
    }
    [_timeLineTableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark 重画时间轴
-(void)resetTimeLineFrame{
    //**  Step-3:Change tableview & scrollview's state
    CGFloat timeLineTableViewHeight = 0;
    for (int i=0; i<[_timeLineCells count]; i++) {
        BabyMsgTableViewCell *cell = _timeLineCells[i];
        timeLineTableViewHeight += cell.height;
    }
    _timeLineTableView.height = timeLineTableViewHeight;
    _homeScrollView.contentSize = CGSizeMake(kDeviceWidth,_homeHeadView.height + _timeLineTableView.height + kHomeBottomActivitySpaceHeight);
}

#pragma mark 根据条件删除时间轴中已显示的某些数据
-(void)willDeleteMsgsWithTypeID:(int)typeID Key:(NSString*)key{
    if ([_timeLineDS count] != 0) {
        NSMutableArray *deletion = [[NSMutableArray alloc] initWithCapacity:5];
        
        //删除提醒
        for (int i = [_timeLineDS count] - 1; i >= 0; i--) {
            BCBabyMsg *msg = _timeLineDS[i];
            if (msg.msgType == typeID && [msg.key isEqualToString:key]) {
                [deletion addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                //删除数据源
                [_timeLineCells removeObjectAtIndex:i];
                [_timeLineDS removeObjectAtIndex:i];
            }
        }
        [_timeLineTableView deleteRowsAtIndexPaths:deletion withRowAnimation:NO];
        
        [self resetTimeLineFrame];
    }
}

#pragma mark 根据条件在时间轴中插入数据
-(void)willInsertMsg{
    if ([_timeLineDS count] != 0) {
        NSMutableArray *insertion = [[NSMutableArray alloc] initWithCapacity:1];
        NSMutableArray *ds = [[BabyMessageDataDB babyMessageDB]selectLastest];
        if ([ds count] != 0) {
            BabyMsgTableViewCell *cell = [[BabyMsgTableViewCell alloc]init];
            [_timeLineCells insertObject:cell atIndex:0];
            
            BCBabyMsg *msg = [BCBabyMsg babyMsgWithDictionary:[[self proTimeLineDS:ds] objectAtIndex:0]];
            [_timeLineDS insertObject:msg atIndex:0];
            
            [insertion addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
            [_timeLineTableView insertRowsAtIndexPaths:insertion withRowAnimation:NO];
            [self resetTimeLineFrame];
        }
    }
}

#pragma mark SelectBabyPhotoDelegate 选择照片
-(void)willSelectBabyPhoto{
    _action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle",nil) destructiveButtonTitle:NSLocalizedString(@"Camera",nil) otherButtonTitles:NSLocalizedString(@"Photo",nil), nil];
    [_action showInView:self.view];
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
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        _imagePicker.allowsEditing=YES;
        _imagePicker.delegate=self;
        
        if ([ACFunction getSystemVersion] >= 7.0) {
            [_imagePicker.view setFrame:CGRectMake(0, 0, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [_imagePicker.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
            
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController.navigationBar setHidden:YES];
            [self.view.superview addSubview:_imagePicker.view];
        }
        else
        {
            [_imagePicker.view setFrame:CGRectMake(0, 0, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [_imagePicker.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
            
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController.navigationBar setHidden:YES];
            [self.view.superview addSubview:_imagePicker.view];
            
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
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController.navigationBar setHidden:YES];
            [self.view.superview  addSubview:_imagePicker.view];
        }
        else
        {
            //[self presentViewController:imagePicker animated:NO completion:nil];
            [_imagePicker.view setFrame:CGRectMake(0, -20, 320, 480)];
            if ([UIScreen mainScreen].bounds.size.height == 568) {
                [_imagePicker.view setFrame:CGRectMake(0, -20, 320, 568)];
            }
            [self.tabBarController.tabBar setHidden:YES];
            [self.navigationController.navigationBar setHidden:YES];
            [self.view.superview  addSubview:_imagePicker.view];
            
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
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    
    if (picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary) {
        [self refreshBabyPic];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //[imagePicker dismissViewControllerAnimated:YES completion:nil];
    if ([UIApplication sharedApplication].statusBarStyle != UIStatusBarStyleLightContent) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [_imagePicker.view removeFromSuperview];
}


-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    if (error == nil)
    {
        [self refreshBabyPic];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"添加头像出错,请重新尝试" delegate:nil cancelButtonTitle:@"OK." otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark 选择照片相关

#pragma mark TableViewDelegate
#pragma mark 选中行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*  1:用户自定义提醒
     *  10:疫苗提醒
     *  11:评测提醒
     *  12:日志提醒
     *  20:生理-身高记录提醒
     *  21:生理-体重记录提醒
     *  22:生理-头围记录提醒
     */
    BCBabyMsg *curData = [_timeLineDS objectAtIndex:indexPath.row];
    if (curData.msgType == 10) {
        VaccineController* vaccineVc = [[VaccineController alloc] init];
        [self.navigationController pushViewController:vaccineVc animated:YES];
    }
    else if (curData.msgType  == 11) {
        NSDate* birthDate = [BaseMethod dateFormString:kBirthday];
        NSDate* selectedDate = [BaseMethod beijingDate:[ACDate getDateFromTimeStamp:curData.createTime]];
        
        int days = [BaseMethod fromStartDate:birthDate withEndDate:selectedDate];
        int month = days/30; // 第几个月
        
        NSArray* tests = [BaseSQL queryData_test];
        
        if (month < [BaseMethod month_test] && month >= 0 &&[BaseMethod month_test]>0) {
            
            TestModel* model = tests[month];
            if ([model.completed boolValue]) {
                TestReportController* reportVc = [[TestReportController alloc] init];
                reportVc.month = month;
                [self.navigationController pushViewController:reportVc animated:YES];
            }else
            {
                TestController* testVc = [[TestController alloc] init];
                testVc.month = month;
                [self.navigationController pushViewController:testVc animated:YES];
            }
            
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"暂无该月份的测评题" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    else if (curData.msgType  == 12) {
        if ([curData.key isEqualToString:@""]) {
            NoteController* noteVc = [[NoteController alloc] init];
            [self.navigationController pushViewController:noteVc animated:YES];
        }
        else{
            NSArray *arrSplit = [curData.key componentsSeparatedByString:@"|"];
            [BaseMethod saveSelectedDate:[BaseMethod dateFormString:[arrSplit lastObject]]];
            NoteController* noteVc = [[NoteController alloc] init];
            [self.navigationController pushViewController:noteVc animated:YES];
        }
    }
    else if (curData.msgType  == 20) {
        NSArray *arrayHeight = @[@0,@"icon_height.png",@"当前身高",[self getValues:0],[self getIncrease:0],@"CM",[self getRecordDate:0],@"#84c082"];
        PHYDetailViewController *pHYDetailViewController = [[PHYDetailViewController alloc] init];
        [pHYDetailViewController setVar:arrayHeight];
        [self.navigationController pushViewController:pHYDetailViewController animated:YES];
    }
    else if (curData.msgType  == 21) {
        NSArray *arrayWeight = @[@1,@"icon_weight.png",@"当前体重",[self getValues:1],[self getIncrease:1],@"KG",[self getRecordDate:1],@"#efc654"];
        PHYDetailViewController *pHYDetailViewController = [[PHYDetailViewController alloc] init];
        [pHYDetailViewController setVar:arrayWeight];
        [self.navigationController pushViewController:pHYDetailViewController animated:YES];
    }
    else if (curData.msgType  == 22) {
        NSArray *arrayCRI = @[@3,@"icon_CIR.png",@"当前头围",[self getValues:3],[self getIncrease:3],@"CM",[self getRecordDate:3],@"#69b3e0"];
        PHYDetailViewController *pHYDetailViewController = [[PHYDetailViewController alloc] init];
        [pHYDetailViewController setVar:arrayCRI];
        [self.navigationController pushViewController:pHYDetailViewController animated:YES];
    }
    else if (curData.msgType == 99) {
        NSString *str = curData.key;
        NSArray *arrSplit = [str componentsSeparatedByString:@","];
        int tip_id = [[arrSplit lastObject] intValue];
        
        TipsWebViewController *tipsWeb = [[TipsWebViewController alloc]init];
        NSString *Url = [NSString stringWithFormat:@"%@tips/showTip.aspx?id=%d",BASE_URL,tip_id];
        [tipsWeb setTipsUrl:Url];
        [tipsWeb setTipsTitle:curData.msgContent];
        NSString *picUrl = [NSString stringWithFormat:@"%@/%@",WEBPHOTO(@"Tip"),curData.picUrl];
        [tipsWeb setShowImage:picUrl];
        [tipsWeb setFlag:1];
        [self.navigationController pushViewController:tipsWeb animated:YES];
    }
}
#pragma mark 重新设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BabyMsgTableViewCell *cell = _timeLineCells[indexPath.row];
    cell.babyMsg = _timeLineDS[indexPath.row];
    return cell.height;
}

#pragma mark TableViewDataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_timeLineDS count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"Cell";
    BabyMsgTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[BabyMsgTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.babyMsg = _timeLineDS[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    return cell;
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_homeScrollView.contentOffset.y > kHomeTopNavigationBarHeight + _homeScrollView.contentSize.height - _homeScrollView.height - kHomeBottomActivitySpaceHeight && !_actView.isAnimating){
        _homeScrollView.scrollEnabled = NO;
        _actView.frame = CGRectMake(kDeviceWidth / 2 - kHomeBottomActivityViewWeight / 2,_homeHeadView.height +_timeLineTableView.height + 12, kHomeBottomActivityViewHeight, kHomeBottomActivityViewHeight);
        [_actView startAnimating];
        //获取当前列表最后一条的createTime
        BCBabyMsg *babyMsg = [_timeLineDS lastObject];
        [[InitTimeLineData initTimeLine] checkTips:babyMsg.createTime];
    }
}

#pragma mark 原来乱七八糟的东西
#pragma PHY methods
-(NSString*)getIncrease:(int)index{
    if (index != 2) {
        NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyPhysiologyList:index];
        if ([arrValues count] >= 2) {
            NSDictionary *dict1 = [arrValues objectAtIndex:0];
            NSDictionary *dict2 = [arrValues objectAtIndex:1];
            
            double v1 = [[dict1 objectForKey:@"value"] doubleValue];
            double v2 = [[dict2 objectForKey:@"value"] doubleValue];
            
            if (v1 >= v2) {
                return [NSString stringWithFormat:@"↑%0.1f",v1-v2];
            }else{
                return [NSString stringWithFormat:@"↓%0.1f",v2-v1];
            }
        }
        else{
            return @"";
        }
    }
    else{
        NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyBMIList];
        if ([arrValues count] >= 2) {
            NSDictionary *dict1 = [arrValues objectAtIndex:0];
            NSDictionary *dict2 = [arrValues objectAtIndex:1];
            
            double v1 = [[dict1 objectForKey:@"value"] doubleValue];
            double v2 = [[dict2 objectForKey:@"value"] doubleValue];
            
            if (v1 >= v2) {
                return [NSString stringWithFormat:@"↑%0.1f",v1-v2];
            }else{
                return [NSString stringWithFormat:@"↓%0.1f",v2-v1];
            }
        }
        else{
            return @"";
        }
    }
}

-(NSString*)getValues:(int)index{
    //非BMI
    if (index != 2){
        NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyPhysiologyList:index];
        if ([arrValues count] == 0) {
            return @"--";
        }
        else{
            NSDictionary *dict = [arrValues objectAtIndex:0];
            return [NSString stringWithFormat:@"%0.1f",[[dict objectForKey:@"value"] doubleValue]];
        }
    }else{
        NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyBMIList];
        if ([arrValues count] == 0) {
            return @"--";
        }
        else{
            NSDictionary *dict = [arrValues objectAtIndex:0];
            return [NSString stringWithFormat:@"%0.1f",[[dict objectForKey:@"value"] doubleValue]];
        }
    }
    
}

-(NSString*)getRecordDate:(int)index{
    //非BMI
    if (index != 2){
        NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyPhysiologyList:index];
        if ([arrValues count] > 0) {
            NSDictionary *dict = [arrValues objectAtIndex:0];
            NSDate *date = [ACDate getDateFromTimeStamp:[[dict objectForKey:@"measure_time"] longValue]];
            return [ACDate getDaySinceDate:date];
        }
        else{
            return @"尚无记录";
        }
    }
    else{
        NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyBMIList];
        if ([arrValues count] > 0) {
            NSDictionary *dict = [arrValues objectAtIndex:0];
            NSDate *date = [ACDate getDateFromTimeStamp:[[dict objectForKey:@"measure_time"] longValue]];
            return [ACDate getDaySinceDate:date];
        }
        else{
            return @"尚无记录";
        }
    }
}

<<<<<<< HEAD
#pragma mark Sys
- (void)didReceiveMemoryWarning {
=======
#pragma 登陆相关
-(void)doLogin{
    _loginView.hidden = YES;
    
    LoginMainViewController *loginMainViewController = [[LoginMainViewController alloc]initWithNibName:@"LoginMainViewController" bundle:nil];
    loginMainViewController.mainViewController = self;
    [self.navigationController pushViewController:loginMainViewController animated:NO];
}

-(void)doTenLogin{
    _loginView.hidden = YES;
    
    isPushSocialView = YES;
    
    BOOL isOauth = [UMSocialAccountManager isOauthWithPlatform:UMShareToQQ];
    
    if (isOauth) {
        //TODO:有登录过，如何处理
        //return;
    }
//    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                  {
                                      //加载登录进度条
                                      _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                      _hud.mode = MBProgressHUDModeIndeterminate;
                                      _hud.alpha = 0.5;
                                      _hud.color = [UIColor grayColor];
                                      _hud.labelText = @"登录验证中...";
                                      
                                      if ([[snsPlatform platformName] isEqualToString:UMShareToQQ])
                                      {
                                          [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                                              if ([[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQQ] == NULL) {
                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                  return;
                                              }
                                              
                                              //封装数据
                                              NSMutableDictionary *dictBody = [[DataContract dataContract]UserCreateDict:RTYPE_TENCENT account:[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQQ] objectForKey:@"username"]  password:@""];
                                              //Http请求
                                              [[NetWorkConnect sharedRequest]
                                               httpRequestWithURL:USER_LOGIN_URL
                                               data:dictBody
                                               mode:@"POST"
                                               HUD:_hud
                                               didFinishBlock:^(NSDictionary *result){
                                                   _hud.labelText = [result objectForKey:@"msg"];
                                                   //处理反馈信息: code=1为成功  code=99为失败
                                                   if ([[result objectForKey:@"code"]intValue] == 1) {
                                                       NSMutableDictionary *resultBody = [result objectForKey:@"body"];
                                                       [[NSUserDefaults standardUserDefaults] setObject:[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQQ] objectForKey:@"username"]  forKey:@"ACCOUNT_NAME"];
                                                       [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:RTYPE_TENCENT] forKey:@"ACCOUNT_TYPE"];
                                                       [[NSUserDefaults standardUserDefaults] setObject:[resultBody objectForKey:@"userId"] forKey:@"ACCOUNT_UID"];
                                                       [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"BABYID"];
                                                       //数据库保存用户信息
                                                       if ([[UserDataDB dataBase] selectUser:[[resultBody objectForKey:@"userId"] intValue]] == nil){
                                                           [[UserDataDB dataBase] createNewUser:[[resultBody objectForKey:@"userId"]intValue] andCategoryIds:@"" andIcon:@"" andUserType:RTYPE_TENCENT andUserAccount:[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToQQ] objectForKey:@"username"]   andAppVer:PROVERSION andCreateTime:[[resultBody objectForKey:@"createTime"] longValue] andUpdateTime:[[resultBody objectForKey:@"updateTime"] longValue]];
                                                       } 
                                                       //提示是否同步数据
                                                                                    [_hud hide:YES];
                                                       [self performSelector:@selector(isSyncData) withObject:nil afterDelay:0.8];
                                                   }
                                                   else{
                                                       [_hud hide:YES afterDelay:1.2];
                                                   }
                                               }
                                               didFailBlock:^(NSString *error){
                                                   //请求失败处理
                                                   _hud.labelText = http_error;
                                                   [_hud hide:YES afterDelay:1];
                                               }
                                               isShowProgress:YES
                                               isAsynchronic:YES
                                               netWorkStatus:YES
                                               viewController:self];
                                              
                                          }];
                                      }
                                  });
}

-(void)doTentWeiboLogin{
    _loginView.hidden = YES;
    
    isPushSocialView = YES;
    
    BOOL isOauth = [UMSocialAccountManager isOauthWithPlatform:UMShareToTencent];
    if (isOauth) {
        //TODO:有登录过，如何处理
        //return;
    }
    //
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                  {
                                      //加载登录进度条
                                      _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                      _hud.mode = MBProgressHUDModeIndeterminate;
                                      _hud.alpha = 0.5;
                                      _hud.color = [UIColor grayColor];
                                      _hud.labelText = @"登录验证中...";
                                      
                                      if ([[snsPlatform platformName] isEqualToString:UMShareToTencent])
                                      {
                                          [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                                              if ([[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToTencent] == NULL) {
                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                  return;
                                              }
                                              
                                              //封装数据
                                              NSMutableDictionary *dictBody = [[DataContract dataContract]UserCreateDict:RTYPE_TENCENT account:[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToTencent] objectForKey:@"username"]  password:@""];
                                              //Http请求
                                              [[NetWorkConnect sharedRequest]
                                               httpRequestWithURL:USER_LOGIN_URL
                                               data:dictBody
                                               mode:@"POST"
                                               HUD:_hud
                                               didFinishBlock:^(NSDictionary *result){
                                                   _hud.labelText = [result objectForKey:@"msg"];
                                                   //处理反馈信息: code=1为成功  code=99为失败
                                                   if ([[result objectForKey:@"code"]intValue] == 1) {
                                                       NSMutableDictionary *resultBody = [result objectForKey:@"body"];
                                                       [[NSUserDefaults standardUserDefaults] setObject:[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToTencent] objectForKey:@"username"]  forKey:@"ACCOUNT_NAME"];
                                                       [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:RTYPE_TENCENT] forKey:@"ACCOUNT_TYPE"];
                                                       [[NSUserDefaults standardUserDefaults] setObject:[resultBody objectForKey:@"userId"] forKey:@"ACCOUNT_UID"];
                                                       [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"BABYID"];
                                                       //数据库保存用户信息
                                                       if ([[UserDataDB dataBase] selectUser:[[resultBody objectForKey:@"userId"] intValue]] == nil){
                                                           [[UserDataDB dataBase] createNewUser:[[resultBody objectForKey:@"userId"]intValue] andCategoryIds:@"" andIcon:@"" andUserType:RTYPE_TENCENT andUserAccount:[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToTencent] objectForKey:@"username"]   andAppVer:PROVERSION andCreateTime:[[resultBody objectForKey:@"createTime"] longValue] andUpdateTime:[[resultBody objectForKey:@"updateTime"] longValue]];
                                                       }
                                                       //提示是否同步数据
                                                       [_hud hide:YES];
                                                       [self performSelector:@selector(isSyncData) withObject:nil afterDelay:0.8];
                                                   }
                                                   else{
                                                       [_hud hide:YES afterDelay:1.2];
                                                   }
                                               }
                                               didFailBlock:^(NSString *error){
                                                   //请求失败处理
                                                   _hud.labelText = http_error;
                                                   [_hud hide:YES afterDelay:1];
                                               }
                                               isShowProgress:YES
                                               isAsynchronic:YES
                                               netWorkStatus:YES
                                               viewController:self];
                                              
                                          }];
                                      }
                                  });
}


-(void)doSinaLogin{
    _loginView.hidden = YES;
    
    isPushSocialView = YES;
    BOOL isOauth = [UMSocialAccountManager isOauthWithPlatform:UMShareToSina];
    if (isOauth) {
        //TODO:有登录过，如何处理
        //return;
    }
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
                                  {
                                      //加载登录进度条
                                      _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                      _hud.mode = MBProgressHUDModeIndeterminate;
                                      _hud.alpha = 0.5;
                                      _hud.color = [UIColor grayColor];
                                      _hud.labelText = @"登录验证中...";
                                      
                                      if ([[snsPlatform platformName] isEqualToString:UMShareToSina])
                                      {
                                          [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                                              if ([[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] == NULL) {
                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                  return;
                                              }
                                              //封装数据
                                              NSMutableDictionary *dictBody = [[DataContract dataContract]UserCreateDict:RTYPE_SINA account:[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"username"]  password:@""];
                                              //Http请求
                                              [[NetWorkConnect sharedRequest]
                                               httpRequestWithURL:USER_LOGIN_URL
                                               data:dictBody
                                               mode:@"POST"
                                               HUD:_hud
                                               didFinishBlock:^(NSDictionary *result){
                                                   _hud.labelText = [result objectForKey:@"msg"];
                                                   //处理反馈信息: code=1为成功  code=99为失败
                                                   if ([[result objectForKey:@"code"]intValue] == 1) {
                                                       NSMutableDictionary *resultBody = [result objectForKey:@"body"];
                                                       [[NSUserDefaults standardUserDefaults] setObject:[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"username"]  forKey:@"ACCOUNT_NAME"];
                                                       [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:RTYPE_SINA] forKey:@"ACCOUNT_TYPE"];
                                                       [[NSUserDefaults standardUserDefaults] setObject:[resultBody objectForKey:@"userId"] forKey:@"ACCOUNT_UID"];
                                                       [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"BABYID"];
                                                       //数据库保存用户信息
                                                       if ([[UserDataDB dataBase] selectUser:[[resultBody objectForKey:@"userId"] intValue]] == nil){
                                                           [[UserDataDB dataBase] createNewUser:[[resultBody objectForKey:@"userId"]intValue] andCategoryIds:@"" andIcon:@"" andUserType:RTYPE_SINA andUserAccount:[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"username"]   andAppVer:PROVERSION andCreateTime:[[resultBody objectForKey:@"createTime"] longValue] andUpdateTime:[[resultBody objectForKey:@"updateTime"] longValue]];
                                                       }
                                                       //提示是否同步数据
                                                       [_hud hide:YES];
                                                       [self performSelector:@selector(isSyncData) withObject:nil afterDelay:0.8];
                                                   }
                                                   else{
                                                       [_hud hide:YES afterDelay:1.2];
                                                   }
                                               }
                                               didFailBlock:^(NSString *error){
                                                   //请求失败处理
                                                   _hud.labelText = http_error;
                                                   [_hud hide:YES afterDelay:1];
                                               }
                                               isShowProgress:YES
                                               isAsynchronic:YES
                                               netWorkStatus:YES
                                               viewController:self];
                                          }];
                                      }
                                  });

}

-(void)doRegister{
    _loginView.hidden = YES;
    
}

-(void)isSyncData{
    [self checkBaby];
    
    /*UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否同步该账户数据" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
     alertView.tag = 10109;
     [alertView show];
     */
}

#pragma 检测or创建宝贝
-(void)checkBaby{
    if (ACCOUNTUID) {
        int babyId=0;
        /*
         *  判断该账户下是否已有宝宝,如有,则默认加载
         */
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [documentPaths objectAtIndex:0];
        NSError *error = nil;
        NSArray *fileList = [[NSArray alloc] init];
        fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
        BOOL isDir = NO;
        for (NSString *file in fileList) {
            NSString *path = [documentDir stringByAppendingPathComponent:file];
            [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
            if (isDir) {
                NSArray *split = [file componentsSeparatedByString:@"_"];
                if ([split count] == 2 && [[split objectAtIndex:0] intValue] == ACCOUNTUID) {
                    babyId = [[split objectAtIndex:1] intValue];
                    break;
                }
            }
            isDir = NO;
        }
        
        if (babyId != 0) {
            //保存Babyid
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:babyId] forKey:@"BABYID"];
            [[NSUserDefaults standardUserDefaults] setInteger:babyId forKey:@"cur_babyid"];
            NSDictionary *dict = [[BabyDataDB babyinfoDB] selectBabyInfoByBabyId:babyId];
            [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"nickname"] forKey:@"kBabyNickname"];
            [self viewWillAppear:NO];
            return;
        }
        
        if (!BABYID) {
            //注册接口
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //隐藏键盘
            _hud.mode = MBProgressHUDModeIndeterminate;
            _hud.alpha = 0.5;
            _hud.color = [UIColor grayColor];
            _hud.labelText = http_requesting;
            //封装数据
            NSMutableDictionary *dictBody = [[DataContract dataContract]BabyCreateByUserIdDict:ACCOUNTUID];
            //Http请求
            [[NetWorkConnect sharedRequest]
             httpRequestWithURL:BABY_CREATEBYUSERID_URL
             data:dictBody
             mode:@"POST"
             HUD:_hud
             didFinishBlock:^(NSDictionary *result){
                 _hud.labelText = [result objectForKey:@"msg"];
                 //处理反馈信息: code=1为成功  code=99为失败
                 if ([[result objectForKey:@"code"]intValue] == 1) {
                     NSMutableDictionary *resultBody = [result objectForKey:@"body"];
                     //保存Babyid
                     [[NSUserDefaults standardUserDefaults]setObject:[resultBody objectForKey:@"babyId"] forKey:@"BABYID"];
                     //数据库保存Baby信息
                     [BabyDataDB createNewBabyInfo:ACCOUNTUID BabyId:BABYID Nickname:@"" Birthday:nil Sex:nil HeadPhoto:@"" RelationShip:@"" RelationShipNickName:@"" Permission:nil CreateTime:[resultBody objectForKey:@"create_time"] UpdateTime:nil];
                     [_hud hide:YES afterDelay:0.5];
                     _loginView.hidden = YES;
                     [self viewWillAppear:NO];
                 }
                 else{
                     _hud.labelText = http_error;
                     [_hud hide:YES afterDelay:1];
                 }
             }
             didFailBlock:^(NSString *error){
                 //请求失败处理
                 _hud.labelText = http_error;
                 [_hud hide:YES afterDelay:1];
             }
             isShowProgress:YES
             isAsynchronic:NO
             netWorkStatus:YES
             viewController:self];
        }
    }
}

#pragma 给APP评分
-(void)ReviewTheApp{
    /*
     *  app_url                 :app地址
     *  review_last_alert_time  :最后提醒评分时间
     *  review_state            :评分状态 YES已评分
     */
    
    //获取app_url信息
    
    NSString *app_url = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_url"];
    if ([app_url isEqual:@""] || app_url == nil) {
        //get url
        NSMutableDictionary *dictBody = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"unname",@"unname",nil];
        
        
        NetWorkConnect *_netWorkConnect = [[NetWorkConnect alloc]init]; 
        [_netWorkConnect httpRequestWithURL:GET_APP_INFO
                                                     data:dictBody
                                                     mode:@"POST"
                                                      HUD:nil
                                           didFinishBlock:^(NSDictionary *result)
         {
             //请求成功处理
             NSDictionary *dict = [result objectForKey:@"body"];
             if (![[dict objectForKey:@"app_url"]  isEqual: @""])
             {
                 [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"app_url"] forKey:@"app_url"];
                 [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"app_name"] forKey:@"app_name"];
                 [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:[ACDate getTimeStampFromDate:[ACDate date]]] forKey:@"review_last_alert_time"];
                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"review_state"];
             }
         }
                                             didFailBlock:^(NSString *error){}
                                           isShowProgress:YES
                                            isAsynchronic:YES
                                            netWorkStatus:YES
                                           viewController:nil];
        
        return;
    }
    
    long review_last_alert_time = [[[NSUserDefaults standardUserDefaults] objectForKey:@"review_last_alert_time"] longValue];
    bool review_state = [[NSUserDefaults standardUserDefaults] boolForKey:@"review_state"];
    
    if (![app_url isEqualToString:@""] && !review_state && ([ACDate getDiffDayFormNowToDate:[ACDate getDateFromTimeStamp:review_last_alert_time]] >= 7 || review_last_alert_time == 0) ){
        [self showReviewAlert];
    }
}

-(void)showReviewAlert{
    if (_alertView == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:[ACDate getTimeStampFromDate:[NSDate date]]] forKey:@"review_last_alert_time"];
        _alertView = [[UIAlertView alloc] initWithTitle:@"给宝贝计划好评" message:@"如果您喜欢宝贝计划,请给我们一个五星评价,您的鼓励是我们进步的最大动力!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"喜欢,我五星评价",@"稍后再说",@"不再提醒", nil];
        [_alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //评价跳转
        NSLog(@"url:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"app_url"]);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"app_url"]]];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"review_state"];
    }
    else if(buttonIndex == 1){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:[ACDate getTimeStampFromDate:[ACDate date]]] forKey:@"review_last_alert_time"];
    }
    else{
        //不在提示
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"review_state"];
    }
}

- (void)didReceiveMemoryWarning
{
>>>>>>> 1eddceeaed5df67ca7bd275bcaba33510ca2047f
    [super didReceiveMemoryWarning];
}
 
@end
