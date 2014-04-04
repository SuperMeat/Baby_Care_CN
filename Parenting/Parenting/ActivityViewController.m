//
//  ActivityViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-31.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "ActivityViewController.h"
#import "AdviseMasterViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"活动"];
    }
    return self;
}

#pragma -mark button press 
- (void)showSummary
{
    NSLog(@"show Summary!");
    SummaryViewController *summary = [SummaryViewController summary];
    [summary MenuSelectIndex:1];
    [self.navigationController pushViewController:summary animated:YES];
}

- (void)showAdvise
{
    NSLog(@"show Advise!");
    AdviseMasterViewController *tipsMasterViewController = [[AdviseMasterViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:tipsMasterViewController animated:YES];
}

- (void)goToDailyActivity:(UIButton*)button
{
    NSLog(@"go to activity:%d!", button.tag);
    
    switch (button.tag) {
        case QCM_TYPE_PLAY:
        {
            playViewController *play=[playViewController shareViewController];
            play.summary = [SummaryViewController summary];
            [self.navigationController pushViewController:play animated:YES];
        }
            break;
        case QCM_TYPE_BATH:
        {
            bathViewController *bath=[bathViewController shareViewController];
            bath.summary = [SummaryViewController summary];
            [self.navigationController pushViewController:bath animated:YES];
        }
            break;
        case QCM_TYPE_FEED:
        {
            feedViewController *feed =[feedViewController shareViewController];
            feed.summary = [SummaryViewController summary];
            [self.navigationController pushViewController:feed animated:YES];
        }
            break;
        case QCM_TYPE_DIAPER:
        {
            diaperViewController *diaper=[diaperViewController shareViewController];
            diaper.summary = [SummaryViewController summary];
            [self.navigationController pushViewController:diaper animated:YES];
        }
            break;
        case QCM_TYPE_SLEEP:
        {
            sleepViewController *sleep=[sleepViewController shareViewController];
            sleep.summary = [SummaryViewController summary];          [self.navigationController pushViewController:sleep animated:YES];
        }break;
        default:
            break;
    }
}


- (void)initView
{
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:ac_title];
    [titleView addSubview:titleText];
    
    self.activityImageView = [[UIImageView alloc] init];
    [self.activityImageView setFrame:CGRectMake(0, 0, 320, 334*PNGSCALE)];
    [self.activityImageView setBackgroundColor:[ACFunction colorWithHexString:@"#68bfcc"]];
    
    [self.activityImageView addSubview:titleView];
    
    [self.view addSubview:self.activityImageView];
    
    //总结跟建议
    self.btnSummary = [[UIButton alloc] init];
    self.btnSummary.frame = CGRectMake(10, 22, 40, 40);
    [self.btnSummary setImage:[UIImage imageNamed:@"btn_sum1"] forState:UIControlStateNormal];
    [self.btnSummary addTarget:self action:@selector(showSummary) forControlEvents:UIControlEventTouchUpInside];
    
    [self.activityImageView addSubview:self.btnSummary];
    
    self.btnAdvise = [[UIButton alloc] init];
    self.btnAdvise.frame = CGRectMake(320-10-40,22, 40, 40);
    [self.btnAdvise setImage:[UIImage imageNamed:@"btn_sum2"] forState:UIControlStateNormal];
    [self.activityImageView addSubview:self.btnAdvise];
    [self.btnAdvise addTarget:self action:@selector(showAdvise) forControlEvents:UIControlEventTouchUpInside];

    //入口按钮
    self.btnFeed = [[UIButton alloc] init];
    self.btnFeed.frame = CGRectMake(320/2-36*PNGSCALE, 70, 72*PNGSCALE, 72*PNGSCALE);
    [self.btnFeed setImage:[UIImage imageNamed:@"icon_feeding"] forState:UIControlStateNormal];
    [self.activityImageView setUserInteractionEnabled:YES];
    [self.activityImageView addSubview:self.btnFeed];
    self.btnFeed.tag = QCM_TYPE_FEED;
    [self.btnFeed addTarget:self action:@selector(goToDailyActivity:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnBath = [[UIButton alloc] init];
    self.btnBath.frame = CGRectMake(320/4-36*PNGSCALE, 70+54*PNGSCALE, 72*PNGSCALE, 72*PNGSCALE);
    [self.btnBath setImage:[UIImage imageNamed:@"icon_bath"] forState:UIControlStateNormal];
    [self.activityImageView addSubview:self.btnBath];
    self.btnBath.tag = QCM_TYPE_BATH;
    [self.btnBath addTarget:self action:@selector(goToDailyActivity:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPlay = [[UIButton alloc] init];
    self.btnPlay.frame = CGRectMake(320*3/4-36*PNGSCALE, 70+54*PNGSCALE, 72*PNGSCALE, 72*PNGSCALE);
    [self.btnPlay setImage:[UIImage imageNamed:@"icon_playing"] forState:UIControlStateNormal];
    [self.activityImageView addSubview:self.btnPlay];
    self.btnPlay.tag = QCM_TYPE_PLAY;
    [self.btnPlay addTarget:self action:@selector(goToDailyActivity:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnSleep = [[UIButton alloc] init];
    self.btnSleep.frame = CGRectMake(320.0/3.0-72*PNGSCALE/2.0, 70+26*PNGSCALE+54*PNGSCALE+72*PNGSCALE, 72*PNGSCALE, 72*PNGSCALE);
    [self.btnSleep setImage:[UIImage imageNamed:@"icon_sleeping"] forState:UIControlStateNormal];
    [self.activityImageView addSubview:self.btnSleep];
    self.btnSleep.tag = QCM_TYPE_SLEEP;
    [self.btnSleep addTarget:self action:@selector(goToDailyActivity:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnDiaper = [[UIButton alloc] init];
    self.btnDiaper.frame = CGRectMake(320.0/3.0*2-72*PNGSCALE/2.0, 70+26*PNGSCALE+54*PNGSCALE+72*PNGSCALE, 72*PNGSCALE, 72*PNGSCALE);
    [self.btnDiaper setImage:[UIImage imageNamed:@"icon_diapers"] forState:UIControlStateNormal];
    [self.activityImageView addSubview:self.btnDiaper];
    self.btnDiaper.tag = QCM_TYPE_DIAPER;
    [self.btnDiaper addTarget:self action:@selector(goToDailyActivity:) forControlEvents:UIControlEventTouchUpInside];
    
    datatable = [[UITableView alloc] init];
    datatable.frame = CGRectMake(0, 334*PNGSCALE, 320, 62*PNGSCALE);
    datatable.transform = CGAffineTransformRotate(CGAffineTransformIdentity,(M_PI/-2));
    datatable.frame = CGRectMake(0, 334*PNGSCALE, 320, 62*PNGSCALE);
    datatable.delegate   = self;
    datatable.dataSource = self;
    datatable.showsVerticalScrollIndicator = NO;
    datatable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:datatable];

    UIImageView *statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(160-135*PNGSCALE, 334*PNGSCALE+15+62*PNGSCALE, 269*PNGSCALE, 80*PNGSCALE)];
    [statusImageView setBackgroundColor:[ACFunction colorWithHexString:@"#e7e7e7"]];
    statusImageView.layer.masksToBounds = YES;
    statusImageView.layer.cornerRadius = 8.0;
    [self.view addSubview:statusImageView];
    
    labelText = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, statusImageView.frame.size.width-20, statusImageView.frame.size.height)];
    labelText.numberOfLines = 0;
    labelText.font = [UIFont fontWithName:@"Arial" size:17];
    [statusImageView addSubview:labelText];
    // 没有记录
    int i = 3;
    if (i == 1) {
        labelText.text = NORECORDTIP;
    }
    else if (i == 2)
    {
        labelText.text = @"十分钟前陪宝宝玩耍了!";
    }
    else
    {
        labelText.text  = @"正在玩耍...";
        labelText.frame = CGRectMake(10, 8, statusImageView.frame.size.width-20, 20);
        UILabel *timeTip = [[UILabel alloc]initWithFrame:CGRectMake(10, 20+8+3, statusImageView.frame.size.width-20,  statusImageView.frame.size.height-20-20)];
        timeTip.text = @"00:10:23";
        timeTip.textAlignment = NSTextAlignmentCenter;
        timeTip.textColor = [ACFunction colorWithHexString:@"#323232"];
        timeTip.backgroundColor = [UIColor clearColor];
        timeTip.font = [UIFont fontWithName:@"Arial" size:30];
        [statusImageView addSubview:timeTip];
    }
    
    labelText.textAlignment = NSTextAlignmentCenter;
    
    labelText.textColor = [ACFunction colorWithHexString:@"#565656"];
    [labelText setBackgroundColor:[UIColor clearColor]];

    [self.view addSubview:statusImageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<12; i++) {
        ActivityItem *item=[[ActivityItem alloc]init];
        item.starttime=[ACDate date];
        if (i % 2 == 0) {
            item.type = @"Bath";
        }
        else if (i % 3 == 0) {
            item.type = @"Play";
        }
        else
        {
            item.type=@"Diaper";
        }
        [array addObject:item];
    }
    dataArray = array;
    [self initView];
    [self.view  setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataArray.count>12) {
        return 12;
    }
    return dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section>=dataArray.count-1||section>=11) {
        return 1;
    }
    else
    {
        return 2;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"History";
    if(indexPath.row==0)
    {
        UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"History"];
        if (Cell==nil) {
            Cell=[[[NSBundle mainBundle] loadNibNamed:@"DataCustomCell" owner:self options:nil] objectAtIndex:0];
        }
        UIButton *button=(UIButton*)[Cell viewWithTag:100001];
        UILabel *lable=(UILabel*)[Cell viewWithTag:200001];
        button.contentMode=UIViewContentModeScaleAspectFit;
        
        ActivityItem *item=[dataArray objectAtIndex:indexPath.section];
        if ([item.type isEqualToString:@"Feed"]) {
            [button setImage:[UIImage imageNamed:@"recent_records_feeding"] forState:UIControlStateDisabled];
        }
        else if([item.type isEqualToString:@"Diaper"])
        {
            [button setImage:[UIImage imageNamed:@"recent_records_diapers"] forState:UIControlStateDisabled];
        }
        else if([item.type isEqualToString:@"Sleep"])
        {
            [button setImage:[UIImage imageNamed:@"recent_records_sleeping"] forState:UIControlStateDisabled];
        }
        else if([item.type isEqualToString:@"Play"])
        {
            [button setImage:[UIImage imageNamed:@"recent_records_playing"] forState:UIControlStateDisabled];
        }
        else
        {
            [button setImage:[UIImage imageNamed:@"recent_records_bath"] forState:UIControlStateDisabled];
        }
        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
        [formater setDateFormat:@"HH:mm"];
        lable.text=[formater stringFromDate:item.starttime];
        [Cell.contentView bringSubviewToFront:button];
        Cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        return Cell;
    }
    else
    {
        UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"History1"];
        if (Cell==nil) {
            Cell=[[[NSBundle mainBundle] loadNibNamed:@"DataCustomCell" owner:self options:nil] objectAtIndex:1];
        }
        
        Cell.contentView.transform = CGAffineTransformMakeRotation(M_PI/2);
        return Cell;
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 60*PNGSCALE;
    }
    else
    {
        return 36*PNGSCALE;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
