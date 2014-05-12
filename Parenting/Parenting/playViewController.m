//
//  playViewController.m
//  Parenting
//
//  Created by user on 13-5-23.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "playViewController.h"

@interface playViewController ()

@end

@implementation playViewController
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
    [MobClick beginLogPageView:@"玩耍"];
    
    if (startButton != nil) {
        startButton.enabled = YES;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"timerOn"]&&[[[NSUserDefaults standardUserDefaults] objectForKey:@"ctl"] isEqualToString:@"play"]) {
        labletip.text = NSLocalizedString(@"Counting", nil);       startButton.selected=YES;
        addRecordBtn.enabled = NO;
        //timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
        //
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

}

-(void)viewWillDisappear:(BOOL)animated
{
    [saveView removeFromSuperview];
    self.hidesBottomBarWhenPushed = YES;
    [MobClick endLogPageView:@"玩耍"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"addplaynow"]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addplaynow"];
    }
    [timer invalidate];
}

+(id)shareViewController
{

    static dispatch_once_t pred = 0;
    __strong static playViewController* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(void)makeNav
{
    //self.navigationItem.title=NSLocalizedString(@"Play", nil);
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:NSLocalizedString(@"Play", nil)];
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
    [summary MenuSelectIndex:0];
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

-(void)makeView
{
    startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame=CGRectMake(40,180*PNGSCALE, 281*PNGSCALE/2.0, 253*PNGSCALE/2.0);
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_playing_play.png"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_playing_pause.png"] forState:UIControlStateSelected];
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    timerImage = [[UIImageView alloc]initWithFrame:CGRectMake(320-20-165*PNGSCALE, 150, 165*PNGSCALE, 111*PNGSCALE)];
    [timerImage setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:timerImage];
    
    UIImageView *timeicon=[[UIImageView alloc]initWithFrame:CGRectMake(140, 150, 165*PNGSCALE, 111*PNGSCALE)];
    
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeNav];
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
        labletip.text = NSLocalizedString(@"Counting", nil);        sender.selected=YES;
        [[NSUserDefaults standardUserDefaults] setObject:[ACDate date] forKey:@"timerOn"];
        [[NSUserDefaults standardUserDefaults] setObject:@"play" forKey:@"ctl"];
        timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
    }
    else{
        
        [self makeSave];

    }
    addRecordBtn.enabled = NO;
}

-(void)timerGo
{
    timeLable.text=[ACDate durationFormat];
    NSLog(@"timerGo:%@", timeLable.text);
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

-(void)stop
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
    [timer invalidate];
    timeLable.text=@"00:00:00";
    startButton.selected=NO;
    startButton.enabled = YES;
}
-(void)makeSave
{

    if (saveView==nil) {
        saveView=[[save_playview alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height) ];
    }
    [saveView loaddata];
    [self.view addSubview:saveView];
    startButton.enabled = NO;
    
}
-(void)stop:(NSNotification*)noti
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
    NSLog(@"stop:removeObjectForKey");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addplaynow"];
    [timer invalidate];
    timeLable.text=@"00:00:00";
    startButton.selected=NO;
    [saveView removeFromSuperview];
    NSNumber *dur=noti.object;
    labletip.text=[NSString stringWithFormat:NSLocalizedString(@"Over", nil),[dur floatValue]/3600];
    startButton.enabled = YES;
    addRecordBtn.enabled = YES;

}
-(void)cancel
{
    //[saveView removeFromSuperview];
    startButton.enabled = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"addplaynow"]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timerOn"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ctl"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"addplaynow"];
    }
}

-(IBAction)addrecord:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addplaynow"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[ACDate date] forKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] setObject:@"play" forKey:@"ctl"];
    
    [self makeSave];
}

@end
