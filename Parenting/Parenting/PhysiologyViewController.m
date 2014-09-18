//
//  PhysiologyViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-24.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "PhysiologyViewController.h"
#import "BabyDataDB.h"

@interface PhysiologyViewController ()

@end

@implementation PhysiologyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [MobClick endLogPageView:@"生理页面"];

}

-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:@"生理页面"];
    self.navigationController.navigationBar.hidden = YES;
    [self initData];
}

-(void)initView{
    //加载navigationBar
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:@"生理"];
    [titleView addSubview:titleText];
    self.physiologyImageView = [[UIImageView alloc] init];
    [self.physiologyImageView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [self.physiologyImageView setBackgroundColor:[ACFunction colorWithHexString:@"#68bfcc"]];
    [self.physiologyImageView addSubview:titleView];
    [self.view addSubview:self.physiologyImageView];
    [self.physiologyImageView setUserInteractionEnabled:YES];
    
    //tableView.frame Height:480
    _scorllView = [[UITableView alloc]
                   initWithFrame:CGRectMake(0,
                                            64,
                                            self.view.bounds.size.width ,
                                            self.view.bounds.size.height - 64)
                   style:UITableViewStyleGrouped];
    _scorllView.dataSource = self;
    _scorllView.delegate = self;
    _scorllView.scrollEnabled = NO;
    _scorllView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _scorllView.bounds.size.width, 0.01f)];
    [self.view addSubview:_scorllView];
}

-(void)initData{
    //arrayPhyItems 描述
    //itemIndex icon title values unit recorddate
    NSArray *arrayHeight = @[@0,@"icon_height.png",@"当前身高",[self getValues:0],[self getIncrease:0],@"CM",[self getRecordDate:0],@"#84c082"];
    NSArray *arrayWeight = @[@1,@"icon_weight.png",@"当前体重",[self getValues:1],[self getIncrease:1],@"KG",[self getRecordDate:1],@"#efc654"];
    NSArray *arrayBMI = @[@2,@"icon_BMI.png",@"当前BMI",[self getValues:2],[self getIncrease:2],@"",[self getRecordDate:2],@"#808fec"];
    NSArray *arrayCRI = @[@3,@"icon_CIR.png",@"当前头围",[self getValues:3],[self getIncrease:3],@"CM",[self getRecordDate:3],@"#69b3e0"];
    NSArray *arrayTemperture = @[@4,@"icon_temperture.png",@"当前体温",[self getValues:4],[self getIncrease:4],@"°C",[self getRecordDate:4],@"#f39998"];
    arrayPhyItems = [[NSMutableArray alloc]initWithObjects:arrayHeight,arrayWeight,arrayBMI,arrayCRI,arrayTemperture,nil];
    [_scorllView reloadData];
}

-(NSString*)getIncrease:(int)index{
    if (index != 2) {
        NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyPhysiologyList:index];
        if ([arrValues count] >= 2) {
            NSDictionary *dict1 = [arrValues objectAtIndex:0];
            NSDictionary *dict2 = [arrValues objectAtIndex:1];
            
            double v1 = [[dict1 objectForKey:@"value"] doubleValue];
            double v2 = [[dict2 objectForKey:@"value"] doubleValue];
            
            if (v1 >= v2) {
                return [NSString stringWithFormat:@"↑%0.1f",v1-v2];
            }else{
                return [NSString stringWithFormat:@"↓%0.1f",v2-v1];
            }
        }
        else{
            return @"";
        }
    }
    else{
        NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyBMIList];
        if ([arrValues count] >= 2) {
            NSDictionary *dict1 = [arrValues objectAtIndex:0];
            NSDictionary *dict2 = [arrValues objectAtIndex:1];
            
            double v1 = [[dict1 objectForKey:@"value"] doubleValue];
            double v2 = [[dict2 objectForKey:@"value"] doubleValue];
            
            if (v1 >= v2) {
                return [NSString stringWithFormat:@"↑%0.1f",v1-v2];
            }else{
                return [NSString stringWithFormat:@"↓%0.1f",v2-v1];
            }
        }
        else{
            return @"";
        }
    }
}

-(NSString*)getValues:(int)index{
    //非BMI
    if (index != 2){
        NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyPhysiologyList:index];
        if ([arrValues count] == 0) {
            return @"--";
        }
        else{
            NSDictionary *dict = [arrValues objectAtIndex:0];
            return [NSString stringWithFormat:@"%0.1f",[[dict objectForKey:@"value"] doubleValue]];
        }
    }else{
        NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyBMIList];
        if ([arrValues count] == 0) {
            return @"--";
        }
        else{
            NSDictionary *dict = [arrValues objectAtIndex:0];
            return [NSString stringWithFormat:@"%0.1f",[[dict objectForKey:@"value"] doubleValue]];
        }
    }
    
}

-(NSString*)getRecordDate:(int)index{
    //非BMI
    if (index != 2){
        NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyPhysiologyList:index];
        if ([arrValues count] > 0) {
            NSDictionary *dict = [arrValues objectAtIndex:0];
            NSDate *date = [ACDate getDateFromTimeStamp:[[dict objectForKey:@"measure_time"] longValue]];
            return [ACDate getDaySinceDate:date];
        }
        else{
            return @"尚无记录";
        }
    }
    else{
        NSArray *arrValues = [[BabyDataDB babyinfoDB] selectBabyBMIList];
        if ([arrValues count] > 0) {
            NSDictionary *dict = [arrValues objectAtIndex:0];
            NSDate *date = [ACDate getDateFromTimeStamp:[[dict objectForKey:@"measure_time"] longValue]];
            return [ACDate getDaySinceDate:date];
        }
        else{
            return @"尚无记录";
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return [arrayPhyItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIndentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[_scorllView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        int index = indexPath.row;
        NSArray *arrayCurrent = [arrayPhyItems objectAtIndex:index];
        
        UIImageView *imageViewIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[arrayCurrent objectAtIndex:1]]];
        imageViewIcon.frame = CGRectMake(10, 10, 45, 45);
        
        UILabel *labelTitle = [[UILabel alloc]init];
        labelTitle.frame = CGRectMake(75, 15, 80, 20);
        labelTitle.font = [UIFont fontWithName:@"Arial" size:14];
        labelTitle.textAlignment = NSTextAlignmentLeft;
        labelTitle.text = [arrayCurrent objectAtIndex:2];
        
        UILabel *labelValue = [[UILabel alloc]init];
        labelValue.frame = CGRectMake(75, 35, 55, 20);
        labelValue.font = [UIFont fontWithName:@"Arial" size:14];
        labelValue.textColor = [ACFunction colorWithHexString:[arrayCurrent objectAtIndex:7]];
        labelValue.textAlignment = NSTextAlignmentLeft;
        labelValue.text = [NSString stringWithFormat:@"%@ %@",[arrayCurrent objectAtIndex:3],[arrayCurrent objectAtIndex:5]];
        
        UILabel *labelRecordDate = [[UILabel alloc]init];
        labelRecordDate.frame = CGRectMake(165, 35, 80, 20);
        labelRecordDate.font = [UIFont fontWithName:@"Arial" size:14];
        labelRecordDate.textColor = [ACFunction colorWithHexString:[arrayCurrent objectAtIndex:7]];
        labelRecordDate.textAlignment = NSTextAlignmentLeft;
        labelRecordDate.text = [arrayCurrent objectAtIndex:6];
        
        //获取labelValue真实长度
        CGSize valueSize = [labelValue.text sizeWithFont:labelValue.font constrainedToSize:CGSizeMake(FLT_MAX,FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel *labelIncrease = [[UILabel alloc]init];
        labelIncrease.frame = CGRectMake(75 + valueSize.width + 2, 30, 40, 20);
        labelIncrease.font = [UIFont fontWithName:@"Arial" size:10];
        if ([[arrayCurrent objectAtIndex:4] length] > 0 ) {
            if ([[[arrayCurrent objectAtIndex:4] substringToIndex:1] isEqualToString:@"↑"]) {
                labelIncrease.textColor = [UIColor greenColor];
            }
            else{
                labelIncrease.textColor = [UIColor redColor];
            }
        }
        
        labelIncrease.textAlignment = NSTextAlignmentLeft;
        labelIncrease.text = [arrayCurrent objectAtIndex:4];
        
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell addSubview:imageViewIcon];
        [cell addSubview:labelTitle];
        [cell addSubview:labelValue];
        [cell addSubview:labelRecordDate];
        [cell addSubview:labelIncrease];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        //选中体温
        tempDetailViewController = [[TempDetailViewController alloc] init];
        [tempDetailViewController setVar:[arrayPhyItems objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:tempDetailViewController animated:YES];
    }
    //BMI
    //else if (indexPath.row ==2) {}
    else {
        //选中其他
        pHYDetailViewController = [[PHYDetailViewController alloc] init];
        [pHYDetailViewController setVar:[arrayPhyItems objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:pHYDetailViewController animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
