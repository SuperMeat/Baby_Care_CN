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
        adindoor.hidden = NO;
        adoutdoor.hidden = YES;
    }
    else
    {
        another=(UIButton*)[self.view viewWithTag:101];
        self.weather.hidden= NO;
        _bleweather.hidden = YES;
        adoutdoor.hidden = NO;
        adindoor.hidden  = YES;
    }
    another.enabled=YES;
}

- (void)makeView
{
    chooseIndoor=[UIButton buttonWithType:UIButtonTypeCustom];
    chooseOutdoor=[UIButton buttonWithType:UIButtonTypeCustom];

    chooseOutdoor.frame=CGRectMake((320-140*PNGSCALE*2)/2.0, 90*PNGSCALE-64, 140*PNGSCALE, 25*PNGSCALE);
    chooseIndoor.frame=CGRectMake((320-140*PNGSCALE*2)/2.0+140*PNGSCALE, 90*PNGSCALE-64, 140*PNGSCALE, 25*PNGSCALE);
    [chooseIndoor setBackgroundImage:[UIImage imageNamed:@"label_indoor"] forState:UIControlStateNormal];
    [chooseIndoor setBackgroundImage:[UIImage imageNamed:@"label_indoor_focus"] forState:UIControlStateDisabled];
    chooseIndoor.tag=101;
    chooseIndoor.highlighted=NO;
    [chooseIndoor addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    
    [chooseOutdoor setBackgroundImage:[UIImage imageNamed:@"label_outdoor"] forState:UIControlStateNormal];
    [chooseOutdoor setBackgroundImage:[UIImage imageNamed:@"label_outdoor_focus"] forState:UIControlStateDisabled];
    
    chooseOutdoor.tag = 102;
    chooseOutdoor.highlighted = NO;
    chooseOutdoor.enabled = NO;
    [chooseOutdoor addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:chooseIndoor];
    [self.view addSubview:chooseOutdoor];
    
    if (!ISBLE) {
        chooseIndoor.hidden  = YES;
        chooseOutdoor.hidden = YES;
    }
}

- (void)makeWeatherView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.weather = [WeatherView weatherview];
    [self.weather makeview];
    [self.weather setBackgroundColor:[UIColor whiteColor]];
    self.weather.chooseType = QCM_TYPE_FEED;
    self.weather.frame=CGRectMake(0, 0+90*PNGSCALE-64+2+25*PNGSCALE, 320, frame.size.height-130-64-49);
    [self.view addSubview:self.weather];
    NSLog(@"weather %@",self.weather);

    if (ISBLE) {
        self.bleweather = [BLEWeatherView weatherview];
        self.bleweather.bleweatherDelegate = self;
        self.bleweather.chooseType = QCM_TYPE_FEED;
        [self.bleweather setBackgroundColor:[UIColor whiteColor]];
        [self.bleweather makeview];
        self.bleweather.frame=CGRectMake(0, 0+90*PNGSCALE-64+2+25*PNGSCALE, 320, frame.size.height-130-64-49);
        [self.view addSubview:self.bleweather];
        [self.bleweather setHidden:YES];
        NSLog(@"bleweather %@",self.bleweather);

    }
}

-(void)makeAdvise
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    NSDictionary *dict1=[[NSDictionary alloc]initWithObjectsAndKeys:[self.weather getChuanYiAdvise],@"content", nil];
    NSDictionary *dict2=[[NSDictionary alloc]initWithObjectsAndKeys:[self.weather getOutSideAdvise],@"content", nil];
    NSDictionary *dict3=[[NSDictionary alloc]initWithObjectsAndKeys:[self.weather getHealthAdvise],@"content", nil];
    
    adoutdoor =[[AdviseScrollview alloc]initWithArray:[NSArray arrayWithObjects:dict1,dict2,dict3, nil]];
    NSMutableArray *indoorArray = [[NSMutableArray alloc]initWithCapacity:0];
    AdviseData *temp = [[BLEWeatherView weatherview]getTempAdviseData];
    if (![temp.mContent isEqualToString:@""]) {
        NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:temp.mContent,@"content", nil];

        [indoorArray addObject:tempdic];
    }
    
    AdviseData *humi = [[BLEWeatherView weatherview]getHumiAdviseData];
    if (![humi.mContent isEqualToString:@""]) {
        NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:humi.mContent,@"content", nil];
        
        [indoorArray addObject:tempdic];
    }

    
    AdviseData *light = [[BLEWeatherView weatherview]getLightAdviseData];
    if (![light.mContent isEqualToString:@""]) {
        NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:light.mContent,@"content", nil];
        
       [indoorArray addObject:tempdic];
    }

    
    AdviseData *noice = [[BLEWeatherView weatherview]getNoiceAdviseData];
    if (![noice.mContent isEqualToString:@""]) {
        NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:noice.mContent,@"content", nil];
        [indoorArray addObject:tempdic];
    }

    
    AdviseData *uv = [[BLEWeatherView weatherview]getUVAdviseData];
    if (![uv.mContent isEqualToString:@""]) {
        NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:uv.mContent,@"content", nil];
        
        [indoorArray addObject:tempdic];
    }

    AdviseData *pm25 = [[BLEWeatherView weatherview]getPM25AdviseData];
    if (![pm25.mContent isEqualToString:@""]) {
        NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:pm25.mContent,@"content", nil];
        
        [indoorArray addObject:tempdic];
    }
    
    adindoor=[[AdviseScrollview alloc]initWithArray:indoorArray];

    if (chooseIndoor.enabled) {
        adindoor.hidden  = YES;
        adoutdoor.hidden = NO;
    }
    else
    {
        adindoor.hidden  = NO;
        adoutdoor.hidden = YES;
    }
    
    adviseImageView = [[UIImageView alloc] init];

    [adviseImageView setFrame:CGRectMake(0, frame.size.height-130-64-49, 320, 130)];
    [adviseImageView setBackgroundColor:[ACFunction colorWithHexString:@"#f6f6f6"]];
    adviseImageView.userInteractionEnabled = YES;
    [adviseImageView addSubview:adindoor];
    [adviseImageView addSubview:adoutdoor];
    [self.view addSubview:adviseImageView];
    
    UIImageView *addIamge = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-130-64-49+5, 156/2.0, 230/2.0)];
    [addIamge setImage:[UIImage imageNamed:@"挂饰"]];
    [self.view addSubview:addIamge];

    UIImageView *cutline = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-130-64-49, 320, 10)];
    [cutline setImage:[UIImage imageNamed:@"分界线"]];
    [self.view addSubview:cutline];
    
    UIImageView *addIamge2 = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-216/2.0, frame.size.height-76/2.0-49-64, 216/2.0, 76/2.0)];
    [addIamge2 setImage:[UIImage imageNamed:@"小火车"]];
    [self.view addSubview:addIamge2];

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

#pragma -mark bleweatherdelegate
-(void)UpdateWeatherTemp:(AdviseData*)tempdata andHumiData:(AdviseData*)humidata andUVData:(AdviseData*)uvdata andPM25Data:(AdviseData*)pmdata andLightData:(AdviseData *)lightdata andNoiceData:(AdviseData *)noicedata
{
    [adindoor removeFromSuperview];
    NSMutableArray *indoorArray = [[NSMutableArray alloc]initWithCapacity:0];
    if (![tempdata.mContent isEqualToString:@""]) {
        NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:tempdata.mContent,@"content", nil];
        
        [indoorArray addObject:tempdic];
    }
    
    if (![humidata.mContent isEqualToString:@""]) {
        NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:humidata.mContent,@"content", nil];
        
        [indoorArray addObject:tempdic];
    }
    
    if (![lightdata.mContent isEqualToString:@""]) {
        NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:lightdata.mContent,@"content", nil];
        
        [indoorArray addObject:tempdic];
    }
    
    if (![noicedata.mContent isEqualToString:@""]) {
        NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:noicedata.mContent,@"content", nil];
        
        [indoorArray addObject:tempdic];
    }
    
    if (![uvdata.mContent isEqualToString:@""]) {
        NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:uvdata.mContent,@"content", nil];
        
        [indoorArray addObject:tempdic];
    }
    
    if (![pmdata.mContent isEqualToString:@""]) {
        NSDictionary *tempdic=[[NSDictionary alloc]initWithObjectsAndKeys:pmdata.mContent,@"content", nil];
        
        [indoorArray addObject:tempdic];
    }
    


    adindoor=[[AdviseScrollview alloc]initWithArray:indoorArray];

    [adviseImageView addSubview:adindoor];
    if (adoutdoor.hidden) {
        adindoor.hidden = NO;
    }
    else
    {
        adindoor.hidden = YES;
    }
}
@end
