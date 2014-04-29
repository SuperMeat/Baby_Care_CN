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
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"一、把宝宝叫醒\n\r到了喂奶时间，就要把宝宝叫醒。你应该让宝宝晚上能够一觉到天亮，而不是白天睡觉、晚上哭闹。我的做法是，喂奶时间快到时，就把宝宝的房门打开，进去把窗帘拉开，让宝宝慢慢醒过来。如果喂奶时间到了，宝宝还在睡觉，我会把宝宝抱起来，交给喜欢宝宝的人抱一抱，比如孩子的爸爸、爷爷、奶奶或其他亲友，请他们轻轻地叫醒宝宝。他们会轻声跟宝宝说话，亲亲他，或者帮他脱掉几件衣服，让宝宝慢慢地醒过来。",@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"二、喂奶要喂饱\n\r每次喂奶一定要喂饱。喂母乳时，每边各喂10～15分钟。我们常跟宝宝开玩笑说：“这不是吃点心哦。”尽量让宝宝在吃奶时保持清醒。如果宝宝还没吃饱就开始打瞌睡，可以搔搔他的脚底，蹭蹭他的脸颊，或把奶头拔开一段距离。尽量让宝宝吃饱，让他可以撑到下次喂奶的时间。",@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:@"三、努力遵循“喂奶—玩耍—睡觉”的循环模式\n\r白天，不要让宝宝一吃完奶就睡觉。如果你在喂完奶后跟宝宝玩一玩，他会很开心，因为他刚刚吃饱，觉得很满足。等宝宝玩累了再上床，就会睡得比较熟、比较久。下次喂奶时间一到，宝宝醒来时，刚好空腹准备吃奶。\n\r有很多人采用“喂奶—睡觉—玩耍”的循环模式。我认为这样的循环模式会让宝宝醒来时，肚子呈半饥饿状态，不能玩得很开心，宝宝可能还会觉得有点累，因为睡得不熟或时间比较短。宝宝醒来时如果处于半饥饿、半疲倦的状态，一定会哭闹得很厉害，这时妈妈就容易在宝宝尚未空腹的情况下提前喂奶，结果宝宝养成了整天都在吃点心的习惯，这是一个恶性循环。\n\r怎么跟宝宝玩呢?关键是动作一定要很轻。喂完奶，轻轻地帮宝宝拍背打嗝后，就可以跟宝宝说说话，唱歌给宝宝听，看着宝宝的眼睛，摆动宝宝的脚，或者抱着宝宝在家里走一走。我的孩子小的时候，我常让她们趴在毯子上，让她们看看家人在做什么。如果大家在吃饭，我就把宝宝放在饭桌旁(或饭桌上)，宝宝可以看大家吃饭，这时大家当然会忍不住一直看着宝宝，对他微笑，逗他开心。宝宝玩了一阵子之后，会觉得有点累，开始哭闹，这时我就把他放回床上睡觉，等到下次喂奶时间再抱起来。\n\r每天只有最后一次喂完奶(晚上10点或11点左右)，我不会遵循“喂奶—玩耍—睡觉”的模式。经过一整天的活动，宝宝这时已经累了，我会在喂奶之后，小心地帮他拍背打嗝，换上干净的尿布，然后就不再陪他玩了，直接送他上床睡觉。",@"content", nil];
    
    AdviseScrollview *ad=[[AdviseScrollview alloc]initWithArray:[NSArray arrayWithObjects:dict1,dict2,dict3, nil]];
    
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
    
    
    timerImage = [[UIImageView alloc]initWithFrame:CGRectMake((320-165*PNGSCALE)/2.0, 90*PNGSCALE+20*PNGSCALE, 165*PNGSCALE, 111*PNGSCALE)];
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
    startButton.frame=CGRectMake(40,150*PNGSCALE, 182*PNGSCALE/2.0, 366*PNGSCALE/2.0);
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

}

- (void)pushSummaryView:(id)sender{
    summary = [SummaryViewController summary];
    [summary MenuSelectIndex:2];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:summary animated:YES];
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
        [[NSUserDefaults standardUserDefaults] setObject:@"feed" forKey:@"ctl"];
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
        saveView = [[save_feedview alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height) FeedWay:self.feedWay Breasttype:self.breast];
    }
    saveView.feedway=self.feedWay;
    saveView.breast=self.breast;
    [saveView loaddata];
    
    startButton.enabled = NO;
    startButtonright.enabled = NO;
    startButtonleft.enabled = NO;
    
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
        timerImage.frame = CGRectMake((320-165*PNGSCALE)/2.0, 90*PNGSCALE+20*PNGSCALE, 165*PNGSCALE, 111*PNGSCALE);
        
    }
    else
    {
        another=(UIButton*)[self.view viewWithTag:101];
        self.feedWay=@"bottle";
        feedway.hidden=NO;
        startButton.hidden=NO;
        startButtonleft.hidden=YES;
        startButtonright.hidden=YES;
        timerImage.frame = CGRectMake(140, 150, 165*PNGSCALE, 111*PNGSCALE);
        
    }
    another.enabled=YES;
    self.obj=@"user";
    
}

-(IBAction)addrecord:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addfeednow"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[currentdate date] forKey:@"timerOn"];
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

@end
