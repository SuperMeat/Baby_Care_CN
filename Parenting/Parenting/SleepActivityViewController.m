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
    [summary MenuSelectIndex:3];
    [self.navigationController pushViewController:summary animated:YES];
}


-(void)makeAdvise
{
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"一、把宝宝叫醒\n\r到了喂奶时间，就要把宝宝叫醒。你应该让宝宝晚上能够一觉到天亮，而不是白天睡觉、晚上哭闹。我的做法是，喂奶时间快到时，就把宝宝的房门打开，进去把窗帘拉开，让宝宝慢慢醒过来。如果喂奶时间到了，宝宝还在睡觉，我会把宝宝抱起来，交给喜欢宝宝的人抱一抱，比如孩子的爸爸、爷爷、奶奶或其他亲友，请他们轻轻地叫醒宝宝。他们会轻声跟宝宝说话，亲亲他，或者帮他脱掉几件衣服，让宝宝慢慢地醒过来。",@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"二、喂奶要喂饱\n\r每次喂奶一定要喂饱。喂母乳时，每边各喂10～15分钟。我们常跟宝宝开玩笑说：“这不是吃点心哦。”尽量让宝宝在吃奶时保持清醒。如果宝宝还没吃饱就开始打瞌睡，可以搔搔他的脚底，蹭蹭他的脸颊，或把奶头拔开一段距离。尽量让宝宝吃饱，让他可以撑到下次喂奶的时间。",@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:@"三、努力遵循“喂奶—玩耍—睡觉”的循环模式\n\r白天，不要让宝宝一吃完奶就睡觉。如果你在喂完奶后跟宝宝玩一玩，他会很开心，因为他刚刚吃饱，觉得很满足。等宝宝玩累了再上床，就会睡得比较熟、比较久。下次喂奶时间一到，宝宝醒来时，刚好空腹准备吃奶。\n\r有很多人采用“喂奶—睡觉—玩耍”的循环模式。我认为这样的循环模式会让宝宝醒来时，肚子呈半饥饿状态，不能玩得很开心，宝宝可能还会觉得有点累，因为睡得不熟或时间比较短。宝宝醒来时如果处于半饥饿、半疲倦的状态，一定会哭闹得很厉害，这时妈妈就容易在宝宝尚未空腹的情况下提前喂奶，结果宝宝养成了整天都在吃点心的习惯，这是一个恶性循环。\n\r怎么跟宝宝玩呢?关键是动作一定要很轻。喂完奶，轻轻地帮宝宝拍背打嗝后，就可以跟宝宝说说话，唱歌给宝宝听，看着宝宝的眼睛，摆动宝宝的脚，或者抱着宝宝在家里走一走。我的孩子小的时候，我常让她们趴在毯子上，让她们看看家人在做什么。如果大家在吃饭，我就把宝宝放在饭桌旁(或饭桌上)，宝宝可以看大家吃饭，这时大家当然会忍不住一直看着宝宝，对他微笑，逗他开心。宝宝玩了一阵子之后，会觉得有点累，开始哭闹，这时我就把他放回床上睡觉，等到下次喂奶时间再抱起来。\n\r每天只有最后一次喂完奶(晚上10点或11点左右)，我不会遵循“喂奶—玩耍—睡觉”的模式。经过一整天的活动，宝宝这时已经累了，我会在喂奶之后，小心地帮他拍背打嗝，换上干净的尿布，然后就不再陪他玩了，直接送他上床睡觉。",@"content", nil];
    
    AdviseScrollview *ad=[[AdviseScrollview alloc]initWithArray:[NSArray arrayWithObjects:dict1,dict2,dict3, nil]];
    
    adviseImageView = [[UIImageView alloc] init];
    [adviseImageView setFrame:CGRectMake(0, 480-130, 320, 130)];
    [adviseImageView setBackgroundColor:[ACFunction colorWithHexString:@"#e7e7e7"]];
    adviseImageView.userInteractionEnabled = YES;
    [adviseImageView addSubview:ad];
    [self.view addSubview:adviseImageView];
    
}

-(void)makeView
{
    startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame=CGRectMake(25,200*PNGSCALE, 281*PNGSCALE/2.0, 231*PNGSCALE/2.0);
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_sleeping_play.png"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_sleeping_pause.png"] forState:UIControlStateSelected];
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    timerImage = [[UIImageView alloc]initWithFrame:CGRectMake(320-20-165*PNGSCALE, 150, 165*PNGSCALE, 111*PNGSCALE)];
    [timerImage setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:timerImage];
    
    UIImageView *timeicon=[[UIImageView alloc]initWithFrame:CGRectMake(320-20-165*PNGSCALE, 150, 165*PNGSCALE, 111*PNGSCALE)];
    
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
    
    [[NSUserDefaults standardUserDefaults] setObject:[currentdate date] forKey:@"timerOn"];
    [[NSUserDefaults standardUserDefaults] setObject:@"sleep" forKey:@"ctl"];
    
    [self makeSave];
}
@end
