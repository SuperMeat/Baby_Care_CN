//
//  SleepActivityViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-4-9.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "SleepActivityViewController.h"

@interface SleepActivityViewController ()

@end

@implementation SleepActivityViewController
@synthesize summary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init
{
    self=[super init];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"睡觉"];
    self.hidesBottomBarWhenPushed = YES;
    [self makeNav];
    if (startButton != nil) {
        startButton.enabled = YES;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"ctl"] isEqualToString:@"sleep"]) {
        labletip.text = NSLocalizedString(@"Counting", nil);
        startButton.selected=YES;
        
        addRecordBtn.enabled = NO;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOnBefore"]) {
            
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOnBefore"];
        }
        
    }
    else
    {
        labletip.text = NSLocalizedString(@"Wait", nil);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop:) name:@"stop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel) name:@"cancel" object:nil];
    
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
    NSString *str = [db objectForKey:@"MARK"];
    if (![str isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    str = @"0";
    [db setObject:str forKey:@"MARK"];
    [db synchronize];
    [self loadData];
    if (ad)
    {
        [ad removeFromSuperview];
        [self makeAdvise];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"睡觉"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"addsleepnow"]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addsleepnow"];
    }
    [saveView removeFromSuperview];
}

+(id)shareViewController
{
    
    static dispatch_once_t pred = 0;
    __strong static SleepActivityViewController* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(void)makeNav
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110 , 100, 20)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:NSLocalizedString(@"Sleep", nil)];
    [titleView addSubview:titleText];
    
    self.navigationItem.titleView = titleView;
    
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    backbutton.frame=CGRectMake(0, 0, 50, 41);
    backbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [backbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"btn_sum1"] forState:UIControlStateNormal];
    rightButton.frame=CGRectMake(0, 0, 51, 51);
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -40);
    [rightButton addTarget:self action:@selector(pushSummaryView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

- (void)pushSummaryView:(id)sender{
    summary = [SummaryViewController summary];
    [summary MenuSelectIndex:3];
    [self.navigationController pushViewController:summary animated:YES];
}


-(void)makeAdvise
{
    NSArray *adviseArray = [[UserLittleTips dataBase]selectLittleTipsByAge:[BaseMethod getbabyagefrommonth] andCondition:QCM_TYPE_SLEEP];
    
    ad=[[AdviseScrollview alloc]initWithArray:adviseArray];
    
    adviseImageView = [[UIImageView alloc] init];
    [adviseImageView setFrame:CGRectMake(0, WINDOWSCREEN-130, 320, 130)];
    [adviseImageView setBackgroundColor:[ACFunction colorWithHexString:@"#f6f6f6"]];
    adviseImageView.userInteractionEnabled = YES;
    [adviseImageView addSubview:ad];
    [self.view addSubview:adviseImageView];
    CGRect frame = [[UIScreen mainScreen] bounds];
    UIImageView *addIamge1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-130+17, 198/2.0, 190/2.0)];
    [addIamge1 setImage:[UIImage imageNamed:@"婴儿车"]];
    [self.view addSubview:addIamge1];

    UIImageView *addIamge = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-153/2.0, frame.size.height-114/2.0, 153/2.0, 114/2.0)];
    [addIamge setImage:[UIImage imageNamed:@"奶嘴"]];
    [self.view addSubview:addIamge];

    UIImageView *cutline = [[UIImageView alloc]initWithFrame:CGRectMake(0, WINDOWSCREEN-130, 320, 10)];
    [cutline setImage:[UIImage imageNamed:@"分界线"]];
    [self.view addSubview:cutline];
}

-(void)makeView
{
    UIImageView *backIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [backIV setImage:[UIImage imageNamed:@"pattern1"]];
    [self.view addSubview:backIV];
    
    historyView = [[UIImageView alloc] initWithFrame:CGRectMake((320-310*PNGSCALE)/2.0, 105*PNGSCALE, 310*PNGSCALE, 100*PNGSCALE)];
    [historyView.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    historyView.layer.cornerRadius = 8.0f;
    [historyView setImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:historyView];
    
    UILabel *weeklabel = [[UILabel alloc]init];
    weeklabel.frame = CGRectMake(5, 5, 100, 16.5);
    weeklabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    weeklabel.text  = @"周日均(分钟)";
    weeklabel.textAlignment = NSTextAlignmentLeft;
    weeklabel.font = [UIFont systemFontOfSize:16.5];
    [historyView addSubview:weeklabel];
    
    UILabel *monthlabel = [[UILabel alloc]init];
    monthlabel.frame = CGRectMake(historyView.frame.size.width/2.0+5, 5, 100, 16.5);
    monthlabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    monthlabel.text  = @"月日均(分钟)";
    monthlabel.font = [UIFont systemFontOfSize:16.5];
    monthlabel.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:monthlabel];
    
    averagesleepweeklabel = [[UILabel alloc]init];
    [historyView addSubview:averagesleepweeklabel];
    averagesleepweeklabel.frame = CGRectMake(5, 5+16.5+10, 50, 15);
    averagesleepweeklabel.text = @"总时:";
    averagesleepweeklabel.font = [UIFont systemFontOfSize:15];
    averagesleepweeklabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    averagesleepweeklabel.textAlignment = NSTextAlignmentLeft;
    
    averagesleepweekamount = [[UILabel alloc] init];
    averagesleepweekamount.frame = CGRectMake(5+50, 5+16.5+10, 40, MIDTEXT);
    averagesleepweekamount.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    averagesleepweekamount.font = [UIFont systemFontOfSize:MIDTEXT];
    averagesleepweekamount.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:averagesleepweekamount];
    
    averagesleepweekstatusImageView = [[UIImageView alloc] init];
    averagesleepweekstatusImageView.frame = CGRectMake(5+50+40, 5+16.5+10, 18/2.0, 21/2.0);
    [historyView addSubview:averagesleepweekstatusImageView];
    cutaveragesleepweek = [[UILabel alloc]init];
    cutaveragesleepweek.frame = CGRectMake(5+50+40+18/2.0, 5+16.5+10, 40, 10);
    cutaveragesleepweek.textAlignment = NSTextAlignmentLeft;
    cutaveragesleepweek.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    cutaveragesleepweek.font = [UIFont systemFontOfSize:SMALLTEXT];
    [historyView addSubview:cutaveragesleepweek];
    
    averagesleepmonthlabel  = [[UILabel alloc]init];
    [historyView addSubview:averagesleepmonthlabel];
    averagesleepmonthlabel.frame = CGRectMake(historyView.frame.size.width/2.0  + 5, 5+16.5+10, 50, 15);
    averagesleepmonthlabel.text = @"总时:";
    averagesleepmonthlabel.font = [UIFont systemFontOfSize:MIDTEXT];
    averagesleepmonthlabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    averagesleepmonthlabel.textAlignment = NSTextAlignmentLeft;
    
    averagesleepmonthamount = [[UILabel alloc]init];
    [historyView addSubview:averagesleepmonthamount];
    averagesleepmonthamount.frame = CGRectMake(historyView.frame.size.width/2.0  + 5+50, 5+16.5+10, 40, MIDTEXT);
    averagesleepmonthamount.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    averagesleepmonthamount.font = [UIFont systemFontOfSize:MIDTEXT];
    averagesleepmonthamount.textAlignment = NSTextAlignmentLeft;
    
    averagesleepmonthstatusImageView = [[UIImageView alloc] init];
    [historyView addSubview:averagesleepmonthstatusImageView];
    averagesleepmonthstatusImageView.frame = CGRectMake(historyView.frame.size.width/2.0  + 5+50+40, 5+16.5+10, 18/2.0, 21/2.0);
    cutaveragesleepmonth = [[UILabel alloc]init];
    cutaveragesleepmonth.frame = CGRectMake(historyView.frame.size.width/2.0+5+50+40+18/2.0, 5+16.5+10, 40, 10);
    cutaveragesleepmonth.textAlignment = NSTextAlignmentLeft;
    cutaveragesleepmonth.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    cutaveragesleepmonth.font = [UIFont systemFontOfSize:SMALLTEXT];
    [historyView addSubview:cutaveragesleepmonth];
    
    maxsleepweeklabel  = [[UILabel alloc]init];
    [historyView addSubview:maxsleepweeklabel];
    maxsleepweeklabel.frame = CGRectMake(5, 5+16.5+10+15+10, 50, 15);
    maxsleepweeklabel.text = @"最长:";
    maxsleepweeklabel.font = [UIFont systemFontOfSize:MIDTEXT];
    maxsleepweeklabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    maxsleepweeklabel.textAlignment = NSTextAlignmentLeft;
    
    maxsleepweekamount = [[UILabel alloc] init];
    [historyView addSubview:maxsleepweekamount];
    maxsleepweekamount.frame = CGRectMake(5+50, 5+16.5+10+15+10, 40, MIDTEXT);
    maxsleepweekamount.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    maxsleepweekamount.font = [UIFont systemFontOfSize:MIDTEXT];
    maxsleepweekamount.textAlignment = NSTextAlignmentLeft;
    
    maxsleepweekstatusImageView = [[UIImageView alloc] init];
    [historyView addSubview:maxsleepweekstatusImageView];
    maxsleepweekstatusImageView.frame = CGRectMake(5+50+40, 5+16.5+10+15+10, 18/2.0, 21/2.0);
    cutmaxsleepweek = [[UILabel alloc]init];
    [historyView addSubview:cutmaxsleepweek];
    cutmaxsleepweek.frame = CGRectMake(5+50+40+18/2.0, 5+16.5+10+15+10, 40, 10);
    cutmaxsleepweek.textAlignment = NSTextAlignmentLeft;
    cutmaxsleepweek.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    cutmaxsleepweek.font = [UIFont systemFontOfSize:SMALLTEXT];
    
    maxsleepmonthlabel = [[UILabel alloc]init];
    [historyView addSubview:maxsleepmonthlabel];
    maxsleepmonthlabel.frame = CGRectMake(historyView.frame.size.width/2.0 + 5, 5+16.5+10+15+10, 90, 15);
    maxsleepmonthlabel.text = @"最长:";
    maxsleepmonthlabel.font = [UIFont systemFontOfSize:MIDTEXT];
    maxsleepmonthlabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    maxsleepmonthlabel.textAlignment = NSTextAlignmentLeft;
    
    maxsleepmonthamount = [[UILabel alloc] init];
    [historyView addSubview:maxsleepmonthamount];
    maxsleepmonthamount.frame = CGRectMake(historyView.frame.size.width/2.0+5+50, 5+16.5+10+15+10, 40, MIDTEXT);
    maxsleepmonthamount.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    maxsleepmonthamount.font = [UIFont systemFontOfSize:MIDTEXT];
    maxsleepmonthamount.textAlignment = NSTextAlignmentLeft;
    
    maxsleepmonthstatusImageView = [[UIImageView alloc] init];
    [historyView addSubview:maxsleepmonthstatusImageView];
    maxsleepmonthstatusImageView.frame = CGRectMake(historyView.frame.size.width/2.0+5+50+40, 5+16.5+10+15+10, 18/2.0, 21/2.0);
    
    cutmaxsleepmonth = [[UILabel alloc]init];
    [historyView addSubview:cutmaxsleepmonth];
    cutmaxsleepmonth.frame = CGRectMake(historyView.frame.size.width/2.0+5+50+40+18/2.0, 5+16.5+10+15+10, 40, 10);
    cutmaxsleepmonth.textAlignment = NSTextAlignmentLeft;
    cutmaxsleepmonth.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    cutmaxsleepmonth.font = [UIFont systemFontOfSize:SMALLTEXT];

    startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame=CGRectMake(10,200*PNGSCALE+30, 281*PNGSCALE/2.0, 231*PNGSCALE/2.0);
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_sleeping_play.png"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_sleeping_pause.png"] forState:UIControlStateSelected];
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    timerImage = [[UIImageView alloc]initWithFrame:CGRectMake(320-165*PNGSCALE, 200, 165*PNGSCALE, 111*PNGSCALE)];
    [timerImage setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:timerImage];
    
    UIImageView *timeicon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 41/2.0*PNGSCALE, 48/2.0*PNGSCALE)];
    
    timeicon.contentMode=UIViewContentModeScaleAspectFit;
    timeicon.image=[UIImage imageNamed:@"icon_timer"];
    [timerImage addSubview:timeicon];
    
    labletip=[[UILabel alloc]initWithFrame:CGRectMake(2+21*PNGSCALE, 15*PNGSCALE, 140*PNGSCALE, 40*PNGSCALE)];
    labletip.text = NSLocalizedString(@"Wait", nil);
    labletip.font = [UIFont fontWithName:@"Arial" size:15];
    labletip.numberOfLines=0;
    labletip.textAlignment=NSTextAlignmentCenter;
    labletip.lineBreakMode=NSLineBreakByWordWrapping;
    labletip.textColor=[UIColor grayColor];
    labletip.backgroundColor=[UIColor clearColor];
    [timerImage addSubview:labletip];
    
    timerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(18*PNGSCALE, (13+10+40)*PNGSCALE, 129*PNGSCALE, 46.5*PNGSCALE)];
    [timerImageView setImage:[UIImage imageNamed:@"input_timer"]];
    [timerImage addSubview:timerImageView];
    
    timeLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 129*PNGSCALE, 46.5*PNGSCALE)];
    timeLable.font=[UIFont systemFontOfSize:32*PNGSCALE];
    timeLable.textAlignment = NSTextAlignmentCenter;
    timeLable.text=@"00:00:00";
    timeLable.textColor=[ACFunction colorWithHexString:@"#757371"];
    timeLable.backgroundColor=[UIColor clearColor];
    [timerImageView addSubview:timeLable];
    
    addRecordBtn = [[UIButton alloc]initWithFrame:CGRectMake(110, 370*PNGSCALE, 100, 28)];
    [addRecordBtn setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    [addRecordBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addRecordBtn setAlpha:1];
    [addRecordBtn setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
    [addRecordBtn addTarget:self action:@selector(addrecord:) forControlEvents:UIControlEventTouchUpInside];
    addRecordBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:addRecordBtn];
    
}

- (void)loadData
{
    NSDictionary *curStatusList = [[SummaryDB dataBase]searchCurSleepStatusList];
    NSDictionary *lastStatusList = [[SummaryDB dataBase] searchLastSleepStatusList];
    if (curStatusList != nil && lastStatusList != nil && [curStatusList count]>0)
    {
        int week_sleep_average  = 0;
        int week_max_sleep_average    = 0;
        int month_sleep_average = 0;
        int month_max_sleep_average   = 0;
        
        if ([curStatusList objectForKey:@"week_sleep_average"]) {
            week_sleep_average = [[curStatusList objectForKey:@"week_sleep_average"]intValue];
        }
        
        if ([curStatusList objectForKey:@"week_max_sleep_average"]) {
            week_max_sleep_average = [[curStatusList objectForKey:@"week_max_sleep_average"]intValue];
        }
        
        if ([curStatusList objectForKey:@"month_sleep_average"]) {
            month_sleep_average = [[curStatusList objectForKey:@"month_sleep_average"]intValue];
        }
        
        if ([curStatusList objectForKey:@"month_sleep_average"]) {
            month_max_sleep_average = [[curStatusList objectForKey:@"month_max_sleep_average"]intValue];
        }
        
        int last_week_sleep_average   = 0;
        int last_week_max_average    = 0;
        int last_month_sleep_average = 0;
        int last_month_max_average   = 0;
        
        if ([lastStatusList count]>0)
        {
            if ([lastStatusList objectForKey:@"week_sleep_average"])
            {
                last_week_sleep_average = [[lastStatusList objectForKey:@"week_sleep_average"]intValue];
            }
            
            if ([lastStatusList objectForKey:@"week_max_sleep_average"])
            {
                last_week_max_average = [[lastStatusList objectForKey:@"week_max_sleep_average"]intValue];
            }
            
            if ([lastStatusList objectForKey:@"month_sleep_average"])
            {
                last_month_sleep_average = [[lastStatusList objectForKey:@"month_sleep_average"]intValue];
            }
            
            if ([lastStatusList objectForKey:@"month_max_sleep_average"])
            {
                last_month_max_average = [[lastStatusList objectForKey:@"month_max_sleep_average"]intValue];
            }
            
            averagesleepweekamount.text = [NSString stringWithFormat:@"%d", week_sleep_average/60];
            averagesleepmonthamount.text = [NSString stringWithFormat:@"%d",month_sleep_average/60];
            maxsleepweekamount.text = [NSString stringWithFormat:@"%d", week_max_sleep_average/60];
            maxsleepmonthamount.text = [NSString stringWithFormat:@"%d",month_max_sleep_average/60];
            
            if (week_sleep_average > last_week_sleep_average)
            {
                [averagesleepweekstatusImageView setImage:[UIImage imageNamed:@"arrow_up"]];
                cutaveragesleepweek.text = [NSString stringWithFormat:@"%d",(week_sleep_average-last_week_sleep_average)/60];
                
            }
            else if (week_sleep_average == last_week_sleep_average)
            {
                [averagesleepweekstatusImageView setImage:[UIImage imageNamed:@"arrow_flat"]];
            }
            else
            {
                [averagesleepweekstatusImageView setImage:[UIImage imageNamed:@"arrow_down"]];
                cutaveragesleepweek.text = [NSString stringWithFormat:@"%d",(last_week_sleep_average-week_sleep_average)/60];
            }
            
            if (week_max_sleep_average > last_week_max_average)
            {
                [maxsleepweekstatusImageView setImage:[UIImage imageNamed:@"arrow_up"]];
                cutmaxsleepweek.text = [NSString stringWithFormat:@"%d",(week_max_sleep_average-last_week_max_average)/60];
            }
            else if (week_max_sleep_average == last_week_max_average)
            {
                [maxsleepweekstatusImageView setImage:[UIImage imageNamed:@"arrow_flat"]];
            }
            else
            {
                [maxsleepweekstatusImageView setImage:[UIImage imageNamed:@"arrow_down"]];
                cutmaxsleepweek.text = [NSString stringWithFormat:@"%d",(last_week_max_average-week_max_sleep_average)/60];
            }
            
            if (month_sleep_average > last_month_sleep_average)
            {
                [averagesleepmonthstatusImageView setImage:[UIImage imageNamed:@"arrow_up"]];
                cutaveragesleepmonth.text = [NSString stringWithFormat:@"%d",(month_sleep_average-last_month_sleep_average)/60];
            }
            else if (month_sleep_average == last_month_sleep_average)
            {
                [averagesleepmonthstatusImageView setImage:[UIImage imageNamed:@"arrow_flat"]];
            }
            else
            {
                [averagesleepmonthstatusImageView setImage:[UIImage imageNamed:@"arrow_down"]];
                cutaveragesleepmonth.text = [NSString stringWithFormat:@"%d",(last_month_sleep_average-month_sleep_average)/60];
            }
            
            if (month_max_sleep_average > last_month_max_average)
            {
                [maxsleepmonthstatusImageView setImage:[UIImage imageNamed:@"arrow_up"]];
                cutmaxsleepmonth.text = [NSString stringWithFormat:@"%d",(month_max_sleep_average-last_month_max_average)/60];
            }
            else if (month_max_sleep_average == last_month_max_average)
            {
                [maxsleepmonthstatusImageView setImage:[UIImage imageNamed:@"arrow_flat"]];
            }
            else
            {
                [maxsleepmonthstatusImageView setImage:[UIImage imageNamed:@"arrow_down"]];
                cutmaxsleepmonth.text = [NSString stringWithFormat:@"%d",(last_month_max_average-month_max_sleep_average)/60];
            }
            
        }
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeView];
    [self makeAdvise];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startOrPause:(UIButton*)sender
{
    
    if (!sender.selected) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TimerTipsTile", nil) message:NSLocalizedString(@"TimerMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil, nil];
            
            [alert show];
            return;
        }
        labletip.text = NSLocalizedString(@"Counting", nil);
        sender.selected=YES;
        [[NSUserDefaults standardUserDefaults] setObject:[ACDate date] forKey:@"timerOn"];
        [[NSUserDefaults standardUserDefaults] setObject:@"sleep" forKey:@"ctl"];
        timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];    }
    else{
        
        [self makeSave];
        
    }
    
    addRecordBtn.enabled = NO;
}



-(void)timerGo
{
    timeLable.text=[ACDate durationFormat];
    if ([timeLable.text isEqualToString:@"00:00:00"]) {
        [self stop];
    }
    else
    {
        NSArray *arr=[timeLable.text componentsSeparatedByString:@":"];
        if ([[arr objectAtIndex:0]intValue]==24) {
            
            [self makeSave];
            [saveView Save];
        }
    }
}

-(void)makeSave
{
    
    if (saveView==nil) {
        saveView=[[save_sleepview alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height)];
    }
    [saveView loaddata];
    startButton.enabled = NO;
    [self.view addSubview:saveView];
    
}
-(void)stop:(NSNotification*)noti
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addsleepnow"];
    [timer invalidate];
    timeLable.text=@"00:00:00";
    startButton.selected=NO;
    [saveView removeFromSuperview];
    NSNumber *dur=noti.object;
    labletip.text=[NSString stringWithFormat:NSLocalizedString(@"Over", nil),[dur floatValue]/3600];
    startButton.enabled = YES;
    addRecordBtn.enabled = YES;
}

-(void)stop
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
    [timer invalidate];
    timeLable.text=@"00:00:00";
    startButton.selected=NO;
    startButton.enabled = YES;
    addRecordBtn.enabled = YES;
}

-(void)cancel
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"addsleepnow"]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addsleepnow"];
    }
    
    startButton.enabled = YES;
    // [saveView removeFromSuperview];
    
}

-(IBAction)addrecord:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addsleepnow"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[ACDate date] forKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] setObject:@"sleep" forKey:@"ctl"];
    
    [self makeSave];
}

#pragma -mark sleep delegate
-(void)sendSleepSaveChanged:(int)duration andstarttime:(NSDate*)newstarttime
{
    
}

-(void)sendSleepReloadData
{
    [self loadData];
}
@end
