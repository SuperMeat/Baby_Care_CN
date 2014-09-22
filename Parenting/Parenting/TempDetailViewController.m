//
//  TempDetailViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-7.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "TempDetailViewController.h"
#import "BabyDataDB.h"
#import "PHYHistoryViewController.h"
#import "GetPhyAdvise.h"

#define YAXISCOUNT 5
#define SIZEINTERVA 10
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

@interface TempDetailViewController ()

@end

@implementation TempDetailViewController

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
    
    itemType = 4;
    itemName = @"体温";
    itemUnit = @"°C";
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [MobClick beginLogPageView:@"体温详细页"];
    self.hidesBottomBarWhenPushed=YES;
    [self initData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"体温详细页"];
}

-(void)initView{
    //navigationBar
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:itemName];
    [titleView addSubview:titleText];
    self.phyDetailImageView = [[UIImageView alloc] init];
    [self.phyDetailImageView setFrame:CGRectMake(0, 0, 320, 64)];
    [self.phyDetailImageView setBackgroundColor:[ACFunction colorWithHexString:@"#68bfcc"]];
    
    [self.phyDetailImageView addSubview:titleView];
    [self.view addSubview:self.phyDetailImageView];
    [self.phyDetailImageView setUserInteractionEnabled:YES];
    
    _buttonBack = [[UIButton alloc] init];
    _buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonBack setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    _buttonBack.frame = CGRectMake(0, 22, 50, 41);
    [_buttonBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_phyDetailImageView addSubview:_buttonBack];
    
    _buttonAdd = [[UIButton alloc] init];
    _buttonAdd.frame = CGRectMake(320-10-40,22, 40, 40);
    _buttonAdd.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonAdd setTitle:@"添加" forState:UIControlStateNormal];
    [_buttonAdd addTarget:self action:@selector(AddRecord) forControlEvents:UIControlEventTouchUpInside];
    [_phyDetailImageView addSubview:_buttonAdd];
    
    _buttonTip = [[UIButton alloc] init];
    _buttonTip.frame = CGRectMake(50, 22, 40, 40);
    _buttonTip.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonTip setTitle:@"i" forState:UIControlStateNormal];
    
    //    [_phyDetailImageView addSubview:_buttonTip];
    
    //_viewTop1
    _viewTop1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 65)];
    _viewTop1.backgroundColor = [ACFunction colorWithHexString:@"#f6f6f6"];
    [self.view addSubview:_viewTop1];
    
    //_viewTop1_LAST
    _labelLastValue = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
    _labelLastValue.font = [UIFont fontWithName:@"Arial" size:20];
    _labelLastValue.textColor = [ACFunction colorWithHexString:[arrayCurrent objectAtIndex:7]];
    _labelLastValue.textAlignment = NSTextAlignmentLeft;
    
    UILabel *labelLastTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 80, 20)];
    labelLastTitle.font = [UIFont fontWithName:@"Arial" size:10];
    labelLastTitle.textAlignment = NSTextAlignmentLeft;
    labelLastTitle.text = [NSString stringWithFormat:@"上次%@",itemName];
    
    _labelLastDate = [[UILabel alloc]initWithFrame:CGRectMake(10, 42, 120, 20)];
    _labelLastDate.font = [UIFont fontWithName:@"Arial" size:12];
    _labelLastDate.textAlignment = NSTextAlignmentLeft;
    
    [_viewTop1 addSubview:_labelLastValue];
    [_viewTop1 addSubview:labelLastTitle];
    [_viewTop1 addSubview:_labelLastDate];
    
    //_viewTop1_CURRENT
    _labelCURValue = [[UILabel alloc]initWithFrame:CGRectMake(135, 10, 80, 20)];
    _labelCURValue.font = [UIFont fontWithName:@"Arial" size:20];
    _labelCURValue.textColor = [ACFunction colorWithHexString:[arrayCurrent objectAtIndex:7]];
    _labelCURValue.textAlignment = NSTextAlignmentLeft;
    
    UILabel *labelCURTitle = [[UILabel alloc]initWithFrame:CGRectMake(135, 30, 80, 20)];
    labelCURTitle.font = [UIFont fontWithName:@"Arial" size:10];
    labelCURTitle.textAlignment = NSTextAlignmentLeft;
    labelCURTitle.text = [NSString stringWithFormat:@"当前%@",itemName];
    
    _labelCURDate = [[UILabel alloc]initWithFrame:CGRectMake(135, 42, 120, 20)];
    _labelCURDate.font = [UIFont fontWithName:@"Arial" size:12];
    _labelCURDate.textAlignment = NSTextAlignmentLeft;
    
    //_viewTop1_CHANGE
    _labelChangeValue = [[UILabel alloc]initWithFrame:CGRectMake(260, 10, 60, 20)];
    _labelChangeValue.font = [UIFont fontWithName:@"Arial" size:20];
    _labelChangeValue.textColor = [ACFunction colorWithHexString:[arrayCurrent objectAtIndex:7]];
    _labelCURValue.textAlignment = NSTextAlignmentLeft;
    
    UILabel *labelChangeTitle = [[UILabel alloc]initWithFrame:CGRectMake(260, 30, 60, 20)];
    labelChangeTitle.font = [UIFont fontWithName:@"Arial" size:10];
    labelChangeTitle.textAlignment = NSTextAlignmentLeft;
    labelChangeTitle.text = @"变化";
    
    [_viewTop1 addSubview:_labelCURValue];
    [_viewTop1 addSubview:labelCURTitle];
    [_viewTop1 addSubview:_labelCURDate];
    [_viewTop1 addSubview:_labelChangeValue];
    [_viewTop1 addSubview:labelChangeTitle];
    
    //_viewTopHistroy
    _viewHistroy = [[UIView alloc]initWithFrame:CGRectMake(0, 130, self.view.bounds.size.width, 44)];
    _viewHistroy.backgroundColor = [ACFunction colorWithHexString:@"#f6f6f6"];
    //添加手势
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ShowHistory)];
    [_viewHistroy addGestureRecognizer:tapgesture];
    
    [self.view addSubview:_viewHistroy];
    
    UILabel *labelHistory = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, 200, 20)];
    labelHistory.font = [UIFont fontWithName:@"Arial" size:16];
    labelHistory.textAlignment = NSTextAlignmentLeft;
    labelHistory.text = @"查看所有记录";
    [_viewHistroy addSubview:labelHistory];
    
    UILabel *labelHistoryArrow = [[UILabel alloc]initWithFrame:CGRectMake(285, 12, 25, 25)];
    labelHistoryArrow.font = [UIFont fontWithName:@"Arial" size:24];
    labelHistoryArrow.textAlignment = NSTextAlignmentLeft;
    labelHistoryArrow.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    labelHistoryArrow.text = @">";
    [_viewHistroy addSubview:labelHistoryArrow];
    
    //corePlot
    plotHeight=180;
    if (DEVICE_IS_IPHONE5) {
        plotHeight = 268;
    }
    
    _viewPlot = [[UIView alloc]initWithFrame:CGRectMake(0, 175, self.view.bounds.size.width, plotHeight)];
    _viewPlot.backgroundColor = [UIColor colorWithRed:250/255.0  green:250/255.0 blue:250/255.0 alpha:1.0];
    //[ACFunction colorWithHexString:@"#f6f6f6"];
    [self.view addSubview:_viewPlot];
    
    //adviseView
    [self makeAdvise:CGRectMake(0,175+plotHeight, 320, [UIScreen mainScreen].bounds.size.height - 175 - plotHeight)];
}

-(void)initData{
    //_viewTop1
    arrValues = [[BabyDataDB babyinfoDB] selectBabyPhysiologyList:[[arrayCurrent objectAtIndex:0] intValue]];
    if ([arrValues count] >= 2) {
        NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        //LAST
        NSDictionary *dict2 = [arrValues objectAtIndex:1];
        double v2 = [[dict2 objectForKey:@"value"] doubleValue];
        NSDate *dateB = [ACDate getDateFromTimeStamp:[[dict2 objectForKey:@"measure_time"] longValue]];
        _labelLastValue.text = [NSString stringWithFormat:@"%0.1f",[[dict2 objectForKey:@"value"] doubleValue]];
        _labelLastDate.text = [ACDate dateDetailFomatdate2:dateB];
        
        //CURRENT
        NSDictionary *dict1 = [arrValues objectAtIndex:0];
        double v1 = [[dict1 objectForKey:@"value"] doubleValue];
        NSDate *date = [ACDate getDateFromTimeStamp:[[dict1 objectForKey:@"measure_time"] longValue]];
        _labelCURValue.text = [NSString stringWithFormat:@"%0.1f",[[dict1 objectForKey:@"value"] doubleValue]];
        _labelCURDate.text = [ACDate dateDetailFomatdate2:date];
        //CHANGE
        if (v1 >= v2) {
            _labelChangeValue.text= [NSString stringWithFormat:@"↑%0.1f",v1-v2];
        }else{
            _labelChangeValue.text= [NSString stringWithFormat:@"↓%0.1f",v2-v1];
        }
    }
    else if ([arrValues count] == 1){
        //LAST
        _labelLastValue.text = @"-";
        _labelLastDate.text = @"尚无记录";
        //CURRENT
        NSDictionary *dict = [arrValues objectAtIndex:0];
        NSDate *date = [ACDate getDateFromTimeStamp:[[dict objectForKey:@"measure_time"] longValue]];
        _labelCURValue.text = [NSString stringWithFormat:@"%0.1f",[[dict objectForKey:@"value"] doubleValue]];
        NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
        _labelCURDate.text = [ACDate dateDetailFomatdate2:date];
        //CHANGE
        _labelChangeValue.text = @"-";
    }
    else{
        //LAST
        _labelLastValue.text = @"-";
        _labelLastDate.text = @"尚无记录";
        //CURRENT
        _labelCURValue.text = @"-";
        _labelCURDate.text = @"尚无记录";
        //CHANGE
        _labelChangeValue.text = @"-";
    }
    
    //加载CorePlot
    [self drawLine:CGRectMake(0, 0, self.view.bounds.size.width, plotHeight)];
    [_viewPlot addSubview:plot];
    
    UILabel *labelPoloTitle = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 80, 18)];
    labelPoloTitle.font = [UIFont fontWithName:@"Arial" size:SMALLTEXT];
    labelPoloTitle.textColor = [UIColor blackColor];
    labelPoloTitle.textAlignment = NSTextAlignmentCenter;
    labelPoloTitle.text = @"最近三日体温记录";
    [_viewPlot addSubview:labelPoloTitle];
}

-(void)setVar:(NSArray*) array{
    arrayCurrent = array;
    itemName = @"体温";
    itemUnit = @"°C";
    itemType = [[array objectAtIndex:0]intValue];
}

-(void)makeAdvise:(CGRect)rect
{
    
    AdviseScrollview *ad=[[AdviseScrollview alloc]initWithArray:[GetPhyAdvise getTemp]];
    
    adviseImageView = [[UIImageView alloc] init];
    [adviseImageView setFrame:rect];
    [adviseImageView setBackgroundColor:[ACFunction colorWithHexString:@"#f6f6f6"]];
    adviseImageView.userInteractionEnabled = YES;
    [adviseImageView addSubview:ad];
    [self.view addSubview:adviseImageView];
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIImageView *addIamge1;
    UIImageView *addIamge;
    UIImageView *cutline;
    if (DEVICE_IS_IPHONE5){
        addIamge1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-110+7 - 40 + 20  , 130/2.0, 256/2.0)];
        addIamge = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-100/2.0, frame.size.height-102/2.0 -40 + 20, 171/2.0, 102/2.0)];
        cutline = [[UIImageView alloc]initWithFrame:CGRectMake(0, WINDOWSCREEN-110-40 + 20, 320, 10)];
    }else{
        addIamge = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-100/2.0, frame.size.height-102/2.0 - 20, 171/2.0, 102/2.0)];
        addIamge1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-110+7 - 20, 130/2.0, 256/2.0)];
        cutline = [[UIImageView alloc]initWithFrame:CGRectMake(0, WINDOWSCREEN-110- 20, 320, 10)];
    }
    [cutline setImage:[UIImage imageNamed:@"分界线"]];
    [addIamge1 setImage:[UIImage imageNamed:@"长颈鹿"]];
    [self.view addSubview:addIamge1];
    [addIamge setImage:[UIImage imageNamed:@"大象"]];
    [self.view addSubview:addIamge];
    [self.view addSubview:cutline];
}

-(void)drawLine:(CGRect)rect{
    //********Start********@[
    NSArray *userData = [[BabyDataDB babyinfoDB] selectBabyTempList:itemType Days:3];
    NSMutableArray *proUserDate = [[NSMutableArray alloc]init];
    int day;
    for (int i = 0; i<[userData count];i++){
        NSDictionary *dict = [userData objectAtIndex:i];
        NSDate *date = [ACDate getDateFromTimeStamp:[[dict objectForKey:@"measure_time"] longValue]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
        NSString *strDate;
        int hour = [comps hour];
        int min = [comps minute];
        if (day != [comps day]){
            day = [comps day];
            strDate = [NSString stringWithFormat:@"%d-%d:%d",day,hour,min];
        }
        else{
            strDate = [NSString stringWithFormat:@"%d:%d",hour,min];
        }
        
        NSArray *arr = [[NSArray alloc]initWithObjects:[NSNumber numberWithInt:i],strDate,[dict objectForKey:@"value"],nil];
        [proUserDate addObject:arr];
    }
    
    plot = [[TempCorePlot alloc]initWithFrame:rect XasixAndValue:proUserDate];
}

-(void)ShowHistory{
    if ([arrValues count] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"暂无数据" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    PHYHistoryViewController *pHYHistoryViewController=[[PHYHistoryViewController alloc] init];
    [pHYHistoryViewController setType:[[arrayCurrent objectAtIndex:0]intValue]];
    [self.navigationController pushViewController:pHYHistoryViewController animated:YES];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)AddRecord{
    if (tempSaveView==nil) {
        tempSaveView = [[TempSaveView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 50, self.view.frame.size.width, self.view.frame.size.height-64) Type:@"SAVE" CreateTime:0];
        tempSaveView.TempSaveDelegate = self;
    }
    [self.view addSubview:tempSaveView];
}

#pragma saveview delegate
-(void)sendTempReloadData{
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
