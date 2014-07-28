//
//  PHYHistoryViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-7-16.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "PHYHistoryViewController.h"

@interface PHYHistoryViewController ()

@end

@implementation PHYHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self initData];
}

-(void)initView{
    //navigationBar
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:@"身高-历史"];
    [titleView addSubview:titleText];
    self.phyDetailImageView = [[UIImageView alloc] init];
    [self.phyDetailImageView setFrame:CGRectMake(0, 0, 320, 64)];
    [self.phyDetailImageView setBackgroundColor:[ACFunction colorWithHexString:@"#68bfcc"]];
    
    [self.phyDetailImageView addSubview:titleView];
    [self.view addSubview:self.phyDetailImageView];
    [self.phyDetailImageView setUserInteractionEnabled:YES];
    
    _buttonBack = [[UIButton alloc] init];
    _buttonBack.frame = CGRectMake(10, 22, 40, 40);
    _buttonBack.titleLabel.font = [UIFont systemFontOfSize:16];
    [_buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [_buttonBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_phyDetailImageView addSubview:_buttonBack];
    
    //TableView 
    _tableView = [[UITableView alloc]
                   initWithFrame:CGRectMake(0,
                                            64,
                                            self.view.bounds.size.width ,
                                            self.view.bounds.size.height - 64)
                   style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    [self.view addSubview:_tableView];
}

-(void)initData{
    arrDS = @[@[@1405478204,@4.5],@[@1405478304,@5.5]];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrDS count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[_tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int index = indexPath.row;
        NSArray *arrayCurrent = [arrDS objectAtIndex:index];
        
        //时间
        UILabel *labelDate = [[UILabel alloc]init];
        labelDate.frame = CGRectMake(30, 12, 80, 20);
        labelDate.font = [UIFont fontWithName:@"Arial" size:14];
        labelDate.textAlignment = NSTextAlignmentLeft;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:[ACDate getDateFromTimeStamp:[[arrayCurrent objectAtIndex:0] longValue]]];
        labelDate.text = dateString;
        
        //隔断
        UIImageView *sepImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_cutoff.png"]];
        sepImageView1.frame = CGRectMake(130, 10, 1, 23);
        
        //数值
        UILabel *labelType = [[UILabel alloc]init];
        labelType.frame = CGRectMake(153, 12, 30, 20);
        labelType.font = [UIFont fontWithName:@"Arial" size:14];
        labelType.textAlignment = NSTextAlignmentLeft;
        labelType.text = @"体重";

        
        //隔断
        UIImageView *sepImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_cutoff.png"]];
        sepImageView2.frame = CGRectMake(203, 12, 1, 23);
        
        //数值
        UILabel *labelValue = [[UILabel alloc]init];
        labelValue.frame = CGRectMake(220, 12, 40, 20);
        labelValue.font = [UIFont fontWithName:@"Arial" size:14];
        labelValue.textAlignment = NSTextAlignmentRight;
        labelValue.text = @"5.2";
//        [NSString stringWithFormat:@"%@",[arrayCurrent objectAtIndex:1]];
        
        //单位
        UILabel *labelUnit = [[UILabel alloc]init];
        labelUnit.frame = CGRectMake(265, 12, 55, 20);
        labelUnit.font = [UIFont fontWithName:@"Arial" size:14];
        labelUnit.textAlignment = NSTextAlignmentLeft;
        labelUnit.text = @"KG";
        
        [cell addSubview:labelDate];
        [cell addSubview:sepImageView1];
        [cell addSubview:labelType];
        [cell addSubview:sepImageView2];
        [cell addSubview:labelValue];
        [cell addSubview:labelUnit];
    }
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //获取delete ID
        int deleteIndex = indexPath.row;
        //todo delete DB
        
        [arrDS removeObjectAtIndex:deleteIndex];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
