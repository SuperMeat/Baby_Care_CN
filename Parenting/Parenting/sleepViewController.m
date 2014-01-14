//
//  sleepViewController.m
//  Parenting
//
//  Created by user on 13-5-23.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "sleepViewController.h"

@interface sleepViewController ()

@end

@implementation sleepViewController
@synthesize summary,weather;

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
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        //self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.weather) {
        self.weather.chooseType = QCM_TYPE_SLEEP;
        [self.weather refreshweather];
    }
    
    if (startButton != nil) {
        startButton.enabled = YES;
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"ctl"] isEqualToString:@"sleep"]) {
        labletip.text = NSLocalizedString(@"Counting", nil);
        startButton.selected=YES;
        //timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
        //
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
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    str = @"0";
    [db setObject:str forKey:@"MARK"];
    [db synchronize];
    
    //labletip.text = NSLocalizedString(@"Wait", nil);

}
-(void)viewWillDisappear:(BOOL)animated
{
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
    __strong static sleepViewController* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(void)makeNav
{
    //self.navigationItem.title=NSLocalizedString(@"Sleep", nil);
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
    [backbutton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 34, 28)];
    title.backgroundColor = [UIColor clearColor];
    [title setTextAlignment:NSTextAlignmentCenter];
    //title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.text = NSLocalizedString(@"navback", nil);
    title.font = [UIFont systemFontOfSize:14];
    [backbutton addSubview:title];
    
    
    [backbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame=CGRectMake(0, 0, 44, 28);
    
    
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"btn1.png"] forState:UIControlStateNormal];
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 83, 28)];
    title1.backgroundColor = [UIColor clearColor];
    [title1 setTextAlignment:NSTextAlignmentCenter];
    //title1.textAlignment = NSTextAlignmentCenter;
    title1.textColor = [UIColor whiteColor];
    title1.text = NSLocalizedString(@"navsummary", nil);
    title1.font = [UIFont systemFontOfSize:14];
    [rightButton addSubview:title1];
    
    
    [rightButton addTarget:self action:@selector(pushSummaryView:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame=CGRectMake(0, 0, 83, 28);
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)pushSummaryView:(id)sender{
    [summary MenuSelectIndex:3];
    self.tabBarController.selectedIndex = 1;
}


-(void)makeAdvise
{
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"Everything is ok",@"title",@"Give your baby a bath and take him for a walk every day at about the same time. It'll get him used to the idea of daily routine. In fact, he'll probably take comfort in it. With a little luck, other schedules will fall into place more easily, too.",@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"Everything is ok",@"title",@"When your baby is very young, feed him whenever you notice hunger signals — even when they seem completely random.",@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:@"Everything is ok",@"title",@"It is very normal that Lots of babies seem to prefer the nighttime hours for activity, and the daytime hours for slumber.Be patient. Most babies adjust to the family timetable in a month or so. ",@"content", nil];
    
    AdviseScrollview *ad=[[AdviseScrollview alloc]initWithArray:[NSArray arrayWithObjects:dict1,dict2,dict3, nil]];
    
    
    [self.view addSubview:ad];

    
    self.weather=[WeatherView weatherview];
    [self.weather makeview];
    self.weather.chooseType = QCM_TYPE_SLEEP;
    weather.frame=CGRectMake(0, 0+G_YADDONVERSION, 320, 200);
    [self.view addSubview:weather];
    NSLog(@"weather %@",weather);
}

-(void)makeView
{
    
//    UIButton *environment=[UIButton buttonWithType:UIButtonTypeCustom];
//    [environment setTitle:NSLocalizedString(@"btnenvironment", nil) forState:UIControlStateNormal];
//    [environment setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 10, 0)];
//    [environment setBackgroundImage:[UIImage imageNamed:@"label_left.png"] forState:UIControlStateNormal];
//    [environment setBackgroundImage:[UIImage imageNamed:@"label_left_focus.png"] forState:UIControlStateDisabled];
//    environment.frame=CGRectMake(0, 190+G_YADDONVERSION, 160, 47);
//    [self.view addSubview:environment];
//    environment.tag=501;
//    [environment addTarget:self action:@selector(environmentOradvise:) forControlEvents:UIControlEventTouchUpInside];
//    [environment setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//    [environment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    
//    
//    
//    UIButton *advise=[UIButton buttonWithType:UIButtonTypeCustom];
//    [advise setTitle:NSLocalizedString(@"btnadvise", nil)  forState:UIControlStateNormal];
//    [advise setBackgroundImage:[UIImage imageNamed:@"label_right.png"] forState:UIControlStateNormal];
//    [advise setBackgroundImage:[UIImage imageNamed:@"label_right_focus.png"] forState:UIControlStateDisabled];
//    advise.frame=CGRectMake(160, 190+G_YADDONVERSION, 160, 47);
//    [advise setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 10, 0)];
//    [self.view addSubview:advise];
//    advise.tag=502;
//    [advise addTarget:self action:@selector(environmentOradvise:) forControlEvents:UIControlEventTouchUpInside];
//    [self environmentOradvise:advise];
//    [advise setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//    [advise setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    if (CUSTOMER_COUNTRY==1) {
        UILabel *pmintro = [[UILabel alloc]initWithFrame:CGRectMake(208, 187, 100, 20)];
        [pmintro setBackgroundColor:[UIColor clearColor]];
        [pmintro setText:@"数据来源PM25.in"];
        [pmintro setFont:[UIFont fontWithName:@"Arial" size:12]];
        [pmintro setTextColor:[UIColor whiteColor]];
        [self.view addSubview:pmintro];
    }

    addRecordBtn = [[UIButton alloc]initWithFrame:CGRectMake(250, 240, 50, 28)];
    [addRecordBtn setBackgroundColor:[UIColor clearColor]];
    [addRecordBtn setBackgroundImage:[UIImage imageNamed:@"btn2.png"] forState:UIControlStateNormal];
    [addRecordBtn setAlpha:1];
    [addRecordBtn setTitle:NSLocalizedString(@"Add", nil) forState:UIControlStateNormal];
    [addRecordBtn addTarget:self action:@selector(addrecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addRecordBtn];
    
    startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame=CGRectMake(90, 300+G_YADDONVERSION, 63, 63);
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_start.png"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_stop.png"] forState:UIControlStateSelected];
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *typeimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 290+G_YADDONVERSION, 70, 88)];
    typeimage.image=[UIImage imageNamed:@"sleep_time.png"];
    [self.view addSubview:typeimage];
    
    timeLable=[[UILabel alloc]initWithFrame:CGRectMake(170, 312+G_YADDONVERSION, 150, 40)];
    timeLable.font=[UIFont systemFontOfSize:32];
    timeLable.text=@"00:00:00";
    timeLable.textColor=[UIColor grayColor];
    timeLable.backgroundColor=[UIColor clearColor];
    [self.view addSubview:timeLable];
    
    UIImageView *timeicon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 240+G_YADDONVERSION, 25, 25)];
    timeicon.contentMode=UIViewContentModeScaleAspectFit;
    timeicon.image=[UIImage imageNamed:@"icon_timing.png"];
    [self.view addSubview:timeicon];
    
    labletip=[[UILabel alloc]initWithFrame:CGRectMake(40, 240+G_YADDONVERSION, 200, 25)];
    labletip.text = NSLocalizedString(@"Wait", nil);
    labletip.numberOfLines=0;
    labletip.textColor=[UIColor grayColor];
    labletip.backgroundColor=[UIColor clearColor];
    [self.view addSubview:labletip];
    
    if ([UIScreen mainScreen].bounds.size.height==568) {
        CGRect fr;
        
        startButton.frame=CGRectMake(90,330+G_YADDONVERSION, 63, 63);

        fr=typeimage.frame;
        typeimage.frame=CGRectMake(fr.origin.x, fr.origin.y+30, fr.size.width, fr.size.height);
        
        fr=timeLable.frame;
        
        timeLable.frame=CGRectMake(fr.origin.x, fr.origin.y+30, fr.size.width, fr.size.height);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeNav];
    [self makeAdvise];
    [self makeView];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1]];

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
        [[NSUserDefaults standardUserDefaults] setObject:[currentdate date] forKey:@"timerOn"];
        [[NSUserDefaults standardUserDefaults] setObject:@"sleep" forKey:@"ctl"];
        timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];    }
    else{
        
        [self makeSave];

    }
    
    addRecordBtn.enabled = NO;
}



-(void)timerGo
{
    timeLable.text=[currentdate durationFormat];
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
        saveView=[[save_sleepview alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height)];
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


-(void)environmentOradvise:(UIButton *)sender
{
    sender.enabled=NO;
    sender.titleLabel.textColor=[UIColor whiteColor];
    UIButton *another;
    
    if (sender.tag==501) {
        another=(UIButton*)[self.view viewWithTag:502];
        weather.hidden=NO;
    }
    else
    {
        another=(UIButton*)[self.view viewWithTag:501];
        weather.hidden=YES;
        
    }
    another.enabled=YES;
    another.titleLabel.textColor=[UIColor grayColor];
}

-(IBAction)addrecord:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addsleepnow"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[currentdate date] forKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] setObject:@"sleep" forKey:@"ctl"];
    
    [self makeSave];
}
@end
