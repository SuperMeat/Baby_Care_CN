//
//  ActivityViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-31.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "ActivityViewController.h"

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
    
    //入口按钮
    self.btnFeed = [[UIButton alloc] init];
    self.btnFeed.frame = CGRectMake(24, 80, 72*PNGSCALE, 72*PNGSCALE);
    [self.btnFeed setImage:[UIImage imageNamed:@"icon_feeding"] forState:UIControlStateNormal];
    [self.activityImageView setUserInteractionEnabled:YES];
    [self.activityImageView addSubview:self.btnFeed];
    
    self.btnBath = [[UIButton alloc] init];
    self.btnBath.frame = CGRectMake(320/2-72*PNGSCALE/2, 80, 72*PNGSCALE, 72*PNGSCALE);
    [self.btnBath setImage:[UIImage imageNamed:@"icon_bath"] forState:UIControlStateNormal];
    [self.activityImageView addSubview:self.btnBath];
    
    self.btnPlay = [[UIButton alloc] init];
    self.btnPlay.frame = CGRectMake(320-24-72*PNGSCALE, 80, 72*PNGSCALE, 72*PNGSCALE);
    [self.btnPlay setImage:[UIImage imageNamed:@"icon_playing"] forState:UIControlStateNormal];
    [self.activityImageView addSubview:self.btnPlay];
    
    
    self.btnSleep = [[UIButton alloc] init];
    self.btnSleep.frame = CGRectMake(320.0/3.0-72*PNGSCALE/2.0, 80+26*PNGSCALE+72*PNGSCALE, 72*PNGSCALE, 72*PNGSCALE);
    [self.btnSleep setImage:[UIImage imageNamed:@"icon_sleeping"] forState:UIControlStateNormal];
    [self.activityImageView addSubview:self.btnSleep];

    self.btnDiaper = [[UIButton alloc] init];
    self.btnDiaper.frame = CGRectMake(320.0/3.0*2-72*PNGSCALE/2.0, 80+26*PNGSCALE+72*PNGSCALE, 72*PNGSCALE, 72*PNGSCALE);
    [self.btnDiaper setImage:[UIImage imageNamed:@"icon_diapers"] forState:UIControlStateNormal];
    [self.activityImageView addSubview:self.btnDiaper];
    

    self.btnSummary = [[UIButton alloc] init];
    self.btnSummary.frame = CGRectMake(69, 80+51*PNGSCALE+72*PNGSCALE+72*PNGSCALE, 51*PNGSCALE, 51*PNGSCALE);
    [self.btnSummary setImage:[UIImage imageNamed:@"btn_sum1"] forState:UIControlStateNormal];
    [self.activityImageView addSubview:self.btnSummary];

    self.btnAdvise = [[UIButton alloc] init];
    self.btnAdvise.frame = CGRectMake(320-69-51*PNGSCALE, 80+51*PNGSCALE+72*PNGSCALE+72*PNGSCALE, 51*PNGSCALE, 51*PNGSCALE);
    [self.btnAdvise setImage:[UIImage imageNamed:@"btn_sum2"] forState:UIControlStateNormal];
    [self.activityImageView addSubview:self.btnAdvise];
    
    datatable = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 480-334-44, 480)];
    datatable.frame = CGRectMake(0, 60, 320, 60);
    datatable.transform = CGAffineTransformRotate(CGAffineTransformIdentity,(M_PI/-2));
    datatable.rowHeight = 80;
    datatable.delegate = self;
    datatable.dataSource = self;
    [self.view addSubview:datatable];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.backgroundColor = [UIColor redColor];
        cell.textLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
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
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
