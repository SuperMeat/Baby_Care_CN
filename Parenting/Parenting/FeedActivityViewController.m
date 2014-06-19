//
//  FeedActivityViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-4-7.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "FeedActivityViewController.h"

@interface FeedActivityViewController ()

@end

@implementation FeedActivityViewController
@synthesize activity,feedWay,summary,obj;
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

+(id)shareViewController
{
    static dispatch_once_t pred = 0;
    __strong static FeedActivityViewController* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"喂食"];
    self.hidesBottomBarWhenPushed=YES;
    
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];
    NSString *str = [db objectForKey:@"MARK"];
    if (![str isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    str = @"0";
    [db setObject:str forKey:@"MARK"];
    [db synchronize];

    [self makeNav];
    adviseImageView.userInteractionEnabled = YES;
    
    if (startButton != nil) {
        startButton.enabled = YES;
    }
    
    if (startButtonleft != nil) {
        startButtonleft.enabled = YES;
    }
    
    if (startButtonright != nil) {
        startButtonright.enabled = YES;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop:) name:@"stop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel:) name:@"cancel" object:nil];

    UIButton *br=(UIButton*)[self.view viewWithTag:101];
    UIButton *bo=(UIButton*)[self.view viewWithTag:102];
    self.obj=@"self";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"breast"]) {
        
        [self feedWay:br];
    }
    else
    {
        [self feedWay:bo];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"ctl"] isEqualToString:@"feed"]) {
        addRecordBtn.enabled = NO;
        labletip.text = NSLocalizedString(@"Counting", nil);
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"breast"]) {
            NSString *s=[[NSUserDefaults standardUserDefaults] objectForKey:@"breast"];
            if ([s isEqualToString:@"left"]) {
                startButtonleft.selected=YES;
            }
            else
            {
                startButtonright.selected=YES;
            }
        }
        else
        {
            startButton.selected=YES;
        }
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOnBefore"]) {
            
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOnBefore"];
        }
        
    }
    else
    {
        labletip.text = NSLocalizedString(@"Wait", nil);
    }

    [self loadData];
    if (ad) {
        [ad removeFromSuperview];
        [self makeAdvise];
    }
}

-(void)stop
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
    NSLog(@"%@",timer);
    [timer invalidate];
    timer = nil;
    timeLable.text=@"00:00:00";
    startButton.selected=NO;
    startButton.enabled = YES;
    startButtonright.enabled = YES;
    startButtonleft.enabled = YES;
    adviseImageView.userInteractionEnabled = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"喂食"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"addfeednow"]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addfeednow"];
    }
    [saveView removeFromSuperview];
}

-(void)makeAdvise
{
    NSArray *adviseArray = [[UserLittleTips dataBase]selectLittleTipsByAge:1 andCondition:QCM_TYPE_FEED];
    
    ad=[[AdviseScrollview alloc]initWithArray:adviseArray];
    
    adviseImageView = [[UIImageView alloc] init];
    [adviseImageView setFrame:CGRectMake(0, WINDOWSCREEN-130, 320, 130)];
    [adviseImageView setBackgroundColor:[ACFunction colorWithHexString:@"#e7e7e7"]];
    adviseImageView.userInteractionEnabled = YES;
    [adviseImageView addSubview:ad];
    [self.view addSubview:adviseImageView];
}

-(void)makeNav
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:NSLocalizedString(@"Feed", nil)];
    [titleView addSubview:titleText];
    
    self.navigationItem.titleView = titleView;
    
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 28)];
    title.backgroundColor = [UIColor clearColor];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.text =NSLocalizedString(@"navback", nil);
    title.font = [UIFont systemFontOfSize:14];
    [backbutton addSubview:title];
      
    [backbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame=CGRectMake(0, 0, 44, 28);
    
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 28)];
    title1.backgroundColor = [UIColor clearColor];
    [title1 setTextAlignment:NSTextAlignmentCenter];
    title1.textColor = [UIColor whiteColor];
    title1.text = NSLocalizedString(@"navsummary", nil);
    title1.font = [UIFont systemFontOfSize:14];
    [rightButton addSubview:title1];
    
    
    [rightButton addTarget:self action:@selector(pushSummaryView:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame=CGRectMake(0, 0, 44, 28);
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)makeView
{
    chooseBreast=[UIButton buttonWithType:UIButtonTypeCustom];
    chooseBottle=[UIButton buttonWithType:UIButtonTypeCustom];
    chooseBreast.frame=CGRectMake(140*PNGSCALE+40, 90*PNGSCALE, 140*PNGSCALE, 25*PNGSCALE);
    chooseBottle.frame=CGRectMake(40, 90*PNGSCALE, 140*PNGSCALE, 25*PNGSCALE);
    [chooseBreast setBackgroundImage:[UIImage imageNamed:@"label_breast"] forState:UIControlStateNormal];
    [chooseBreast setBackgroundImage:[UIImage imageNamed:@"label_breast_choose"] forState:UIControlStateDisabled];
    chooseBreast.tag=101;
    chooseBreast.highlighted=NO;
    [chooseBreast addTarget:self action:@selector(feedWay:) forControlEvents:UIControlEventTouchUpInside];
    
    [chooseBottle setBackgroundImage:[UIImage imageNamed:@"label_bottle"] forState:UIControlStateNormal];
    [chooseBottle setBackgroundImage:[UIImage imageNamed:@"label_bottle_choose"] forState:UIControlStateDisabled];
    
    chooseBottle.tag=102;
    chooseBottle.highlighted=NO;
    [chooseBottle addTarget:self action:@selector(feedWay:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:chooseBreast];
    [self.view addSubview:chooseBottle];
    
    historyView = [[UIImageView alloc] initWithFrame:CGRectMake((320-310*PNGSCALE)/2.0, 90*PNGSCALE+20*PNGSCALE+10, 310*PNGSCALE, 100*PNGSCALE)];
    [historyView.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    historyView.layer.cornerRadius = 8.0f;
    [historyView setImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:historyView];
    
    UILabel *weeklabel = [[UILabel alloc]init];
    weeklabel.frame = CGRectMake(5, 5, 80, 16.5);
    weeklabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    weeklabel.text  = @"周日均(ml)";
    weeklabel.textAlignment = NSTextAlignmentLeft;
    weeklabel.font = [UIFont systemFontOfSize:16.5];
    [historyView addSubview:weeklabel];
    
    UILabel *monthlabel = [[UILabel alloc]init];
    monthlabel.frame = CGRectMake(historyView.frame.size.width/2.0+5, 5, 80, 16.5);
    monthlabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    monthlabel.text  = @"月日均(ml)";
    monthlabel.font = [UIFont systemFontOfSize:16.5];
    monthlabel.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:monthlabel];
    
    breastweeklabel = [[UILabel alloc]init];
    [historyView addSubview:breastweeklabel];
    breastweeklabel.frame = CGRectMake(5, 5+16.5+10, 50, 15);
    breastweeklabel.text = @"母乳:";
    breastweeklabel.font = [UIFont systemFontOfSize:15];
    breastweeklabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    breastweeklabel.textAlignment = NSTextAlignmentLeft;
    
    breastweekamount = [[UILabel alloc] init];
    breastweekamount.frame = CGRectMake(5+50, 5+16.5+10, 40, MIDTEXT);
    breastweekamount.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    breastweekamount.font = [UIFont systemFontOfSize:MIDTEXT];
    breastweekamount.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:breastweekamount];
    
    breastweekstatusImageView = [[UIImageView alloc] init];
    breastweekstatusImageView.frame = CGRectMake(5+50+40, 5+16.5+10, 18/2.0, 21/2.0);
    [historyView addSubview:breastweekstatusImageView];
    cutbreastweek = [[UILabel alloc]init];
    cutbreastweek.frame = CGRectMake(5+50+40+18/2.0, 5+16.5+10, 40, 10);
    cutbreastweek.textAlignment = NSTextAlignmentLeft;
    cutbreastweek.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    cutbreastweek.font = [UIFont systemFontOfSize:SMALLTEXT];
    [historyView addSubview:cutbreastweek];
    
    breastmonthlabel  = [[UILabel alloc]init];
    [historyView addSubview:breastmonthlabel];
    breastmonthlabel.frame = CGRectMake(historyView.frame.size.width/2.0  + 5, 5+16.5+10, 50, 15);
    breastmonthlabel.text = @"母乳:";
    breastmonthlabel.font = [UIFont systemFontOfSize:MIDTEXT];
    breastmonthlabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    breastmonthlabel.textAlignment = NSTextAlignmentLeft;

    breastmonthamount = [[UILabel alloc]init];
    [historyView addSubview:breastmonthamount];
    breastmonthamount.frame = CGRectMake(historyView.frame.size.width/2.0  + 5+50, 5+16.5+10, 40, MIDTEXT);
    breastmonthamount.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    breastmonthamount.font = [UIFont systemFontOfSize:MIDTEXT];
    breastmonthamount.textAlignment = NSTextAlignmentLeft;
    
    breastmonthstatusImageView = [[UIImageView alloc] init];
    [historyView addSubview:breastmonthstatusImageView];
    breastmonthstatusImageView.frame = CGRectMake(historyView.frame.size.width/2.0  + 5+50+40, 5+16.5+10, 18/2.0, 21/2.0);
    cutbreastmonth = [[UILabel alloc]init];
    cutbreastmonth.frame = CGRectMake(historyView.frame.size.width/2.0+5+50+40+18/2.0, 5+16.5+10, 40, 10);
    cutbreastmonth.textAlignment = NSTextAlignmentLeft;
    cutbreastmonth.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    cutbreastmonth.font = [UIFont systemFontOfSize:SMALLTEXT];
    [historyView addSubview:cutbreastmonth];
    
    milkweeklabel  = [[UILabel alloc]init];
    [historyView addSubview:milkweeklabel];
    milkweeklabel.frame = CGRectMake(5, 5+16.5+10+15+10, 50, 15);
    milkweeklabel.text = @"奶粉:";
    milkweeklabel.font = [UIFont systemFontOfSize:MIDTEXT];
    milkweeklabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    milkweeklabel.textAlignment = NSTextAlignmentLeft;

    milkweekamount = [[UILabel alloc] init];
    [historyView addSubview:milkweekamount];
    milkweekamount.frame = CGRectMake(5+50, 5+16.5+10+15+10, 40, MIDTEXT);
    milkweekamount.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    milkweekamount.font = [UIFont systemFontOfSize:MIDTEXT];
    milkweekamount.textAlignment = NSTextAlignmentLeft;
    
    milkweekstatusImageView = [[UIImageView alloc] init];
    [historyView addSubview:milkweekstatusImageView];
     milkweekstatusImageView.frame = CGRectMake(5+50+40, 5+16.5+10+15+10, 18/2.0, 21/2.0);
    cutmilkweek = [[UILabel alloc]init];
    [historyView addSubview:cutmilkweek];
    cutmilkweek.frame = CGRectMake(5+50+40+18/2.0, 5+16.5+10+15+10, 40, 10);
    cutmilkweek.textAlignment = NSTextAlignmentLeft;
    cutmilkweek.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    cutmilkweek.font = [UIFont systemFontOfSize:SMALLTEXT];
    
    milkmonthlabel = [[UILabel alloc]init];
    [historyView addSubview:milkmonthlabel];
    milkmonthlabel.frame = CGRectMake(historyView.frame.size.width/2.0 + 5, 5+16.5+10+15+10, 90, 15);
    milkmonthlabel.text = @"奶粉:";
    milkmonthlabel.font = [UIFont systemFontOfSize:MIDTEXT];
    milkmonthlabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    milkmonthlabel.textAlignment = NSTextAlignmentLeft;

    milkmonthamount = [[UILabel alloc] init];
    [historyView addSubview:milkmonthamount];
    milkmonthamount.frame = CGRectMake(historyView.frame.size.width/2.0+5+50, 5+16.5+10+15+10, 40, MIDTEXT);
    milkmonthamount.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    milkmonthamount.font = [UIFont systemFontOfSize:MIDTEXT];
    milkmonthamount.textAlignment = NSTextAlignmentLeft;
    
    milkmonthstatusImageView = [[UIImageView alloc] init];
    [historyView addSubview:milkmonthstatusImageView];
    milkmonthstatusImageView.frame = CGRectMake(historyView.frame.size.width/2.0+5+50+40, 5+16.5+10+15+10, 18/2.0, 21/2.0);

    cutmilkmonth = [[UILabel alloc]init];
    [historyView addSubview:cutmilkmonth];
    cutmilkmonth.frame = CGRectMake(historyView.frame.size.width/2.0+5+50+40+18/2.0, 5+16.5+10+15+10, 40, 10);
    cutmilkmonth.textAlignment = NSTextAlignmentLeft;
    cutmilkmonth.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    cutmilkmonth.font = [UIFont systemFontOfSize:SMALLTEXT];
    
    timerImage = [[UIImageView alloc]initWithFrame:CGRectMake((320-165*PNGSCALE)/2.0, 90*PNGSCALE+20*PNGSCALE+60*PNGSCALE, 165*PNGSCALE, 111*PNGSCALE)];
    [timerImage setBackgroundColor:[UIColor clearColor]];
    if (startButton.selected==YES)
    {
        timerImage.frame = CGRectMake(140, 150, 165*PNGSCALE, 111*PNGSCALE);
    }
    [self.view addSubview:timerImage];
    
    UIImageView *timeicon=[[UIImageView alloc]initWithFrame:CGRectMake(2, 20*PNGSCALE, 21*PNGSCALE, 24*PNGSCALE)];
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
    
    startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame=CGRectMake(40,150*PNGSCALE+80*PNGSCALE, 182*PNGSCALE/2.0*0.75, 366*PNGSCALE/2.0*0.75);
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_feeding_play"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_feeding_pause"] forState:UIControlStateSelected];
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    startButtonleft=[UIButton buttonWithType:UIButtonTypeCustom];
    startButtonleft.frame=CGRectMake(19,90*PNGSCALE+20*PNGSCALE+20*PNGSCALE+111*PNGSCALE, 273*PNGSCALE/2.0, 225*PNGSCALE/2.0);
    [startButtonleft setBackgroundImage:[UIImage imageNamed:@"btn_l_play"] forState:UIControlStateNormal];
    [startButtonleft setBackgroundImage:[UIImage imageNamed:@"btn_l_pause"] forState:UIControlStateSelected];
    [self.view addSubview:startButtonleft];
    [startButtonleft addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    startButtonright=[UIButton buttonWithType:UIButtonTypeCustom];
    startButtonright.frame=CGRectMake(320-19-273/2.0*PNGSCALE,90*PNGSCALE+20*PNGSCALE+20*PNGSCALE+111*PNGSCALE, 273/2.0*PNGSCALE, 225*PNGSCALE/2.0);
    [startButtonright setBackgroundImage:[UIImage imageNamed:@"btn_r_play"] forState:UIControlStateNormal];
    [startButtonright setBackgroundImage:[UIImage imageNamed:@"btn_r_pause"] forState:UIControlStateSelected];
    [self.view addSubview:startButtonright];
    [startButtonright addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    addRecordBtn = [[UIButton alloc]initWithFrame:CGRectMake(110, 370*PNGSCALE, 100, 28)];
    [addRecordBtn setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    [addRecordBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addRecordBtn setAlpha:1];
    [addRecordBtn setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
    [addRecordBtn addTarget:self action:@selector(addrecord:) forControlEvents:UIControlEventTouchUpInside];
    addRecordBtn.layer.cornerRadius = 5.0f;
    [self.view addSubview:addRecordBtn];

    [self loadData];
}

- (void)loadData
{
    NSDictionary *curStatusList = [[SummaryDB dataBase]searchCurFeedStatusList];
    NSDictionary *lastStatusList = [[SummaryDB dataBase] searchLastFeedStatusList];
    if (curStatusList != nil && lastStatusList != nil && [curStatusList count]>0)
    {
        int week_breast_average  = 0;
        int week_milk_average    = 0;
        int month_breast_average = 0;
        int month_milk_average   = 0;
        
        if ([curStatusList objectForKey:@"week_breast_average"]) {
            week_breast_average = [[curStatusList objectForKey:@"week_breast_average"]intValue];
        }
        
        if ([curStatusList objectForKey:@"week_milk_average"]) {
            week_milk_average = [[curStatusList objectForKey:@"week_milk_average"]intValue];
        }
        
        if ([curStatusList objectForKey:@"month_breast_average"]) {
            month_breast_average = [[curStatusList objectForKey:@"month_breast_average"]intValue];
        }
        
        if ([curStatusList objectForKey:@"month_milk_average"]) {
            month_milk_average = [[curStatusList objectForKey:@"month_milk_average"]intValue];
        }
        
        int last_week_breast_average  = 0;
        int last_week_milk_average    = 0;
        int last_month_breast_average = 0;
        int last_month_milk_average   = 0;

        if ([lastStatusList count]>0)
        {
            if ([lastStatusList objectForKey:@"week_breast_average"])
            {
                last_week_breast_average = [[lastStatusList objectForKey:@"week_breast_average"]intValue];
            }
            
            if ([lastStatusList objectForKey:@"week_milk_average"])
            {
                last_week_milk_average = [[lastStatusList objectForKey:@"week_milk_average"]intValue];
            }
            
            if ([lastStatusList objectForKey:@"month_breast_average"])
            {
                last_month_breast_average = [[lastStatusList objectForKey:@"month_breast_average"]intValue];
            }
            
            if ([lastStatusList objectForKey:@"month_milk_average"])
            {
                last_month_milk_average = [[lastStatusList objectForKey:@"month_milk_average"]intValue];
            }
            
            breastweekamount.text = [NSString stringWithFormat:@"%d", week_breast_average];
            breastmonthamount.text = [NSString stringWithFormat:@"%d",month_breast_average];
            milkweekamount.text = [NSString stringWithFormat:@"%d", week_milk_average];
            milkmonthamount.text = [NSString stringWithFormat:@"%d",month_milk_average];
            
            if (week_breast_average > last_week_breast_average)
            {
                [breastweekstatusImageView setImage:[UIImage imageNamed:@"arrow_up"]];
                cutbreastweek.text = [NSString stringWithFormat:@"%d",week_breast_average-last_week_breast_average];
                
            }
            else if (week_breast_average == last_week_breast_average)
            {
                [breastweekstatusImageView setImage:[UIImage imageNamed:@"arrow_flat"]];
            }
            else
            {
                [breastweekstatusImageView setImage:[UIImage imageNamed:@"arrow_down"]];
                cutbreastweek.text = [NSString stringWithFormat:@"%d",last_week_breast_average-week_breast_average];
            }
            
            if (week_milk_average > last_week_milk_average)
            {
                [milkweekstatusImageView setImage:[UIImage imageNamed:@"arrow_up"]];
                cutmilkweek.text = [NSString stringWithFormat:@"%d",week_milk_average-last_week_milk_average];
            }
            else if (week_milk_average == last_week_milk_average)
            {
                 [milkweekstatusImageView setImage:[UIImage imageNamed:@"arrow_flat"]];
            }
            else
            {
                [milkweekstatusImageView setImage:[UIImage imageNamed:@"arrow_down"]];
                cutmilkweek.text = [NSString stringWithFormat:@"%d",last_week_milk_average-week_milk_average];
            }
            
            if (month_breast_average > last_month_breast_average)
            {
                [breastmonthstatusImageView setImage:[UIImage imageNamed:@"arrow_up"]];
                cutbreastmonth.text = [NSString stringWithFormat:@"%d",month_breast_average-last_month_breast_average];
            }
            else if (month_breast_average == last_month_breast_average)
            {
                 [breastmonthstatusImageView setImage:[UIImage imageNamed:@"arrow_flat"]];
            }
            else
            {
                [breastmonthstatusImageView setImage:[UIImage imageNamed:@"arrow_down"]];
                cutbreastmonth.text = [NSString stringWithFormat:@"%d",last_month_breast_average-month_breast_average];
            }
            
            if (month_milk_average > last_month_milk_average)
            {
                [milkmonthstatusImageView setImage:[UIImage imageNamed:@"arrow_up"]];
                cutmilkmonth.text = [NSString stringWithFormat:@"%d",month_milk_average-last_month_milk_average];
            }
            else if (month_milk_average == last_month_milk_average)
            {
                [milkmonthstatusImageView setImage:[UIImage imageNamed:@"arrow_flat"]];
            }
            else
            {
                [milkmonthstatusImageView setImage:[UIImage imageNamed:@"arrow_down"]];
                cutmilkmonth.text = [NSString stringWithFormat:@"%d",last_month_milk_average-month_milk_average];
            }
            
        }
    }
}

- (void)pushSummaryView:(id)sender{
    summary = [SummaryViewController summary];
    [summary MenuSelectIndex:2];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:summary animated:YES];
}

-(void)startOrPause:(UIButton*)sender
{
    if (sender==startButton) {
        self.breast=nil;
        if (!sender.selected) {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TimerTipsTile", nil) message:NSLocalizedString(@"TimerMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil, nil];
                
                [alert show];
                
                return;
            }
            labletip.text = NSLocalizedString(@"Counting", nil);           startButton.selected=YES;
            self.breast=@"";
            
            [[NSUserDefaults standardUserDefaults] setObject:[ACDate date] forKey:@"timerOn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"feed" forKey:@"ctl"];
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
        }
        else{
            
            [self makeSave];
            
        }
        
        
    }
    else if(sender==startButtonleft)
    {
        self.breast=@"left";
        if (!sender.selected) {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TimerTipsTile", nil) message:NSLocalizedString(@"TimerMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil, nil];
                
                [alert show];
                
                return;
            }
            labletip.text = NSLocalizedString(@"Counting", nil);
            
            sender.selected=YES;
            [[NSUserDefaults standardUserDefaults] setObject:[ACDate date] forKey:@"timerOn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"feed" forKey:@"ctl"];
            [[NSUserDefaults standardUserDefaults] setObject:@"left" forKey:@"breast"];
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];    }
        else{
            [self makeSave];
            
        }
        
    }
    else
    {
        self.breast=@"right";
        if (!sender.selected) {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TimerTipsTile", nil) message:NSLocalizedString(@"TimerMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil, nil];
                
                [alert show];
                
                return;
            }
            labletip.text = NSLocalizedString(@"Counting", nil);
            
            sender.selected=YES;
            [[NSUserDefaults standardUserDefaults] setObject:[ACDate date] forKey:@"timerOn"];
            [[NSUserDefaults standardUserDefaults] setObject:@"feed" forKey:@"ctl"];
            [[NSUserDefaults standardUserDefaults] setObject:@"right" forKey:@"breast"];
            timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];    }
        else{
            [self makeSave];
            
        }
        
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
        saveView = [[save_feedview alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height) FeedWay:self.feedWay Breasttype:self.breast];
    }
    adviseImageView.userInteractionEnabled = YES;
    saveView.feedSaveDelegate = self;
    saveView.feedway=self.feedWay;
    saveView.breast=self.breast;
    [saveView loaddata];
    
    startButton.enabled = NO;
    startButtonright.enabled = NO;
    startButtonleft.enabled = NO;
    [self.view bringSubviewToFront:adviseImageView];
    [self.view addSubview:saveView];
}

-(void)stop:(NSNotification*)noti
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addfeednow"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"breast"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"breast"];
    }
    startButton.enabled = YES;
    startButtonright.enabled = YES;
    startButtonleft.enabled = YES;
    addRecordBtn.enabled = YES;
    
    [timer invalidate];
    timer = nil;
    timeLable.text=@"00:00:00";
    startButton.selected=NO;
    startButtonleft.selected=NO;
    startButtonright.selected=NO;
    [saveView removeFromSuperview];
    labletip.text=@"The end time,a total of...";
    NSNumber *dur=noti.object;
    labletip.text=[NSString stringWithFormat:NSLocalizedString(@"Over", nil),[dur floatValue]/3600];
    adviseImageView.userInteractionEnabled = YES;
}

-(void)cancel:(NSNotification*)noti
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"addfeednow"])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addfeednow"];
    }
    startButton.enabled = YES;
    startButtonright.enabled = YES;
    startButtonleft.enabled = YES;
    adviseImageView.userInteractionEnabled = YES;
}

-(void)feedWay:(UIButton *)sender
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"ctl"] isEqualToString:@"feed"]&&![self.obj isEqualToString:@"self"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TimerTipsTile", nil) message:NSLocalizedString(@"TimerMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    }
    
    sender.enabled=NO;
    UIButton *another=nil;
    UIImageView *feedway=(UIImageView*)[self.view viewWithTag:103];
    if (sender.tag==101) {
        another=(UIButton*)[self.view viewWithTag:102];
        self.feedWay=@"breast";
        feedway.hidden=YES;
        startButton.hidden=YES;
        startButtonleft.hidden=NO;
        startButtonright.hidden=NO;
        historyView.hidden = YES;
        timerImage.frame = CGRectMake((320-165*PNGSCALE)/2.0, 90*PNGSCALE+20*PNGSCALE, 165*PNGSCALE, 111*PNGSCALE);
        
    }
    else
    {
        another=(UIButton*)[self.view viewWithTag:101];
        self.feedWay=@"bottle";
        historyView.hidden = NO;
        feedway.hidden=NO;
        startButton.hidden=NO;
        startButtonleft.hidden=YES;
        startButtonright.hidden=YES;
        timerImage.frame = CGRectMake(140, 150+60*PNGSCALE, 165*PNGSCALE, 111*PNGSCALE);
        
    }
    another.enabled=YES;
    self.obj=@"user";
    
}

-(IBAction)addrecord:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addfeednow"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[ACDate date] forKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] setObject:@"feed" forKey:@"ctl"];
    
    [self makeSave];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeView];
    [self makeAdvise];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark feeddelegate
-(void)sendFeedSaveChanged:(int)duration andstarttime:(NSDate*)newstarttime
{
    
}
-(void)sendFeedReloadData
{
    [self loadData];
}
@end
