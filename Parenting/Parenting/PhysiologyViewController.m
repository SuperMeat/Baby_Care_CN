//
//  PhysiologyViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-18.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "PhysiologyViewController.h"
#import "BabyDataDB.h"

@interface PhysiologyViewController ()

@end

@implementation PhysiologyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"生理"];
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

-(void)removeSubViews{
    [datepicker removeFromSuperview];
    [slider removeFromSuperview];
    [contentView removeFromSuperview];
    [buttonSave removeFromSuperview];
    [buttonCancel removeFromSuperview];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self removeSubViews];
    [MobClick endLogPageView:@"活动页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}

-(void)initView{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:@"生理"];
    [titleView addSubview:titleText];
    self.physiologyImageView = [[UIImageView alloc] init];
    [self.physiologyImageView setFrame:CGRectMake(0, 0, 320, 64)];
    [self.physiologyImageView setBackgroundColor:[ACFunction colorWithHexString:@"#68bfcc"]];
    
    [self.physiologyImageView addSubview:titleView];
    [self.view addSubview:self.physiologyImageView];
    [self.physiologyImageView setUserInteractionEnabled:YES];
    
    
    //身高view
    _viewHeight.userInteractionEnabled = YES;
    _viewHeight.tag = 10401;
    UITapGestureRecognizer *tapgesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemSelected:)];
    [_viewHeight addGestureRecognizer:tapgesture1];
    _labelHeightValue.layer.masksToBounds = YES;
    _labelHeightValue.layer.cornerRadius = 3;
    _buttonHeightChart.tag = 10401301;
    [_buttonHeightChart addTarget:self action:@selector(itemDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    //体重view
    _viewWeight.userInteractionEnabled = YES;
    _viewWeight.tag = 10402;
    UITapGestureRecognizer *tapgesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemSelected:)];
    [_viewWeight addGestureRecognizer:tapgesture2];
    _labelWeightValue.layer.masksToBounds = YES;
    _labelWeightValue.layer.cornerRadius = 3;
    _buttonWeightChart.tag = 10401302;
    [_buttonWeightChart addTarget:self action:@selector(itemDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    //BIMview
    _viewBMI.userInteractionEnabled = YES;
    _viewBMI.tag = 10403;
    UITapGestureRecognizer *tapgesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemSelected:)];
    [_viewBMI addGestureRecognizer:tapgesture3];
    _labelBMIValue.layer.masksToBounds = YES;
    _labelBMIValue.layer.cornerRadius = 3;
    _buttonBMIChart.tag = 10401303;
    [_buttonBMIChart addTarget:self action:@selector(itemDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    //头尾view
    _viewCir.userInteractionEnabled = YES;
    _viewCir.tag = 10404;
    UITapGestureRecognizer *tapgesture4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemSelected:)];
    [_viewCir addGestureRecognizer:tapgesture4];
    _labelCirValue.layer.masksToBounds = YES;
    _labelCirValue.layer.cornerRadius = 3;
    _buttonCirChart.tag = 10401304;
    [_buttonCirChart addTarget:self action:@selector(itemDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    //体温view
    _viewTemperature.userInteractionEnabled = YES;
    _viewTemperature.tag = 10405;
    UITapGestureRecognizer *tapgesture5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemSelected:)];
    [_viewTemperature addGestureRecognizer:tapgesture5];
    _labelTemperValue.layer.masksToBounds = YES;
    _labelTemperValue.layer.cornerRadius = 3;
    _buttonTemperChart.tag = 10401305;
    [_buttonTemperChart addTarget:self action:@selector(itemDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    //内容view
    contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.borderWidth = 1;
    contentView.layer.borderColor = [[UIColor colorWithRed:0.52f green:0.09f blue:0.07f alpha:0.15] CGColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 15;
}

-(void)initData{
    //身高
    NSArray *arrHeight = [[BabyDataDB babyinfoDB]selectBabyPhysiologyList:0];
    if (arrHeight.count > 0) {
        NSDictionary *dictHeight = [arrHeight objectAtIndex:0];
        _labelHeightValue.text = [NSString stringWithFormat:@"%.1f cm",[[dictHeight objectForKey:@"value"] doubleValue]];
        _labelHeightDate.text=[ACDate getDaySinceDate:[ACDate getDateFromTimeStamp:[[dictHeight objectForKey:@"measure_time"] longValue]]];
    }
    else{
        _labelHeightValue.text = @"尚无数据";
        _labelHeightDate.text = @"";
    }
    
    //体重
    NSArray *arrWeight = [[BabyDataDB babyinfoDB]selectBabyPhysiologyList:1];
    if (arrWeight.count > 0) {
        NSDictionary *dictWeight = [arrWeight objectAtIndex:0];
        _labelWeightValue.text = [NSString stringWithFormat:@"%.1f cm",[[dictWeight objectForKey:@"value"] doubleValue]];
        _labelWeightDate.text=[ACDate getDaySinceDate:[ACDate getDateFromTimeStamp:[[dictWeight objectForKey:@"measure_time"] longValue]]];
    }
    else{
        _labelWeightValue.text = @"尚无数据";
        _labelWeightDate.text = @"";
    }
    
    //BMI
    NSArray *arrBMI = [[BabyDataDB babyinfoDB]selectBabyPhysiologyList:2];
    if (arrBMI.count > 0) {
        NSDictionary *dictBMI = [arrBMI objectAtIndex:0];
        _labelBMIValue.text = [NSString stringWithFormat:@"%.1f cm",[[dictBMI objectForKey:@"value"] doubleValue]];
        _labelBMIDate.text=[ACDate getDaySinceDate:[ACDate getDateFromTimeStamp:[[dictBMI objectForKey:@"measure_time"] longValue]]];
    }
    else{
        _labelBMIValue.text = @"尚无数据";
        _labelBMIDate.text = @"";
    }
    
    //头围
    NSArray *arrCir = [[BabyDataDB babyinfoDB]selectBabyPhysiologyList:3];
    if (arrCir.count > 0) {
        NSDictionary *dictCir = [arrCir objectAtIndex:0];
        _labelCirValue.text = [NSString stringWithFormat:@"%.1f cm",[[dictCir objectForKey:@"value"] doubleValue]];
        _labelCirDate.text=[ACDate getDaySinceDate:[ACDate getDateFromTimeStamp:[[dictCir objectForKey:@"measure_time"] longValue]]];
    }
    else{
        _labelCirValue.text = @"尚无数据";
        _labelCirDate.text = @"";
    }
    
    //Temper
    NSArray *arrTemper = [[BabyDataDB babyinfoDB]selectBabyPhysiologyList:4];
    if (arrTemper.count > 0) {
        NSDictionary *dictTemper = [arrTemper objectAtIndex:0];
        _labelTemperValue.text = [NSString stringWithFormat:@"%.1f cm",[[dictTemper objectForKey:@"value"] doubleValue]];
        _labelTemperDate.text=[ACDate getDaySinceDate:[ACDate getDateFromTimeStamp:[[dictTemper objectForKey:@"measure_time"] longValue]]];
    }
    else{
        _labelTemperValue.text = @"尚无数据";
        _labelTemperDate.text = @"";
    }
}

-(void)itemDetail:(UIButton*)button{
    phyDetailViewController = [[PhyDetailViewController alloc]init];
    switch (button.tag) {
        case 10401301:
            [phyDetailViewController setItemIndex:1];
            break;
        case 10401302:
            [phyDetailViewController setItemIndex:2];
            break;
        case 10401303:
            [phyDetailViewController setItemIndex:3];
            break;
        case 10401304:
            [phyDetailViewController setItemIndex:4];
            break;
        case 10401305:
            [phyDetailViewController setItemIndex:5];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:phyDetailViewController animated:YES];
}

-(void)itemSelected:(UITapGestureRecognizer *)recognizer{
    //清空附加view
    if ([_scrollerView.subviews containsObject:contentView]) {
        return;
    }
    
    //保存和取消按钮
    buttonSave = [[UIButton alloc] init];
    buttonSave.frame = CGRectMake(320-10-40,22, 40, 40);
    buttonSave.titleLabel.font = [UIFont systemFontOfSize:14];
    [buttonSave setTitle:@"保存" forState:UIControlStateNormal];
    [buttonSave addTarget:self action:@selector(saveRecord:) forControlEvents:UIControlEventTouchUpInside];
    [_physiologyImageView addSubview:buttonSave];
    
    buttonCancel = [[UIButton alloc] init];
    buttonCancel.frame = CGRectMake(10, 22, 40, 40);
    buttonCancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchUpInside];
    [_physiologyImageView addSubview:buttonCancel];
    

    
    UIView *view = recognizer.view;
    CGPoint scollPosition = CGPointMake(0,view.frame.origin.y - 10);
    //内容view
    contentView.frame = CGRectMake(15, view.frame.origin.y + view.frame.size.height + 12, 290, 280);
    
    //滑动取值
    slider = [[UISlider alloc]initWithFrame:CGRectMake(5, 15, 280, 30)];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //内容view datePicker
    datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 55 , 0, 0)];
    datepicker.backgroundColor = [UIColor whiteColor];
    datepicker.datePickerMode=UIDatePickerModeDate;
    [datepicker setMaximumDate:[NSDate date]];
    [datepicker addTarget:self action:@selector(updaterRecordDate:) forControlEvents:UIControlEventValueChanged];
    
    if (view.tag == 10401) {
        if (![_labelHeightValue.text  isEqual: @"尚无数据"]) {
            slider.minimumValue = 35.0f;
            slider.maximumValue = 80.0f;
        }
        else{
            //根据当前值浮动
            slider.minimumValue = 35.0f;
            slider.maximumValue = 80.0f;
        }
        _labelHeightValue.text = @"";
        _labelHeightDate.text = @"今天";
        slider.tag = 10401001;
        datepicker.tag = 10401101;
        buttonSave.tag = 10401201;
    }
    else if (view.tag == 10402){
        if (![_labelWeightValue.text  isEqual: @"尚无数据"]) {
            slider.minimumValue = 2.5f;
            slider.maximumValue = 10.0f;
        }
        else{
            //根据当前值浮动
            slider.minimumValue = 2.5f;
            slider.maximumValue = 10.0f;
        }
        _labelWeightValue.text = @"";
        _labelWeightDate.text = @"今天";
        slider.tag = 10401002;
        datepicker.tag = 10401102;
        buttonSave.tag = 10401202;
    }
    else if (view.tag == 10403){
        //BMI不做处理
        return;
    }
    else if (view.tag == 10404){
        if (![_labelCirValue.text  isEqual: @"尚无数据"]) {
            slider.minimumValue = 2.5f;
            slider.maximumValue = 10.0f;
        }
        else{
            //根据当前值浮动
            slider.minimumValue = 2.5f;
            slider.maximumValue = 10.0f;
        }
        _labelCirValue.text = @"";
        _labelCirDate.text = @"今天";
        slider.tag = 10401004;
        datepicker.tag = 10401104;
        buttonSave.tag = 10401204;
    }
    else if (view.tag == 10405){
        if (![_labelTemperValue.text  isEqual: @"尚无数据"]) {
            slider.minimumValue = 2.5f;
            slider.maximumValue = 10.0f;
        }
        else{
            //根据当前值浮动
            slider.minimumValue = 2.5f;
            slider.maximumValue = 10.0f;
        }
        _labelTemperValue.text = @"";
        _labelTemperDate.text = @"今天";
        slider.tag = 10401005;
        datepicker.tag = 10401105;
        buttonSave.tag = 10401205;
    }
    
    [contentView addSubview:slider];
    [contentView addSubview:datepicker];
    [_scrollerView addSubview:contentView];
    [_scrollerView setContentOffset:scollPosition animated:YES];
}

-(void)saveRecord:(UIButton*)button{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入数值" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    if (button.tag == 10401201) {
        if (![_labelHeightValue.text  isEqual: @""]) {
            float progress = (float)roundf(slider.value);
            int updateTime = 0;
            if (NO) {
                //接口
                updateTime = 10001001;
            }
            [[BabyDataDB babyinfoDB] insertBabyPhysiology:[ACDate getTimeStampFromDate:datepicker.date] UpdateTime:updateTime MeasureTime:[ACDate getTimeStampFromDate:datepicker.date] Type:0 Value:progress];
        }
        else{
            [alertView show];
            return;
        }
    }
    else if (button.tag == 10401202) {
        if (![_labelWeightValue.text  isEqual: @""]) {
            float progress = (float)roundf(slider.value);
            int updateTime = 0;
            if (NO) {
                //接口
                updateTime = 10001002;
            }
            [[BabyDataDB babyinfoDB] insertBabyPhysiology:[ACDate getTimeStampFromDate:datepicker.date] UpdateTime:updateTime MeasureTime:[ACDate getTimeStampFromDate:datepicker.date] Type:1 Value:progress];
        }
        else{
            [alertView show];
            return;
        }
    }
    else if (button.tag == 10401204) {
        if (![_labelCirValue.text  isEqual: @""]) {
            float progress = (float)roundf(slider.value);
            int updateTime = 0;
            if (NO) {
                //接口
                updateTime = 10001004;
            }
            [[BabyDataDB babyinfoDB] insertBabyPhysiology:[ACDate getTimeStampFromDate:datepicker.date] UpdateTime:updateTime MeasureTime:[ACDate getTimeStampFromDate:datepicker.date] Type:3 Value:progress];
        }
        else{
            [alertView show];
            return;
        }
    }
    else if (button.tag == 10401205) {
        if (![_labelTemperValue.text  isEqual: @""]) {
            float progress = (float)roundf(slider.value);
            int updateTime = 0;
            if (NO) {
                //接口
                updateTime = 10001005;
            }
            [[BabyDataDB babyinfoDB] insertBabyPhysiology:[ACDate getTimeStampFromDate:datepicker.date] UpdateTime:updateTime MeasureTime:[ACDate getTimeStampFromDate:datepicker.date] Type:4 Value:progress];
        }
        else{
            [alertView show];
            return;
        }
    }
    
    [self removeSubViews];
    [_scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self initData];
}

-(void)cancelRecord:(UIButton*)button{
    [self removeSubViews];
    [_scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self initData];
}

#pragma 数值
-(void)sliderValueChanged:(UISlider*)cur_slider
{
    if (cur_slider.tag == 10401001) {
        float progress = (float)roundf(cur_slider.value);
        _labelHeightValue.text = [NSString stringWithFormat:@"%.1f cm",progress];
    }
    else if (cur_slider.tag == 10401002) {
        float progress = (float)roundf(cur_slider.value);
        _labelWeightValue.text = [NSString stringWithFormat:@"%.1f cm",progress];
    }
    else if (cur_slider.tag == 10401004) {
        float progress = (float)roundf(cur_slider.value);
        _labelCirValue.text = [NSString stringWithFormat:@"%.1f cm",progress];
    }
    else if (cur_slider.tag == 10401005) {
        float progress = (float)roundf(cur_slider.value);
        _labelTemperValue.text = [NSString stringWithFormat:@"%.1f cm",progress];
    }
}

#pragma 时间
-(void)updaterRecordDate:(UIDatePicker*)cur_datePicker
{
    if (cur_datePicker.tag == 10401101) {
        NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        NSLog(@"%@",[ACDate getDayBeforeDespFromDate:cur_datePicker.date]);
        _labelHeightDate.text=[ACDate getDaySinceDate:cur_datePicker.date];
    }
    else if (cur_datePicker.tag == 10401102) {
        NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        NSLog(@"%@",[ACDate getDayBeforeDespFromDate:cur_datePicker.date]);
        _labelWeightDate.text=[ACDate getDaySinceDate:cur_datePicker.date];
    }
    else if (cur_datePicker.tag == 10401104) {
        NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        NSLog(@"%@",[ACDate getDayBeforeDespFromDate:cur_datePicker.date]);
        _labelCirDate.text=[ACDate getDaySinceDate:cur_datePicker.date];
    }
    else if (cur_datePicker.tag == 10401105) {
        NSDateFormatter *dateFormater=[[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        
        NSLog(@"%@",[ACDate getDayBeforeDespFromDate:cur_datePicker.date]);
        _labelTemperDate.text=[ACDate getDaySinceDate:cur_datePicker.date];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
