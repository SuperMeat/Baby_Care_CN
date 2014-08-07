//
//  EditPhyViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-5.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "EditPhyViewController.h"
#import "BabyDataDB.h"

#define _APR_VIEW1_H 40
#define _APR_VIEW2_H 210
#define _APR_VIEW4_H 60

@interface EditPhyViewController ()

@end

@implementation EditPhyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
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

- (void)viewDidLoad
{
    [super viewDidLoad]; 
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated   {
    [self initDate];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //navigationBar
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    titleView.backgroundColor=[UIColor clearColor];
    _titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _titleText.backgroundColor = [UIColor clearColor];
    [_titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    _titleText.textColor = [UIColor whiteColor];
    [_titleText setTextAlignment:NSTextAlignmentCenter];
    [titleView addSubview:_titleText];
    self.phyDetailImageView = [[UIImageView alloc] init];
    [self.phyDetailImageView setFrame:CGRectMake(0, 0, 320, 64)];
    [self.phyDetailImageView setBackgroundColor:[ACFunction colorWithHexString:@"#68bfcc"]];
    
    [self.phyDetailImageView addSubview:titleView];
    [self.view addSubview:self.phyDetailImageView];
    [self.phyDetailImageView setUserInteractionEnabled:YES];
    
    _buttonBack = [[UIButton alloc] init];
    _buttonBack.frame = CGRectMake(10, 22, 40, 40);
    _buttonBack.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [_buttonBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_phyDetailImageView addSubview:_buttonBack];
    
    _buttonSave = [[UIButton alloc] init];
    _buttonSave.frame = CGRectMake(320-10-40,22, 40, 40);
    _buttonSave.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonSave setTitle:@"保存" forState:UIControlStateNormal];
    [_buttonSave addTarget:self action:@selector(SaveRecord) forControlEvents:UIControlEventTouchUpInside];
    [_phyDetailImageView addSubview:_buttonSave];
    
    //日期标签
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, _APR_VIEW1_H)];
    _view1.backgroundColor = [ACFunction colorWithHexString:@"#f6f6f6"];
    [self.view addSubview:_view1];
    
    _labelPickerDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 320, 32)];
    _labelPickerDate.font = [UIFont fontWithName:@"Arial" size:24];
    _labelPickerDate.textAlignment = NSTextAlignmentCenter;
    [_view1 addSubview:_labelPickerDate];
    
    //选择器
    _view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 64 + _APR_VIEW1_H, self.view.bounds.size.width, _APR_VIEW2_H)];
    [self.view addSubview:_view2];
    
    datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 162)];
    datepicker.datePickerMode=UIDatePickerModeDate;
    [datepicker addTarget:self action:@selector(updatePickerDate:) forControlEvents:UIControlEventValueChanged];
    datepicker.maximumDate = [ACDate date];
    [_view2 addSubview:datepicker];
    
    //显示数值
    _view3 = [[UIView alloc]initWithFrame:CGRectMake(0,  64 + _APR_VIEW1_H + _APR_VIEW2_H, self.view.bounds.size.width, [[UIScreen mainScreen] bounds].size.height - 64 - _APR_VIEW1_H - _APR_VIEW2_H - _APR_VIEW4_H)];
    _view3.backgroundColor = [ACFunction colorWithHexString:@"#f6f6f6"];
    [self.view addSubview:_view3];
    
    _labelValue = [[UILabel alloc] initWithFrame:CGRectMake(120, [[UIScreen mainScreen] bounds].size.height - 64 - _APR_VIEW1_H - _APR_VIEW2_H - _APR_VIEW4_H - 50 , 80, 32)];
    _labelValue.font = [UIFont fontWithName:@"Arial" size:36];
    _labelValue.textAlignment = NSTextAlignmentCenter;
    [_view3 addSubview:_labelValue];
    
    _labelUnit = [[UILabel alloc]initWithFrame:CGRectMake(_labelValue.frame.origin.x + _labelValue.frame.size.width, _labelValue.frame.origin.y+6, 32, 32)];
    
    [_view3 addSubview:_labelUnit];
    
    
    //显示滚动滑竿
    _view4 = [[UIView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height -_APR_VIEW4_H, self.view.bounds.size.width, _APR_VIEW4_H)];
    [self.view addSubview:_view4];
    
    _slidlerValue = [[UISlider alloc] initWithFrame:CGRectMake(0, 15, 320, 20)];
    [_slidlerValue addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
    //设置响应事件
    [_view4 addSubview:_slidlerValue];
}

-(void)initDate{
    switch (itemType) {
        case 0:
            _titleText.text = @"身高";
            _labelUnit.text = @"CM";
            _slidlerValue.minimumValue = 40;
            _slidlerValue.maximumValue = 100;
            break;
        case 1:
            _titleText.text = @"体重";
            _labelUnit.text = @"KG";
            
            _slidlerValue.minimumValue = 2.5;
            _slidlerValue.maximumValue = 15;
            break;
        case 2:
            //_titleText.text = @"BMI";
            break;
        case 3:
            _titleText.text = @"头围";
            _labelUnit.text = @"CM";
            
            _slidlerValue.minimumValue = 30;
            _slidlerValue.maximumValue = 55;
            break;
        case 4:
            //_titleText.text = @"体温";
            break;
        default:
            break;
    }
    //加载数据
    NSDictionary *dictRes = [[BabyDataDB babyinfoDB] selectBabyPhysiologyDetail:itemType CreateTime:itemCreateTime];
    [datepicker setDate:[ACDate getDateFromTimeStamp:[[dictRes objectForKey:@"measure_time"] longValue]]];
    _labelPickerDate.text = [self stringFromDate:datepicker.date];
    _slidlerValue.value = [[dictRes objectForKey:@"value"] floatValue];
    _labelValue.text = [NSString stringWithFormat:@"%0.1f",_slidlerValue.value];
}

-(void)setType:(int)Type{
    itemType =Type;
}

-(void)setCreateTime:(long)createTime{
    itemCreateTime = createTime;
}

-(void)setMeasureTime:(long)measureTime{
    itemMeasureTime = measureTime;
}

-(void)updatePickerDate:(UIDatePicker*)picker{
    _labelPickerDate.text =[self stringFromDate:[picker date]];
}

-(void)updateSliderValue:(UISlider*)slider{
    _labelValue.text = [NSString stringWithFormat:@"%0.1f",slider.value];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SaveRecord{
    if ([[BabyDataDB babyinfoDB] updateBabyPhysiology:[_labelValue.text doubleValue] CreateTime:itemCreateTime UpdateTime:[ACDate getTimeStampFromDate:[ACDate date]] MeasureTime:[ACDate getTimeStampFromDate:[datepicker date]]  Type:itemType]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改成功!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    //NSLog(@"date  %@",date);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit;
    
    comps=[calendar components:unitFlags fromDate:date];
    NSString *week;
    switch ([comps weekday]) {
        case 1:
            week=NSLocalizedString(@"Sunday", nil);
            break;
        case 2:
            week=NSLocalizedString(@"Monday", nil);
            break;
        case 3:
            week=NSLocalizedString(@"Tuesday", nil);
            break;
        case 4:
            week=NSLocalizedString(@"Wednesday", nil);
            break;
        case 5:
            week=NSLocalizedString(@"Thursday", nil);
            break;
        case 6:
            week=NSLocalizedString(@"Friday", nil);
            break;
        case 7:
            week=NSLocalizedString(@"Saturday", nil);
            break;
            
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@   %@",destDateString,week];;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
