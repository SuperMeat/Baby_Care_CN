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

-(void)makeView
{

    startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    startButton.bounds=CGRectMake(0, 0, 100, 28);
    startButton.center=CGPointMake(160, 370*PNGSCALE);
    [startButton setTitle:NSLocalizedString(@"Submit",nil) forState:UIControlStateNormal];
    [startButton setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    startButton.layer.cornerRadius = 5.0f;
    [self.view addSubview:startButton];
    [startButton addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dry=[UIButton buttonWithType:UIButtonTypeCustom];
    dry.frame=CGRectMake(17, 150+G_YADDONVERSION, 189/2.0, 189/2.0);
    [dry setBackgroundImage:[UIImage imageNamed:@"icon_dry"] forState:UIControlStateNormal];
    [dry setBackgroundImage:[UIImage imageNamed:@"icon_dry_choose"] forState:UIControlStateDisabled];
    [self.view addSubview:dry];
    dry.tag=201;
    [dry addTarget:self action:@selector(Activityselected:) forControlEvents:UIControlEventTouchUpInside];
    [self Activityselected:dry];
    
    UIButton *wet=[UIButton buttonWithType:UIButtonTypeCustom];
    wet.frame=CGRectMake(160-45, 150+G_YADDONVERSION, 189/2.0, 189/2.0);
    [wet setBackgroundImage:[UIImage imageNamed:@"icon_wet"] forState:UIControlStateNormal];
    [wet setBackgroundImage:[UIImage imageNamed:@"icon_wet_choose"] forState:UIControlStateDisabled];
    [self.view addSubview:wet];
    wet.tag=202;
    [wet addTarget:self action:@selector(Activityselected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dirty=[UIButton buttonWithType:UIButtonTypeCustom];
    dirty.frame=CGRectMake(320-17-90, 150+G_YADDONVERSION, 189/2.0, 189/2.0);
    [dirty setBackgroundImage:[UIImage imageNamed:@"icon_dirty"] forState:UIControlStateNormal];
    [dirty setBackgroundImage:[UIImage imageNamed:@"icon_dirty_choose"] forState:UIControlStateDisabled];
    [self.view addSubview:dirty];
    dirty.tag=203;
    [dirty addTarget:self action:@selector(Activityselected:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)Activityselected:(UIButton*)sender
{
    sender.enabled=NO;
    
    UIButton *another1,*another2;
    if (sender.tag==201) {
        another1=(UIButton*)[self.view viewWithTag:202];
        
        another2=(UIButton*)[self.view viewWithTag:203];
        self.status=@"Dry";
        
    }
    else if(sender.tag==202)
    {
        another1=(UIButton*)[self.view viewWithTag:201];
        another2=(UIButton*)[self.view viewWithTag:203];
        self.status=@"Wet";
    }
    else
    {
        another1=(UIButton*)[self.view viewWithTag:201];
        another2=(UIButton*)[self.view viewWithTag:202];
        self.status=@"Dirty";
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
        [saveView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+SAVEVIEW_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height)];
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

@end
