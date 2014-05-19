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

@interface TipsMainViewController ()

@end

@implementation TipsMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self syncCategoryInfo];
}

-(void)syncCategoryInfo{
    //TODO:save category data to DB
    [[SyncController syncController]
     syncCategoryInfo:ACCOUNTUID
     HUD:hud
     SyncFinished:^{
         //调用成功
         [self initData];
         //TODO:未订阅任何贴士则转到贴士订阅页
         NSDictionary *userDict = [[UserDataDB alloc] selectUser:ACCOUNTUID];
         if ([[userDict objectForKey:@"category_ids"] isEqual:@""]) {
             [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
         }
     }
     ViewController:self
     ];
}

-(void)initView{
    //加载头部Navigation
    //加载navigationBar
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:@"小贴士"];
    [titleView addSubview:titleText];
    self.tipsNavigationImageView = [[UIImageView alloc] init];
    [self.tipsNavigationImageView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [self.tipsNavigationImageView setBackgroundColor:[ACFunction colorWithHexString:@"#68bfcc"]];
    [self.tipsNavigationImageView addSubview:titleView];
    [self.view addSubview:self.tipsNavigationImageView];
    [self.tipsNavigationImageView setUserInteractionEnabled:YES];
    
    //加载ScrollView
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width * 2, self.view.frame.size.height-64)];
    _scrollView.scrollEnabled = false;
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:_scrollView];
    
    //加载已订阅TableView
    _tTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width / 2,  _scrollView.frame.size.height) style:UITableViewStyleGrouped];
    _tTableView.dataSource = self;
    _tTableView.delegate = self;
    [_scrollView addSubview:_tTableView];
    
    //加载欲订阅TableView
    _sTableView = [[UITableView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width / 2, 0, _scrollView.frame.size.width / 2,  _scrollView.frame.size.height) style:UITableViewStyleGrouped];
    _sTableView.dataSource = self;
    _sTableView.delegate = self;
    [_scrollView addSubview:_sTableView];
}

-(void)initData{
    //根据用户category_ids获取用户已订阅列表
    NSArray *arr = @[@[@1,@"宝宝健康",@"宝宝健康的相关描述",@"http://t12.baidu.com/it/u=4056938852,1850657326&fm=56"],
                     @[@2,@"夫妻生活",@"夫妻生活的相关描述",@"http://www.baidu.com/test.jpg"],
                     @[@3,@"孕期注意",@"孕期注意的相关描述",@"http://www.baidu.com/test.jpg"],
                     @[@4,@"环境相关",@"环境相关的相关描述",@"http://www.baidu.com/test.jpg"],
                     @[@5,@"活动注意",@"活动注意的相关描述",@"http://www.baidu.com/test.jpg"],
                     @[@6,@"喂食讲究",@"喂食讲究的相关描述",@"http://www.baidu.com/test.jpg"],
                     ];
    tipArray = [[NSArray alloc]initWithArray:arr];
    
    //获取所有贴士类目
    subArray = [TipCategoryDB selectAllCategoryList];
    
    [_tTableView reloadData];
    [_sTableView reloadData];
}

-(void)subscribe:(UIButton*)button{
    
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
    if (cell == nil && tableView == _tTableView) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //加载类目图标
        NSURL *picUrl = [NSURL URLWithString:[[tipArray objectAtIndex:indexPath.row] objectAtIndex:3]];
        UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:picUrl]];
        UIImageView *iconImageView = [[UIImageView alloc]initWithImage:imagea];
        [iconImageView setFrame:CGRectMake(10, 10, 60, 60)];
        [cell addSubview:iconImageView];
        
        //加载类目名字
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 120, 30)];
        titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
        titleLabel.text = [[tipArray objectAtIndex:indexPath.row] objectAtIndex:1];
        [cell addSubview:titleLabel];
        
        //加载类目描述
        UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 200, 24)];
        describeLabel.font = [UIFont fontWithName:@"Arial" size:12];
        describeLabel.text = [[tipArray objectAtIndex:indexPath.row] objectAtIndex:2];
        [cell addSubview:describeLabel];
    }
    //欲订阅列表
    else if (cell == nil && tableView == _sTableView) {
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
        titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
        titleLabel.text = [[subArray objectAtIndex:indexPath.row] objectAtIndex:1];
        [cell addSubview:titleLabel];
        
        //加载类目描述
        UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, 200, 24)];
        describeLabel.font = [UIFont fontWithName:@"Arial" size:12];
        describeLabel.text = [[subArray objectAtIndex:indexPath.row] objectAtIndex:2];
        [cell addSubview:describeLabel];
        
        //TODO:订阅和取消订阅类目
        //checkSubscribe(categoryID) - [[tipArray objectAtIndex:indexPath.section] objectAtIndex:0];
        UIButton *subButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50 - 20 , 15 , 50, 50)];
        subButton.tag = indexPath.row;
        if (![TipCategoryDB checkSubscribe:ACCOUNTUID categoryId:[[[subArray objectAtIndex:indexPath.row] objectAtIndex:0] intValue]]) {
            //加载订阅按钮
            [subButton setBackgroundImage:[UIImage imageNamed:@"icon_subscribe.png"] forState:UIControlStateNormal];
        }
        else {
            //加载取消订阅按钮
            [subButton setBackgroundImage:[UIImage imageNamed:@"icon_desubscribe.png"] forState:UIControlStateNormal];
        }
        [subButton addTarget:self action:@selector(subscribe:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:subButton];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
