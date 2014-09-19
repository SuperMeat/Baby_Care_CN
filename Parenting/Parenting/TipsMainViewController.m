//
//  TipsMainViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-5-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "TipsMainViewController.h"
#import "UserDataDB.h"
#import "TipCategoryDB.h"
#import "TipListViewController.h"

@interface TipsMainViewController ()

@end

@implementation TipsMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
        self.navigationController.navigationBarHidden = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *btnChange = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 60, 20)];
    [btnChange setTitle:@"show" forState:UIControlStateNormal];
    btnChange.backgroundColor = [UIColor redColor];
    [btnChange addTarget:self action:@selector(showtest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnChange];
    
}

-(void)showtest{
    if(_scrollView.contentOffset.x == 0){
        [_buttonSubscribe setTitle:@"订阅" forState:UIControlStateNormal];
    }
    [_scrollView setContentOffset:CGPointMake(0, 64) animated:NO];
    
    [self initView];
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
    if(_scrollView.contentOffset.x == 0){
        [_buttonSubscribe setTitle:@"订阅" forState:UIControlStateNormal];
    }
    
    [self initView];
    [self initData];
}

-(void)initView{
    //加载navigationBar
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    backbutton.frame=CGRectMake(0, 0, 50, 41);
    backbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [backbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 160, 20)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:@"小贴士"];
    [titleView addSubview:titleText];
    
    self.navigationItem.titleView = titleView;
    
    //加载订阅贴士按钮
    _buttonSubscribe = [[UIButton alloc] init];
    _buttonSubscribe.frame=CGRectMake(0, 0, 51, 51);
    _buttonSubscribe.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -40);
    _buttonSubscribe.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonSubscribe setTitle:@"订阅" forState:UIControlStateNormal];
    [_buttonSubscribe addTarget:self action:@selector(goSubscribe:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbar=[[UIBarButtonItem alloc]initWithCustomView:_buttonSubscribe];

    self.navigationItem.rightBarButtonItem = rightbar;
    //加载ScrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width * 2, kDeviceHeight-64)];
    _scrollView.scrollEnabled = false;
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.showsVerticalScrollIndicator = false;
    
    //加载已订阅TableView
    _tTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width / 2,  _scrollView.frame.size.height) style:UITableViewStyleGrouped];
    _tTableView.dataSource = self;
    _tTableView.delegate = self;
    
    
    //加载欲订阅TableView
    _sTableView = [[UITableView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width / 2, 0, _scrollView.frame.size.width / 2,  _scrollView.frame.size.height) style:UITableViewStyleGrouped];
    _sTableView.dataSource = self;
    _sTableView.delegate = self;
    
    [_scrollView addSubview:_tTableView];
    [_scrollView addSubview:_sTableView];
    [self.view addSubview:_scrollView];
    
    _scrollView.backgroundColor = _tTableView.backgroundColor;
}

-(void)initData{
    //获取所有贴士类目
    subArray = [TipCategoryDB selectCategoryList:0];
    tipArray = [[NSArray alloc]initWithObjects: nil];
    
    //根据用户category_ids获取用户已订阅列表
    if (category_ids == nil || [category_ids  isEqual: @""]) {
        NSDictionary *userDict = [[UserDataDB alloc] selectUser:ACCOUNTUID];
        category_ids = [userDict objectForKey:@"category_ids"];
        if ([category_ids isEqual:@""]) {
            category_ids = @",";
        }
    }
    
    if ([category_ids isEqual:@","]) {
        tipArray = [[NSArray alloc]initWithObjects:nil];
        if([subArray count] == 0)
        {
            [self goSubscribe:_buttonSubscribe];
        }
        else{
            [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
            [_buttonSubscribe setTitle:@"完成" forState:UIControlStateNormal];

        }
    }
    else{
        NSArray *split = [category_ids componentsSeparatedByString:@","];
        for(NSString *cur_category in split) {
            if (![cur_category isEqualToString:@""]) {
                for (NSArray * tarArr in subArray) {
                    if ([[tarArr objectAtIndex:0] intValue] == [cur_category intValue]) {
                        if(tipArray == nil)
                        {
                            tipArray=[[NSArray alloc]initWithObjects:tarArr, nil];
                        }else
                        {
                            tipArray = [tipArray arrayByAddingObject:tarArr];
                        }
                    }
                }
            }
        }
    }
    
    tipArray = [tipArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSNumber *number1 = [obj1 objectAtIndex:0];
        NSNumber *number2 = [obj2 objectAtIndex:0];
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending; // 升序
        return result == NSOrderedAscending;  // 降序
    }];
    
}

-(void)goSubscribe:(UIButton*)button{
    if ([button.titleLabel.text  isEqual:@"订阅"]) {
//        [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width, _tempOffset) animated:YES];
        [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [[SyncController syncController] syncCategoryInfo:ACCOUNTUID HUD:hud SyncFinished:^{
            [self initData];
            [_sTableView reloadData];
            [_tTableView reloadData];
        } ViewController:self];
    }
    else
    {
//        [_scrollView setContentOffset:CGPointMake(0, _tempOffset) animated:YES];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [button setTitle:@"订阅" forState:UIControlStateNormal];
    }
    
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)subscribe:(UIButton*)button{
    category_ids = [NSString stringWithFormat:@"%@%d,",category_ids,button.tag];
    [[UserDataDB dataBase] updateUserCategoryIds:category_ids andUserId:ACCOUNTUID];
    [self initData];
    [_tTableView reloadData];
    [_sTableView reloadData];
    
}

-(void)desubscribe:(UIButton*)button{
    NSRange rang = [category_ids rangeOfString:[NSString stringWithFormat:@",%d,",button.tag]];
    category_ids = [category_ids stringByReplacingCharactersInRange:rang withString:@","];
    
    [[UserDataDB dataBase] updateUserCategoryIds:category_ids andUserId:ACCOUNTUID];
    [self initData];
    [_tTableView reloadData];
    [_sTableView reloadData];
    
}

#pragma tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tTableView) {
        return [tipArray count];
    }
    else if (tableView == _sTableView){
        return [subArray count];
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //已订阅tableView
    if (tableView == _tTableView) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //加载类目图标
        NSString *imageUrl = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[[tipArray objectAtIndex:indexPath.row] objectAtIndex:3]];
        UIImage *imagea = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageUrl]];
        UIImageView *iconImageView = [[UIImageView alloc]initWithImage:imagea];
        [iconImageView setFrame:CGRectMake(10, 10, 60, 60)];
        [cell addSubview:iconImageView];
        
        //加载类目名字
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 120, 30)];
        titleLabel.font = [UIFont fontWithName:@"Arial" size:MIDTEXT];
        titleLabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
        titleLabel.text = [[tipArray objectAtIndex:indexPath.row] objectAtIndex:1];
        [cell addSubview:titleLabel];
        
        //加载类目描述
        UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 200, 24)];
        describeLabel.font = [UIFont fontWithName:@"Arial" size:SMALLTEXT];
        describeLabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
        describeLabel.text = [[tipArray objectAtIndex:indexPath.row] objectAtIndex:2];
        
        [cell addSubview:describeLabel];
    }
    //欲订阅列表
    else if (tableView == _sTableView) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //加载类目图标
        NSString *imageUrl = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[[subArray objectAtIndex:indexPath.row] objectAtIndex:3]];
        UIImage *imagea = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageUrl]];
        UIImageView *iconImageView = [[UIImageView alloc]initWithImage:imagea];
        [iconImageView setFrame:CGRectMake(10, 10, 60, 60)];
        [cell addSubview:iconImageView];
        
        //加载类目名字
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 120, 30)];
        titleLabel.font = [UIFont fontWithName:@"Arial" size:MIDTEXT];
        titleLabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
        titleLabel.text = [[subArray objectAtIndex:indexPath.row] objectAtIndex:1];
        [cell addSubview:titleLabel];
        
        //加载类目描述
        UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 42, 160, 30)];
        describeLabel.font = [UIFont fontWithName:@"Arial" size:SMALLTEXT];
        describeLabel.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
        describeLabel.text = [[subArray objectAtIndex:indexPath.row] objectAtIndex:2];
        describeLabel.lineBreakMode = UILineBreakModeWordWrap;
        describeLabel.numberOfLines = 0;
        [cell addSubview:describeLabel];
        
        //TODO:订阅和取消订阅类目
        //checkSubscribe(categoryID) - [[tipArray objectAtIndex:indexPath.section] objectAtIndex:0];
        UIButton *subButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50 - 20 , 15 , 50, 50)];
        subButton.tag = [[[subArray objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        if (![TipCategoryDB checkSubscribe:ACCOUNTUID categoryId:[[[subArray objectAtIndex:indexPath.row] objectAtIndex:0] intValue]]) {
            //加载订阅按钮
            [subButton setBackgroundImage:[UIImage imageNamed:@"btn_tips_add.png"] forState:UIControlStateNormal];
            [subButton setBackgroundImage:[UIImage imageNamed:@"btn_tips_add_focus.png"] forState:UIControlStateHighlighted];
            [subButton addTarget:self action:@selector(subscribe:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            //加载取消订阅按钮
            [subButton setBackgroundImage:[UIImage imageNamed:@"btn_minus.png"] forState:UIControlStateNormal];
            [subButton setBackgroundImage:[UIImage imageNamed:@"btn_minus_foucs.png"] forState:UIControlStateHighlighted];
            [subButton addTarget:self action:@selector(desubscribe:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell addSubview:subButton];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80; 
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tTableView) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tTableView) {
        return UITableViewCellEditingStyleDelete;
    }
    else{
        return UITableViewCellEditingStyleNone;
    }
}

-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath{
    return @"取消订阅";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int c_id = [[[tipArray objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    NSRange rang = [category_ids rangeOfString:[NSString stringWithFormat:@"%d,",c_id]];
    category_ids = [category_ids stringByReplacingCharactersInRange:rang withString:@","];
    
    [[UserDataDB dataBase] updateUserCategoryIds:category_ids andUserId:ACCOUNTUID];
    [self initData];
    [_tTableView reloadData];
    [_sTableView reloadData];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        TipListViewController *tipList = [[TipListViewController alloc]initWithCategoryId:[[[tipArray objectAtIndex:indexPath.row] objectAtIndex:0] intValue] Name:[[tipArray objectAtIndex:indexPath.row] objectAtIndex:1]];
        [self.navigationController pushViewController:tipList animated:YES];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
