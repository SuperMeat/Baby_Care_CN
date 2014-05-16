//
//  diaperViewController.m
//  Parenting
//
//  Created by user on 13-5-23.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "diaperViewController.h"

@interface diaperViewController ()

@end

@implementation diaperViewController
@synthesize summary,status;

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
    [MobClick beginLogPageView:@"换尿布"];
    self.hidesBottomBarWhenPushed = YES;
    [self makeNav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:@"stop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel) name:@"cancel" object:nil];
    
    NSUserDefaults *db = [NSUserDefaults standardUserDefaults];

    [db setObject:@"0" forKey:@"MARK"];
    [db synchronize];
    
    if (startButton != nil) {
        startButton.enabled = YES;
    }
    
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"换尿布"];
    [saveView removeFromSuperview];
}

+(id)shareViewController
{

    static dispatch_once_t pred = 0;
    __strong static diaperViewController* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
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
    [titleText setText:NSLocalizedString(@"Diaper", nil)];
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

- (void)pushSummaryView:(id)sender{
    summary = [SummaryViewController summary];
    [summary MenuSelectIndex:4];
    [self.navigationController pushViewController:summary animated:YES];
}



-(void)makeAdvise
{
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"Everything is ok",@"title",@"Give your baby a bath and take him for a walk every day at about the same time. It'll get him used to the idea of daily routine. In fact, he'll probably take comfort in it. With a little luck, other schedules will fall into place more easily, too.",@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"Everything is ok",@"title",@"When your baby is very young, feed him whenever you notice hunger signals — even when they seem completely random.",@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:@"Everything is ok",@"title",@"It is very normal that Lots of babies seem to prefer the nighttime hours for activity, and the daytime hours for slumber.Be patient. Most babies adjust to the family timetable in a month or so. ",@"content", nil];
    
    AdviseScrollview *ad=[[AdviseScrollview alloc]initWithArray:[NSArray arrayWithObjects:dict1,dict2,dict3, nil]];
    
    adviseImageView = [[UIImageView alloc] init];
    [adviseImageView setFrame:CGRectMake(0, WINDOWSCREEN-130, 320, 130)];
    [adviseImageView setBackgroundColor:[ACFunction colorWithHexString:@"#e7e7e7"]];
    adviseImageView.userInteractionEnabled = YES;
    [adviseImageView addSubview:ad];
    [self.view addSubview:adviseImageView];
}

- (void)loadData
{
    NSDictionary *todayDic = [[SummaryDB dataBase]searchTodayDiaperStatusList];
    NSDictionary *yesDic   = [[SummaryDB dataBase]
                              searchYesterdayDiaperStatusList];
    
    if (todayDic != nil && [todayDic count]>0)
    {
        if ([todayDic objectForKey:@"all"]) {
            todayCount.text = [NSString stringWithFormat:@"%d", [[todayDic objectForKey:@"all"] intValue]];
        }
        else
        {
            todayCount.text = @"0";
        }
        
        int todayxuxu_count = 0,yesxuxu_count = 0;;
        if ([todayDic objectForKey:@"xuxu"])
        {
            todayxuxu_count =[[todayDic objectForKey:@"xuxu"] intValue];
        }
        
        if ([yesDic objectForKey:@"xuxu"])
        {
            yesxuxu_count = [[yesDic objectForKey:@"xuxu"] intValue];
        }
        
        todayXuXu.text = [NSString stringWithFormat:@"%d",todayxuxu_count];
        if (todayxuxu_count > yesxuxu_count) {
            [XuXuStatusView setImage:[UIImage imageNamed:@"arrow_up"]];
            cutXuXu.text = [NSString stringWithFormat:@"%d", todayxuxu_count-yesxuxu_count];
            cutXuXu.textColor = [ACFunction colorWithHexString:GREENARROWCOLOR];
        }
        else if (todayxuxu_count == yesxuxu_count)
        {
            [XuXuStatusView setImage:[UIImage imageNamed:@"arrow_flat"]];
            cutXuXu.text = @"";
        }
        else
        {
            [XuXuStatusView setImage:[UIImage imageNamed:@"arrow_down"]];
            cutXuXu.text = [NSString stringWithFormat:@"%d", yesxuxu_count - todayxuxu_count];
            cutXuXu.textColor = [ACFunction colorWithHexString:REDARROWCOLOR];
        }
        
        int todaybaba_count = 0,yesbaba_count = 0;;
        if ([todayDic objectForKey:@"baba"])
        {
            todaybaba_count =[[todayDic objectForKey:@"baba"] intValue];
        }
        
        if ([yesDic objectForKey:@"baba"])
        {
            yesbaba_count = [[yesDic objectForKey:@"baba"] intValue];
        }
        
        todayBaBa.text = [NSString stringWithFormat:@"%d",todaybaba_count];
        if (todaybaba_count > yesbaba_count) {
            [BaBaStatusView setImage:[UIImage imageNamed:@"arrow_up"]];
            cutBaBa.text = [NSString stringWithFormat:@"%d", todaybaba_count-yesbaba_count];
            cutBaBa.textColor = [ACFunction colorWithHexString:GREENARROWCOLOR];
        }
        else if (todaybaba_count == yesbaba_count)
        {
            [BaBaStatusView setImage:[UIImage imageNamed:@"arrow_flat"]];
            cutBaBa.text = @"";
        }
        else
        {
            [BaBaStatusView setImage:[UIImage imageNamed:@"arrow_down"]];
            cutBaBa.text = [NSString stringWithFormat:@"%d", yesbaba_count - todaybaba_count];
            cutBaBa.textColor = [ACFunction colorWithHexString:REDARROWCOLOR];
        }

        int todayxuxubaba_count = 0,yesxuxubaba_count = 0;;
        if ([todayDic objectForKey:@"xuxubaba"])
        {
            todayxuxubaba_count =[[todayDic objectForKey:@"xuxubaba"] intValue];
        }
        
        if ([yesDic objectForKey:@"xuxubaba"])
        {
            yesxuxubaba_count = [[yesDic objectForKey:@"xuxubaba"] intValue];
        }
        
        todayXuXuBaBa.text = [NSString stringWithFormat:@"%d",todayxuxubaba_count];
        if (todayxuxubaba_count > yesxuxubaba_count) {
            [XuXuBaBaStatusView setImage:[UIImage imageNamed:@"arrow_up"]];
            cutXuXuBaBa.text = [NSString stringWithFormat:@"%d", todayxuxubaba_count-yesxuxubaba_count];
            cutXuXuBaBa.textColor = [ACFunction colorWithHexString:GREENARROWCOLOR];
        }
        else if (todayxuxubaba_count == yesxuxubaba_count)
        {
            [XuXuBaBaStatusView setImage:[UIImage imageNamed:@"arrow_flat"]];
            cutXuXuBaBa.text = @"";
        }
        else
        {
            [XuXuBaBaStatusView setImage:[UIImage imageNamed:@"arrow_down"]];
            cutXuXuBaBa.text = [NSString stringWithFormat:@"%d", yesxuxubaba_count - todayxuxubaba_count];
            cutXuXuBaBa.textColor = [ACFunction colorWithHexString:REDARROWCOLOR];
        }
    }
}

-(void)makeView
{
    historyView = [[UIImageView alloc] initWithFrame:CGRectMake((320-599/2.0)/2.0, 10+64, 599/2.0, 205/2.0)];
    [historyView setImage:[UIImage imageNamed:@"bg.png"]];
    historyView.layer.cornerRadius = 15.0f;
    [self.view addSubview:historyView];
    
    UILabel *today = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 130, 20)];
    today.text = @"今天换尿布次数:";
    today.textAlignment = NSTextAlignmentLeft;
    today.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    today.font      = [UIFont systemFontOfSize:33/2.0];
    [historyView addSubview:today];
    
    todayCountView = [[UIImageView alloc]initWithFrame:CGRectMake((320-599/2.0)/2.0, 10+20+10, 120, 50)];
    todayCountView.layer.cornerRadius = 5.0f;
    [todayCountView setBackgroundColor:[ACFunction colorWithHexString:IMAGEVIEWBGCOLOR]];
    [historyView addSubview:todayCountView];
    
    todayCount = [[UILabel alloc] init];
    todayCount.frame = CGRectMake(0, 0, 120, 50);
    todayCount.center = CGPointMake(120/2.0, 50/2.0);
    todayCount.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    todayCount.textAlignment = NSTextAlignmentCenter;
    todayCount.font      = [UIFont systemFontOfSize:72/2.0];
    [todayCountView addSubview:todayCount];
    
    UIImageView *lefthistory =  [[UIImageView alloc] initWithFrame:CGRectMake(140, 10, 150, 205/2.0-20)];
    [lefthistory setBackgroundColor:[UIColor clearColor]];
    [historyView addSubview:lefthistory];
    
    todayXuXu = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 20, 20)];
    todayXuXu.backgroundColor = [UIColor clearColor];
    todayXuXu.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    todayXuXu.textAlignment = NSTextAlignmentCenter;
    todayXuXu.font = [UIFont systemFontOfSize:33/2.0];
    [lefthistory addSubview:todayXuXu];
    
    XuXuStatusView = [[UIImageView alloc] init];
    XuXuStatusView.frame = CGRectMake(35+18, 3, 18/2.0, 21/2.0);
    [lefthistory addSubview:XuXuStatusView];
    
    cutXuXu = [[UILabel alloc] initWithFrame:CGRectMake(35+18+21/2.0, 3, 20, 10)];
    cutXuXu.textAlignment = NSTextAlignmentLeft;
    cutXuXu.font = [UIFont systemFontOfSize:10];
    [lefthistory addSubview:cutXuXu];
    
    
    UILabel *xuxu = [[UILabel alloc] initWithFrame:CGRectMake(35+40, 5, 70, 20)];
    xuxu.text = @"嘘嘘";
    xuxu.backgroundColor = [UIColor clearColor];
    xuxu.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    xuxu.textAlignment = NSTextAlignmentLeft;
    xuxu.font = [UIFont systemFontOfSize:33/2.0];
    [lefthistory addSubview:xuxu];
    
    todayBaBa = [[UILabel alloc] initWithFrame:CGRectMake(35, 5+26, 20, 20)];
    todayBaBa.backgroundColor = [UIColor clearColor];
    todayBaBa.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    todayBaBa.textAlignment = NSTextAlignmentCenter;
    todayBaBa.font = [UIFont systemFontOfSize:33/2.0];
    [lefthistory addSubview:todayBaBa];
    BaBaStatusView = [[UIImageView alloc] init];
    BaBaStatusView.frame = CGRectMake(35+18, 5+26+3, 18/2.0, 21/2.0);
    [lefthistory addSubview:BaBaStatusView];
    cutBaBa = [[UILabel alloc] initWithFrame:CGRectMake(35+18+21/2.0, 5+26, 20, 10)];
    cutBaBa.textAlignment = NSTextAlignmentLeft;
    cutBaBa.font = [UIFont systemFontOfSize:10];
    [lefthistory addSubview:cutBaBa];
    
    UILabel *baba = [[UILabel alloc] initWithFrame:CGRectMake(35+40, 5+26, 70, 20)];
    baba.text = @"粑粑";
    baba.backgroundColor = [UIColor clearColor];
    baba.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    baba.textAlignment = NSTextAlignmentLeft;
    baba.font = [UIFont systemFontOfSize:33/2.0];
    [lefthistory addSubview:baba];

    
    todayXuXuBaBa = [[UILabel alloc] initWithFrame:CGRectMake(35, 5+52, 20, 20)];
    todayXuXuBaBa.backgroundColor = [UIColor clearColor];
    todayXuXuBaBa.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    todayXuXuBaBa.textAlignment = NSTextAlignmentCenter;
    todayXuXuBaBa.font = [UIFont systemFontOfSize:33/2.0];
    
    [lefthistory addSubview:todayXuXuBaBa];
    XuXuBaBaStatusView = [[UIImageView alloc] init];
    XuXuBaBaStatusView.frame = CGRectMake(35+18, 5+52+3, 18/2.0, 21/2.0);
    [lefthistory addSubview:XuXuBaBaStatusView];
    
    cutXuXuBaBa = [[UILabel alloc] initWithFrame:CGRectMake(35+18+21/2.0, 5+52+3, 20, 10)];
    cutXuXuBaBa.textAlignment = NSTextAlignmentLeft;
    cutXuXuBaBa.font = [UIFont systemFontOfSize:10];

    [lefthistory addSubview:cutXuXuBaBa];
    
    UILabel *xuxubaba = [[UILabel alloc] initWithFrame:CGRectMake(35+40, 5+52, 70, 20)];
    xuxubaba.text = @"嘘嘘粑粑";
    xuxubaba.backgroundColor = [UIColor clearColor];
    xuxubaba.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    xuxubaba.textAlignment = NSTextAlignmentLeft;
    xuxubaba.font = [UIFont systemFontOfSize:33/2.0];
    [lefthistory addSubview:xuxubaba];
    
    startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    startButton.bounds=CGRectMake(0, 0, 100, 28);
    startButton.center=CGPointMake(160, 370*PNGSCALE);
    [startButton setTitle:NSLocalizedString(@"Submit",nil) forState:UIControlStateNormal];
    [startButton setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    startButton.layer.cornerRadius = 5.0f;
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dry=[UIButton buttonWithType:UIButtonTypeCustom];
    dry.frame=CGRectMake(17, 150+G_YADDONVERSION+189/4.0-10, 189/2.0, 189/2.0);
    [dry setBackgroundImage:[UIImage imageNamed:@"icon_both"] forState:UIControlStateNormal];
    [dry setBackgroundImage:[UIImage imageNamed:@"icon_both_choose"] forState:UIControlStateDisabled];
    [self.view addSubview:dry];
    dry.tag=201;
    [dry addTarget:self action:@selector(Activityselected:) forControlEvents:UIControlEventTouchUpInside];
    [self Activityselected:dry];
    
    UIButton *wet=[UIButton buttonWithType:UIButtonTypeCustom];
    wet.frame=CGRectMake(160-45, 150+G_YADDONVERSION+189/4.0-10, 189/2.0, 189/2.0);
    [wet setBackgroundImage:[UIImage imageNamed:@"icon_wet"] forState:UIControlStateNormal];
    [wet setBackgroundImage:[UIImage imageNamed:@"icon_wet_choose"] forState:UIControlStateDisabled];
    [self.view addSubview:wet];
    wet.tag=202;
    [wet addTarget:self action:@selector(Activityselected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dirty=[UIButton buttonWithType:UIButtonTypeCustom];
    dirty.frame=CGRectMake(320-17-90, 150+G_YADDONVERSION+189/4.0-10, 189/2.0, 189/2.0);
    [dirty setBackgroundImage:[UIImage imageNamed:@"icon_dirty"] forState:UIControlStateNormal];
    [dirty setBackgroundImage:[UIImage imageNamed:@"icon_dirty_choose"] forState:UIControlStateDisabled];
    [self.view addSubview:dirty];
    dirty.tag=203;
    [dirty addTarget:self action:@selector(Activityselected:) forControlEvents:UIControlEventTouchUpInside];

    [self loadData];
    
}


-(void)Activityselected:(UIButton*)sender
{
    sender.enabled=NO;
    
    UIButton *another1,*another2;
    if (sender.tag==201) {
        another1=(UIButton*)[self.view viewWithTag:202];
        
        another2=(UIButton*)[self.view viewWithTag:203];
        self.status=@"XuXuBaBa";
        
    }
    else if(sender.tag==202)
    {
        another1=(UIButton*)[self.view viewWithTag:201];
        another2=(UIButton*)[self.view viewWithTag:203];
        self.status=@"XuXu";
    }
    else
    {
        another1=(UIButton*)[self.view viewWithTag:201];
        another2=(UIButton*)[self.view viewWithTag:202];
        self.status=@"BaBa";
    }
    another1.enabled=YES;
    another2.enabled=YES;
    
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
    [self makeSave];
}

-(void)makeSave
{

    if (saveView==nil) {
        saveView=[[save_diaperview alloc]init];
        [saveView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-20, self.view.frame.size.width, self.view.frame.size.height)];
        saveView.diaperSaveDelegate = self;
        saveView.status = self.status;

    }
    saveView.status=self.status;
    [saveView loaddata];

    startButton.enabled = NO;
    [self.view addSubview:saveView];
    
}
-(void)stop
{
    startButton.selected=NO;
    startButton.enabled = YES;

    [saveView removeFromSuperview];

}
-(void)cancel

{
    //[saveView removeFromSuperview];
    startButton.enabled = YES;
}

#pragma -mark save_diaperDelegate
-(void)sendReloadData
{
    [self loadData];
}

-(void)sendDiaperSaveChanged:(NSString *)newstatus andstarttime:(NSDate *)newstarttime
{
    
}
@end
