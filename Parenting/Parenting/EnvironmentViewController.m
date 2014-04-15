//
//  EnvironmentViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-4-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "EnvironmentViewController.h"

@interface EnvironmentViewController ()

@end

@implementation EnvironmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"环境"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"环境"];
    
    if (self.weather) {
        if (self.weather.isHidden == YES) {
            pmintro.hidden = YES;
        }
        else
        {
            pmintro.hidden = NO;
        }
        self.weather.chooseType = QCM_TYPE_FEED;
        [self.weather refreshweather];
    }
    
    if (self.bleweather)
    {
        self.bleweather.chooseType = QCM_TYPE_FEED;
        [self.bleweather refreshweather];
    }

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"环境"];
}

- (void)choose:(UIButton*)sender
{
    sender.enabled=NO;
    UIButton *another=nil;
    if (sender.tag==101) {
        another=(UIButton*)[self.view viewWithTag:102];
        self.weather.hidden= YES;
        _bleweather.hidden = NO;
    }
    else
    {
        another=(UIButton*)[self.view viewWithTag:101];
        self.weather.hidden= NO;
        _bleweather.hidden = YES;
    }
    another.enabled=YES;
}

- (void)makeView
{
    chooseIndoor=[UIButton buttonWithType:UIButtonTypeCustom];
    chooseOutdoor=[UIButton buttonWithType:UIButtonTypeCustom];

    chooseOutdoor.frame=CGRectMake(40, 90*PNGSCALE-64, 140*PNGSCALE, 25*PNGSCALE);
    chooseIndoor.frame=CGRectMake(140*PNGSCALE+40, 90*PNGSCALE-64, 140*PNGSCALE, 25*PNGSCALE);
    [chooseIndoor setBackgroundImage:[UIImage imageNamed:@"label_indoor"] forState:UIControlStateNormal];
    [chooseIndoor setBackgroundImage:[UIImage imageNamed:@"label_indoor_focus"] forState:UIControlStateDisabled];
    chooseIndoor.tag=101;
    chooseIndoor.highlighted=NO;
    [chooseIndoor addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    
    [chooseOutdoor setBackgroundImage:[UIImage imageNamed:@"label_outdoor"] forState:UIControlStateNormal];
    [chooseOutdoor setBackgroundImage:[UIImage imageNamed:@"label_outdoor_focus"] forState:UIControlStateDisabled];
    
    chooseOutdoor.tag=102;
    chooseOutdoor.highlighted=NO;
    chooseOutdoor.enabled = NO;
    [chooseOutdoor addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:chooseIndoor];
    [self.view addSubview:chooseOutdoor];
}

- (void)makeWeatherView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.weather = [WeatherView weatherview];
    [self.weather makeview];
    [self.weather setBackgroundColor:[UIColor whiteColor]];
    self.weather.chooseType = QCM_TYPE_FEED;
    self.weather.frame=CGRectMake(0, 0+90*PNGSCALE-64+5+25*PNGSCALE, 320, frame.size.height-130-64-49);
    [self.view addSubview:self.weather];
    NSLog(@"weather %@",self.weather);
    
    self.bleweather = [BLEWeatherView weatherview];
    self.bleweather.chooseType = QCM_TYPE_FEED;
    [self.bleweather setBackgroundColor:[UIColor whiteColor]];
    [self.bleweather makeview];
    self.bleweather.frame=CGRectMake(0, 0+90*PNGSCALE-64+5+25*PNGSCALE, 320, frame.size.height-130-64-49);
    [self.view addSubview:self.bleweather];
    [self.bleweather setHidden:YES];
    NSLog(@"bleweather %@",self.bleweather);

}
-(void)makeAdvise
{
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:@"一、把宝宝叫醒\n\r到了喂奶时间，就要把宝宝叫醒。你应该让宝宝晚上能够一觉到天亮，而不是白天睡觉、晚上哭闹。我的做法是，喂奶时间快到时，就把宝宝的房门打开，进去把窗帘拉开，让宝宝慢慢醒过来。如果喂奶时间到了，宝宝还在睡觉，我会把宝宝抱起来，交给喜欢宝宝的人抱一抱，比如孩子的爸爸、爷爷、奶奶或其他亲友，请他们轻轻地叫醒宝宝。他们会轻声跟宝宝说话，亲亲他，或者帮他脱掉几件衣服，让宝宝慢慢地醒过来。",@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:@"二、喂奶要喂饱\n\r每次喂奶一定要喂饱。喂母乳时，每边各喂10～15分钟。我们常跟宝宝开玩笑说：“这不是吃点心哦。”尽量让宝宝在吃奶时保持清醒。如果宝宝还没吃饱就开始打瞌睡，可以搔搔他的脚底，蹭蹭他的脸颊，或把奶头拔开一段距离。尽量让宝宝吃饱，让他可以撑到下次喂奶的时间。",@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:@"三、努力遵循“喂奶—玩耍—睡觉”的循环模式\n\r白天，不要让宝宝一吃完奶就睡觉。如果你在喂完奶后跟宝宝玩一玩，他会很开心，因为他刚刚吃饱，觉得很满足。等宝宝玩累了再上床，就会睡得比较熟、比较久。下次喂奶时间一到，宝宝醒来时，刚好空腹准备吃奶。\n\r有很多人采用“喂奶—睡觉—玩耍”的循环模式。我认为这样的循环模式会让宝宝醒来时，肚子呈半饥饿状态，不能玩得很开心，宝宝可能还会觉得有点累，因为睡得不熟或时间比较短。宝宝醒来时如果处于半饥饿、半疲倦的状态，一定会哭闹得很厉害，这时妈妈就容易在宝宝尚未空腹的情况下提前喂奶，结果宝宝养成了整天都在吃点心的习惯，这是一个恶性循环。\n\r怎么跟宝宝玩呢?关键是动作一定要很轻。喂完奶，轻轻地帮宝宝拍背打嗝后，就可以跟宝宝说说话，唱歌给宝宝听，看着宝宝的眼睛，摆动宝宝的脚，或者抱着宝宝在家里走一走。我的孩子小的时候，我常让她们趴在毯子上，让她们看看家人在做什么。如果大家在吃饭，我就把宝宝放在饭桌旁(或饭桌上)，宝宝可以看大家吃饭，这时大家当然会忍不住一直看着宝宝，对他微笑，逗他开心。宝宝玩了一阵子之后，会觉得有点累，开始哭闹，这时我就把他放回床上睡觉，等到下次喂奶时间再抱起来。\n\r每天只有最后一次喂完奶(晚上10点或11点左右)，我不会遵循“喂奶—玩耍—睡觉”的模式。经过一整天的活动，宝宝这时已经累了，我会在喂奶之后，小心地帮他拍背打嗝，换上干净的尿布，然后就不再陪他玩了，直接送他上床睡觉。",@"content", nil];
    
    AdviseScrollview *ad=[[AdviseScrollview alloc]initWithArray:[NSArray arrayWithObjects:dict1,dict2,dict3, nil]];
    
    adviseImageView = [[UIImageView alloc] init];
    CGRect frame = [[UIScreen mainScreen] bounds];
    [adviseImageView setFrame:CGRectMake(0, frame.size.height-130-64-49, 320, 130)];
    [adviseImageView setBackgroundColor:[ACFunction colorWithHexString:@"#e7e7e7"]];
    adviseImageView.userInteractionEnabled = YES;
    [adviseImageView addSubview:ad];
    [self.view addSubview:adviseImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeView];
    [self makeWeatherView];
    [self makeAdvise];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
