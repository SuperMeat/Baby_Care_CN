//
//  PHYDetailViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-24.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "PHYDetailViewController.h"
#import "BabyDataDB.h"
#import "WhoDataBase.h"
#import "PHYHistoryViewController.h"

#define YAXISCOUNT 5
#define SIZEINTERVA 10

@interface PHYDetailViewController ()

@end

@implementation PHYDetailViewController

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

-(void)viewWillAppear:(BOOL)animated{
    [MobClick beginLogPageView:@"生理详细页"];
    self.hidesBottomBarWhenPushed=YES;
    [self initData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"生理详细页"];
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
    _buttonBack.frame = CGRectMake(10, 22, 40, 40);
    _buttonBack.titleLabel.font = [UIFont systemFontOfSize:16];
    [_buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [_buttonBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_phyDetailImageView addSubview:_buttonBack];
    
    _buttonAdd = [[UIButton alloc] init];
    _buttonAdd.frame = CGRectMake(320-10-40,22, 40, 40);
    _buttonAdd.titleLabel.font = [UIFont systemFontOfSize:20];
    [_buttonAdd setTitle:@"+" forState:UIControlStateNormal];
    [_buttonAdd addTarget:self action:@selector(AddRecord) forControlEvents:UIControlEventTouchUpInside];
    [_phyDetailImageView addSubview:_buttonAdd];
    
    _buttonTip = [[UIButton alloc] init];
    _buttonTip.frame = CGRectMake(50, 22, 40, 40);
    _buttonTip.titleLabel.font = [UIFont systemFontOfSize:20];
    [_buttonTip setTitle:@"i" forState:UIControlStateNormal];

    [_phyDetailImageView addSubview:_buttonTip];
    
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
    
    _labelLastDate = [[UILabel alloc]initWithFrame:CGRectMake(10, 42, 80, 20)];
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
    
    _labelCURDate = [[UILabel alloc]initWithFrame:CGRectMake(135, 42, 80, 20)];
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
    
    //corePlot
    [self drawLine:CGRectMake(0, 175, self.view.bounds.size.width, 174)];
    [self.view addSubview:plot];
    
    //adviseView
    [self makeAdvise:CGRectMake(0, 480-130, 320, 130)];
}

-(void)initData{
    //_viewTop1
    NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyPhysiologyList:[[arrayCurrent objectAtIndex:0] intValue]];
    if ([arrValues count] >= 2) {
        NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
        [myDateFormatter setDateFormat:@"yyyy-MM-dd"];

        //LAST
        NSDictionary *dict2 = [arrValues objectAtIndex:1];
        double v2 = [[dict2 objectForKey:@"value"] doubleValue];
        NSDate *dateB = [ACDate getDateFromTimeStamp:[[dict2 objectForKey:@"measure_time"] longValue]];
        _labelLastValue.text = [NSString stringWithFormat:@"%0.1f",[[dict2 objectForKey:@"value"] doubleValue]];
                _labelLastDate.text = [myDateFormatter stringFromDate:dateB];
        
        //CURRENT
        NSDictionary *dict1 = [arrValues objectAtIndex:0];
        double v1 = [[dict1 objectForKey:@"value"] doubleValue];
        NSDate *date = [ACDate getDateFromTimeStamp:[[dict1 objectForKey:@"measure_time"] longValue]];
        _labelCURValue.text = [NSString stringWithFormat:@"%0.1f",[[dict1 objectForKey:@"value"] doubleValue]];
        _labelCURDate.text = [myDateFormatter stringFromDate:date];
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
        _labelCURDate.text = [myDateFormatter stringFromDate:date];
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
    
}

-(void)makeAdvise:(CGRect)rect
{
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"一、把宝宝叫醒\n\r到了喂奶时间，就要把宝宝叫醒。你应该让宝宝晚上能够一觉到天亮，而不是白天睡觉、晚上哭闹。我的做法是，喂奶时间快到时，就把宝宝的房门打开，进去把窗帘拉开，让宝宝慢慢醒过来。如果喂奶时间到了，宝宝还在睡觉，我会把宝宝抱起来，交给喜欢宝宝的人抱一抱，比如孩子的爸爸、爷爷、奶奶或其他亲友，请他们轻轻地叫醒宝宝。他们会轻声跟宝宝说话，亲亲他，或者帮他脱掉几件衣服，让宝宝慢慢地醒过来。",@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"二、喂奶要喂饱\n\r每次喂奶一定要喂饱。喂母乳时，每边各喂10～15分钟。我们常跟宝宝开玩笑说：“这不是吃点心哦。”尽量让宝宝在吃奶时保持清醒。如果宝宝还没吃饱就开始打瞌睡，可以搔搔他的脚底，蹭蹭他的脸颊，或把奶头拔开一段距离。尽量让宝宝吃饱，让他可以撑到下次喂奶的时间。",@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:@"三、努力遵循“喂奶—玩耍—睡觉”的循环模式\n\r白天，不要让宝宝一吃完奶就睡觉。如果你在喂完奶后跟宝宝玩一玩，他会很开心，因为他刚刚吃饱，觉得很满足。等宝宝玩累了再上床，就会睡得比较熟、比较久。下次喂奶时间一到，宝宝醒来时，刚好空腹准备吃奶。\n\r有很多人采用“喂奶—睡觉—玩耍”的循环模式。我认为这样的循环模式会让宝宝醒来时，肚子呈半饥饿状态，不能玩得很开心，宝宝可能还会觉得有点累，因为睡得不熟或时间比较短。宝宝醒来时如果处于半饥饿、半疲倦的状态，一定会哭闹得很厉害，这时妈妈就容易在宝宝尚未空腹的情况下提前喂奶，结果宝宝养成了整天都在吃点心的习惯，这是一个恶性循环。\n\r怎么跟宝宝玩呢?关键是动作一定要很轻。喂完奶，轻轻地帮宝宝拍背打嗝后，就可以跟宝宝说说话，唱歌给宝宝听，看着宝宝的眼睛，摆动宝宝的脚，或者抱着宝宝在家里走一走。我的孩子小的时候，我常让她们趴在毯子上，让她们看看家人在做什么。如果大家在吃饭，我就把宝宝放在饭桌旁(或饭桌上)，宝宝可以看大家吃饭，这时大家当然会忍不住一直看着宝宝，对他微笑，逗他开心。宝宝玩了一阵子之后，会觉得有点累，开始哭闹，这时我就把他放回床上睡觉，等到下次喂奶时间再抱起来。\n\r每天只有最后一次喂完奶(晚上10点或11点左右)，我不会遵循“喂奶—玩耍—睡觉”的模式。经过一整天的活动，宝宝这时已经累了，我会在喂奶之后，小心地帮他拍背打嗝，换上干净的尿布，然后就不再陪他玩了，直接送他上床睡觉。",@"content", nil];
    
    AdviseScrollview *ad=[[AdviseScrollview alloc]initWithArray:[NSArray arrayWithObjects:dict1,dict2,dict3, nil]];
    
    adviseImageView = [[UIImageView alloc] init];
    [adviseImageView setFrame:rect];
    [adviseImageView setBackgroundColor:[ACFunction colorWithHexString:@"#f6f6f6"]];
    adviseImageView.userInteractionEnabled = YES;
    [adviseImageView addSubview:ad];
    [self.view addSubview:adviseImageView];
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIImageView *addIamge1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-130+7, 130/2.0, 256/2.0)];
    [addIamge1 setImage:[UIImage imageNamed:@"长颈鹿"]];
    [self.view addSubview:addIamge1];
    
    UIImageView *addIamge = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-171/2.0, frame.size.height-102/2.0, 171/2.0, 102/2.0)];
    [addIamge setImage:[UIImage imageNamed:@"大象"]];
    [self.view addSubview:addIamge];

    UIImageView *cutline = [[UIImageView alloc]initWithFrame:CGRectMake(0, WINDOWSCREEN-130, 320, 10)];
    [cutline setImage:[UIImage imageNamed:@"分界线"]];
    [self.view addSubview:cutline];
}

-(void)drawLine:(CGRect)rect{
    //********Start********
    //Step-1:                           根据宝宝的出生天数得出X轴范围
    //Argument:postnatalDays            宝宝的出生天数
    //Method:                           xAsix = GetXAsix(postnatalDays)
    NSDictionary *dict = [[BabyDataDB babyinfoDB]selectBabyInfoByBabyId:BABYID];
    int postnatalDays = [self numberOfDaysFromTodayByTime:[[dict objectForKey:@"birth"] intValue]];
    
    NSArray *xAsix = [self GetXAsix:postnatalDays];
    
    //Step-2:根据X轴值获取WHO对应数值
    NSArray *dataP25 = [WhoDataBase getDataArrayByXposition:xAsix Condition:@"P25" TableName:@"boys"];
    NSArray *dataP75 = [WhoDataBase getDataArrayByXposition:xAsix Condition:@"P75" TableName:@"boys"];
    
    NSArray *dataUser = dataP25;
    
    //Step-3:根据WHO的对应值得出Y轴范围
    NSArray *yAsix = [self GetYAsixByBiger:dataP75 andSmaller:dataP25];
    
    //录入P25;P75;用户数值
    NSArray *xyPlot = @[dataP25,dataP75,dataUser];
    NSArray *xyTitle = @[@"",@"(分值)"];
    NSArray *axis = @[xAsix,yAsix];
    
    plot = [[PhyCorePlot alloc]initWithFrame:rect Title:@"" XYPlotRange:xyPlot XYTitle:xyTitle Axis:axis YBaseV:yBaseValue YSizeInterval:ySizeInterval];
}

-(void)ShowHistory{
    PHYHistoryViewController *pHYHistoryViewController=[[PHYHistoryViewController alloc] init];
    [pHYHistoryViewController setType:[[arrayCurrent objectAtIndex:0]intValue]];
    [self.navigationController pushViewController:pHYHistoryViewController animated:YES];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)AddRecord{
    addRecordViewController = [[AddPHYRecordViewController alloc] init];
    [addRecordViewController setType:[[arrayCurrent objectAtIndex:0]intValue]];
    [self.navigationController pushViewController:addRecordViewController animated:YES];
}

-(void)setVar:(NSArray*) array{
    arrayCurrent = array;
    
    switch ([[array objectAtIndex:0]intValue]) {
        case 0:
            itemName = @"身高";
            break;
        case 1:
            itemName = @"体重";
            break;
        case 2:
            itemName = @"BMI";
            break;
        case 3:
            itemName = @"头围";
            break;
        case 4:
            itemName = @"体温";
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfDaysFromTodayByTime:(int)birth
{
    NSDate *today = [NSDate date];
    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:localTimeZone];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    double dBirth = (double)birth;
    double dToday = [ACDate getTimeStampFromDate:today];
    NSInteger nSecs = (NSInteger)(dToday - dBirth);
    NSInteger oneDaySecs = 24*3600;
    return nSecs / oneDaySecs;
    
}

#pragma mark - 获取x轴坐标系
-(NSArray*)GetXAsix:(int)PostnatalDays
{
    int sizeInterval;
    
    NSMutableArray * arrXAsix = [[NSMutableArray alloc]initWithCapacity:0];
    if (PostnatalDays <= 30) {
        PostnatalDays = 30;
        sizeInterval = 30 / SIZEINTERVA;
        for (int i = 0; i <= PostnatalDays; i++) {
            if (i % sizeInterval == 0) {
                [arrXAsix addObject:[NSNumber numberWithInt:i]];
            }
        }
        return arrXAsix;
    }
    else if (PostnatalDays > 30 && PostnatalDays <=60){
        PostnatalDays=60;
        sizeInterval = 60 / SIZEINTERVA;
        for (int i = 0; i <= PostnatalDays; i++) {
            if (i % sizeInterval == 0) {
                [arrXAsix addObject:[NSNumber numberWithInt:i]];
            }
        }
        return arrXAsix;
    }
    else if (PostnatalDays> 60 && PostnatalDays <=90){
        PostnatalDays = 90;
        sizeInterval = 90 / SIZEINTERVA;
        for (int i = 0; i <= PostnatalDays; i++) {
            if (i % sizeInterval == 0) {
                [arrXAsix addObject:[NSNumber numberWithInt:i]];
            }
        }
        return arrXAsix;
    }
    else{
        sizeInterval = 90 / SIZEINTERVA;
        while (PostnatalDays % sizeInterval != 0)
        {
            PostnatalDays++;
        }
        
        for (int i = (PostnatalDays - 90); i <= PostnatalDays; i++) {
            if (i % sizeInterval == 0) {
                [arrXAsix addObject:[NSNumber numberWithInt:i]];
            }
        }
        return arrXAsix;
    }
}

#pragma mark - 获取y轴坐标系
-(NSArray*)GetYAsixByBiger:(NSArray*)Barr andSmaller:(NSArray*)Sarr
{
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSMutableArray * arrYAsix = [[NSMutableArray alloc]initWithCapacity:0];
    NSArray *Bsort = [Barr sortedArrayUsingComparator:cmptr];
    NSArray *Ssort = [Sarr sortedArrayUsingComparator:cmptr];
    float max = [[NSNumber numberWithFloat:[[NSString stringWithFormat:@"%.1f",[[Bsort lastObject]floatValue]] floatValue]] floatValue];
    float min = [[NSNumber numberWithFloat:[[NSString stringWithFormat:@"%.1f",[[Ssort firstObject]floatValue]] floatValue]] floatValue];
    
    yBaseValue = min;
    ySizeInterval = [[NSNumber numberWithFloat:[[NSString stringWithFormat:@"%.1f",(max - min) / (YAXISCOUNT-1)] floatValue]] floatValue];
    
    [arrYAsix addObject:[NSNumber numberWithFloat:0.0f]];
    
    //确保最大值在区间内
    max += ySizeInterval;
    for (float i = min; i < max; i=i+ySizeInterval) {
        [arrYAsix addObject:[NSNumber numberWithFloat:i]];
    }
    return arrYAsix;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
