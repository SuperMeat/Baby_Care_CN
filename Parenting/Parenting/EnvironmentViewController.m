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
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:[self.weather getChuanYiAdvise],@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:[self.weather getOutSideAdvise],@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:[self.weather getHealthAdvise],@"content", nil];
    
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
