//
//  PHYHistoryViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-7-16.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "PHYHistoryViewController.h"
#import "PHYTableViewCell.h"
#import "BMITableViewCell.h"

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
    [titleText setText:@"记录列表"];
    [titleView addSubview:titleText];
    self.phyDetailImageView = [[UIImageView alloc] init];
    [self.phyDetailImageView setFrame:CGRectMake(0, 0, 320, 64)];
    [self.phyDetailImageView setBackgroundColor:[ACFunction colorWithHexString:@"#68bfcc"]];
    
    [self.phyDetailImageView addSubview:titleView];
    [self.view addSubview:self.phyDetailImageView];
    [self.phyDetailImageView setUserInteractionEnabled:YES];
    
    _buttonBack = [[UIButton alloc] init];
    _buttonBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonBack setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    _buttonBack.frame = CGRectMake(0, 22, 50, 41);
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
    if (itemType != 2) {
        arrDS = [[NSMutableArray alloc]initWithArray:[[BabyDataDB babyinfoDB] selectBabyPhysiologyList:itemType]];
    }
    else{
        arrDS = [[NSMutableArray alloc] initWithArray:[[BabyDataDB babyinfoDB] selectBabyBMIList]];
    }
    
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
    //身高、体重、头围、体温CELL
    int index = indexPath.row;
    NSDictionary *dictCurrent = [arrDS objectAtIndex:index];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    if (itemType != 2) {
        PHYTableViewCell *cell = (PHYTableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:@"PHYTableViewCell"];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PHYTableViewCell" owner:[PHYTableViewCell class] options:nil];
            cell = (PHYTableViewCell *)[nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (itemType != 4) {
                NSString *dateString = [dateFormatter stringFromDate:[ACDate getDateFromTimeStamp:[[dictCurrent objectForKey:@"measure_time"] longValue]]];
                cell.labelDate.text = dateString;
            }
            else{
                cell.labelDate.text = [ACDate dateDetailFomatdate2:[ACDate getDateFromTimeStamp:[[dictCurrent objectForKey:@"measure_time"] longValue]]];
            }
            
            cell.labelDate.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
            cell.labelType.text = itemName;
            cell.labelType.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
            cell.labelValue.text = [NSString stringWithFormat:@"%0.1f",[[dictCurrent objectForKey:@"value"] doubleValue]];
            cell.labelValue.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
            cell.labelUnit.text = itemUnit;
            cell.labelUnit.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
        }
        return cell;
    }
    else{
        BMITableViewCell *cell = (BMITableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:@"BMITableViewCell"];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BMITableViewCell" owner:[BMITableViewCell class] options:nil];
            cell = (BMITableViewCell *)[nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.labelBMIValue.text = [NSString stringWithFormat:@"%0.1f",[[dictCurrent objectForKey:@"value"] doubleValue]];
            cell.labelBMIValue.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
            
            cell.labelHeightDate.text = [dateFormatter stringFromDate:[ACDate getDateFromTimeStamp:[[dictCurrent objectForKey:@"h_measure_time"] longValue]]];
            cell.labelHeightDate.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
            cell.labelWeightDate.text = [dateFormatter stringFromDate:[ACDate getDateFromTimeStamp:[[dictCurrent objectForKey:@"w_measure_time"] longValue]]];
            cell.labelWeightDate.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
            cell.labelHeightValue.text = [NSString stringWithFormat:@"%0.1f",[[dictCurrent objectForKey:@"h_value"] doubleValue]];
            cell.labelHeightValue.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
            cell.labelWeightValue.text = [NSString stringWithFormat:@"%0.1f",[[dictCurrent objectForKey:@"w_value"] doubleValue]];
            cell.labelWeightValue.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
        }
        return cell;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (itemType != 2) {
        return 44.0f;
    }
    else {
        return 90.0f;
    }
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
    if (itemType!=2) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (itemType) {
        case 4:     //体温
            tempSaveView = [[TempSaveView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height-64) Type:@"UPDATE" CreateTime:[[[arrDS objectAtIndex:indexPath.row] objectForKey:@"create_time"]longValue]];
            tempSaveView.TempSaveDelegate = self;
            [self.view addSubview:tempSaveView];
            break;
        case 2:
            //BMI不能编辑
            break;
        default:
            phySaveView = [[PhySaveView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height-64) Type:itemType OpType:@"UPDATE" CreateTime:[[[arrDS objectAtIndex:indexPath.row] objectForKey:@"create_time"]longValue]];
            phySaveView.PhySaveDelegate = self;
            [self.view addSubview:phySaveView];
            break;
    }
}

#pragma saveview delegate
-(void)sendTempReloadData{
    [self initData];
}

-(void)sendPhyReloadData{
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end