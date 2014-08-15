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
    [titleText setText:[NSString stringWithFormat:@"%@-历史",itemName]];
    [titleView addSubview:titleText];
    self.phyDetailImageView = [[UIImageView alloc] init];
    [self.phyDetailImageView setFrame:CGRectMake(0, 0, 320, 64)];
    [self.phyDetailImageView setBackgroundColor:[ACFunction colorWithHexString:@"#68bfcc"]];
    
    [self.phyDetailImageView addSubview:titleView];
    [self.view addSubview:self.phyDetailImageView];
    [self.phyDetailImageView setUserInteractionEnabled:YES];
    
    _buttonBack = [[UIButton alloc] init];
    _buttonBack.frame = CGRectMake(10, 22, 40, 40);
    _buttonBack.titleLabel.font = [UIFont systemFontOfSize:14];
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
    //身高0 体重1 BMI2 头围3 体温4
    arrDS = [[NSMutableArray alloc]initWithArray:[[BabyDataDB babyinfoDB] selectBabyPhysiologyList:itemType]];
    [_tableView reloadData];
}

-(void)setType:(int)Type{
    itemType =Type;
    switch (itemType) {
        case 0:
            itemName = @"身高";
            itemUnit = @"CM";
            break;
        case 1:
            itemName = @"体重";
            itemUnit = @"KG";
            break;
        case 2:
            //itemName = @"BMI";
            break;
        case 3:
            itemName = @"头围";
            itemUnit = @"CM";
            break;
        case 4:
            itemName = @"体温";
            itemUnit = @"°C";
            break;
        default:
            break;
    }

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
        NSDictionary *dictCurrent = [arrDS objectAtIndex:index];
        
        //时间
        UILabel *labelDate = [[UILabel alloc]init];
        labelDate.frame = CGRectMake(30, 12, 80, 20);
        labelDate.font = [UIFont fontWithName:@"Arial" size:14];
        labelDate.textAlignment = NSTextAlignmentLeft;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if (itemType != 4) {
            NSString *dateString = [dateFormatter stringFromDate:[ACDate getDateFromTimeStamp:[[dictCurrent objectForKey:@"measure_time"] longValue]]];
            labelDate.text = dateString;
        }
        else{
            labelDate.text = [ACDate dateDetailFomatdate2:[ACDate getDateFromTimeStamp:[[dictCurrent objectForKey:@"measure_time"] longValue]]];
        }
        
        //隔断
        UIImageView *sepImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_cutoff.png"]];
        sepImageView1.frame = CGRectMake(130, 10, 1, 23);
        
        //数值
        UILabel *labelType = [[UILabel alloc]init];
        labelType.frame = CGRectMake(153, 12, 30, 20);
        labelType.font = [UIFont fontWithName:@"Arial" size:14];
        labelType.textAlignment = NSTextAlignmentLeft;
        labelType.text = itemName;

        
        //隔断
        UIImageView *sepImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_cutoff.png"]];
        sepImageView2.frame = CGRectMake(203, 12, 1, 23);
        
        //数值
        UILabel *labelValue = [[UILabel alloc]init];
        labelValue.frame = CGRectMake(220, 12, 40, 20);
        labelValue.font = [UIFont fontWithName:@"Arial" size:14];
        labelValue.textAlignment = NSTextAlignmentRight;
        labelValue.text = [NSString stringWithFormat:@"%0.1f",[[dictCurrent objectForKey:@"value"] doubleValue]];
        //单位
        UILabel *labelUnit = [[UILabel alloc]init];
        labelUnit.frame = CGRectMake(265, 12, 55, 20);
        labelUnit.font = [UIFont fontWithName:@"Arial" size:14];
        labelUnit.textAlignment = NSTextAlignmentLeft;
        labelUnit.text = itemUnit;
        
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
        [[BabyDataDB babyinfoDB] deleteBabyPhysiologyByType:itemType andCreateTime:[[[arrDS objectAtIndex:deleteIndex] objectForKey:@"create_time"] longValue]];
        [arrDS removeObjectAtIndex:deleteIndex];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (itemType) {
        case 4:     //体温
            tempSaveView = [[TempSaveView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height-64) Type:@"UPDATE" CreateTime:[[[arrDS objectAtIndex:indexPath.row] objectForKey:@"create_time"]longValue]];
            tempSaveView.TempSaveDelegate = self; 
            [self.view addSubview:tempSaveView];
            break;
        default:
            editPhyViewController = [[EditPhyViewController alloc] init];
            [editPhyViewController setType:itemType];
            [editPhyViewController setCreateTime:[[[arrDS objectAtIndex:indexPath.row] objectForKey:@"create_time"]longValue]];
            [editPhyViewController setMeasureTime:[[[arrDS objectAtIndex:0] objectForKey:@"measure_time"] longValue]];
            [self.navigationController pushViewController:editPhyViewController animated:YES];
            break;
    }
}

#pragma saveview delegate
-(void)sendTempReloadData{
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
