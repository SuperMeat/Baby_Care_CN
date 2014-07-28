//
//  TipDetailViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-6-9.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "TipListViewController.h"

#define SCROLLPADDINGTOP 40
#define SCROLLPADDINGBOTTOM (_scrollView.frame.size.height - CELLHEIGHT)
#define CELLHEIGHT 325
#define CELLWIDTH 320

@interface TipListViewController ()

@end

@implementation TipListViewController

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
    
    [[SyncController syncController]    getTips:ACCOUNTUID
                                     CategoryID:_categoryId
                                 LastCreateTime:[ACDate getTimeStampFromDate:[NSDate date]]//Now
                                      GetNumber:3
                                            HUD:hud
                                   SyncFinished:^(NSArray *retArr){
                                       //取出获取到数据的ids
                                       tipsIds=@"";
                                       for (NSDictionary* tip in retArr) {
                                           //处理贴士类目表&创建数据库
                                           int tipsId = [[tip objectForKey:@"tipId"] intValue];
                                           tipsIds = [tipsIds stringByAppendingString:[NSString stringWithFormat:@"%d,",tipsId]];
                                       }
                                       tipsIds = [tipsIds substringToIndex:[tipsIds length]-1];
                                       [self initData];
                                   }
                                 ViewController:self];
}

-(void)viewDidAppear:(BOOL)animated{
    
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

    _buttonBack = [[UIButton alloc] init];
    _buttonBack.frame = CGRectMake(10, 22, 40, 40);
    _buttonBack.titleLabel.font = [UIFont systemFontOfSize:16];
    [_buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [_buttonBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.tipsNavigationImageView addSubview:_buttonBack];
    
    //加载ScrollView 
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64.0f)];
    _scrollView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:240.0/255.0 blue:236.0/255.0 alpha:1.0];
    _scrollView.pagingEnabled = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    [self.view addSubview:_scrollView];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(self.view.frame.size.width / 2 - 10,
                                    SCROLLPADDINGTOP / 2, 20.0f, 20.0f);
    [_scrollView addSubview:activityView];
}

-(void)initData{
    //TODO:获取数据库数据源 倒序排列
    arrDS = [TipCategoryDB selectTipsByIds:tipsIds];
    CGSize newSize;
    if ([arrDS count] == 0) {
        //处理空数据
        newSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
        // _scrollView addsubview Label & Image
    }
    else if ([arrDS count] == 1) {
        //条数 * CELLHEIGHT + 上扩边(SCROLLPADDINGTOP)
        newSize = CGSizeMake(_scrollView.frame.size.width, [arrDS count]* CELLHEIGHT + SCROLLPADDINGTOP + SCROLLPADDINGBOTTOM);
    }
    else{
        //条数 * CELLHEIGHT + SCROLLPADDINGTOP&BOTTOM
        newSize = CGSizeMake(_scrollView.frame.size.width, [arrDS count]* CELLHEIGHT + SCROLLPADDINGTOP);
    }
    [_scrollView setContentSize:newSize];
    NSLog(@"newSize:%f",newSize.height);
    NSLog(@"scrollViewHeight:%f",_scrollView.frame.size.height);
    NSLog(@"%f",self.view.frame.size.height);
    [_scrollView setContentOffset:CGPointMake(0, newSize.height - _scrollView.frame.size.height) animated:NO];
    
    for(NSArray *arr in arrDS)
    {
        TipTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TipTableViewCell" owner:self options:nil] objectAtIndex:0];
        [cell setCellContent:[arr objectAtIndex:1] title:[arr objectAtIndex:2] summary:[arr objectAtIndex:3] picUrl:[arr objectAtIndex:4]];
        cell.frame = CGRectMake(0, SCROLLPADDINGTOP + [arrDS indexOfObject:arr]*CELLHEIGHT, CELLWIDTH, CELLHEIGHT);
        cell.tag = [[arr objectAtIndex:0] intValue];
        //设置CELL内容
        [_scrollView addSubview:cell];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goDetail:)];
        tapGesture.view.tag =[[arr objectAtIndex:0] intValue];
        [cell addGestureRecognizer:tapGesture];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_scrollView.contentOffset.y < 0 && !activityView.isAnimating) {
        [activityView startAnimating];
        _scrollView.scrollEnabled = NO;
        
        long lastCreateTime = [[[arrDS objectAtIndex:0] objectAtIndex:5]longValue];
        [[SyncController syncController]    getTips:ACCOUNTUID
                                         CategoryID:_categoryId
                                     LastCreateTime:lastCreateTime//Now
                                          GetNumber:3
                                                HUD:hud
                                       SyncFinished:^(NSArray *retArr){
                                           //已无更新记录
                                           if (retArr == nil) {
                                               [activityView stopAnimating];
                                               _scrollView.scrollEnabled = YES;
                                               [_scrollView setContentOffset:CGPointMake(0, SCROLLPADDINGTOP) animated:YES];
                                               return;
                                           }
                                           //取出获取到数据的ids
                                           tipsIds = @"";
                                           for (NSDictionary* tip in retArr) {
                                               //处理贴士类目表&创建数据库
                                               int tipsId = [[tip objectForKey:@"tipId"] intValue];
                                               tipsIds = [tipsIds stringByAppendingString:[NSString stringWithFormat:@"%d,",tipsId]];
                                           }
                                           tipsIds = [tipsIds substringToIndex:[tipsIds length]-1];
                                           [self uploadData];
                                       }
                                     ViewController:self];
    }
}

-(void)uploadData{
    NSArray *arrRevice = [TipCategoryDB selectTipsByIds:tipsIds];
    
    arrDS = [arrRevice arrayByAddingObjectsFromArray:arrDS];
    
    //先调整contentSize
    CGSize newSize = CGSizeMake(_scrollView.frame.size.width,
                                [arrDS count]* CELLHEIGHT + SCROLLPADDINGTOP);
    [_scrollView setContentSize:newSize];
    
    //调增原有view的Frame
    for (TipTableViewCell *view in _scrollView.subviews) {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + [arrRevice count]* CELLHEIGHT, view.frame.size.width, view.frame.size.height);
    }
    
    //增加view
    for(NSArray *arr in arrRevice)
    {
        TipTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TipTableViewCell" owner:self options:nil] objectAtIndex:0];
        [cell setCellContent:[arr objectAtIndex:1] title:[arr objectAtIndex:2] summary:[arr objectAtIndex:3] picUrl:[arr objectAtIndex:4]];
        cell.frame = CGRectMake(0, SCROLLPADDINGTOP + [arrDS indexOfObject:arr]*CELLHEIGHT, CELLWIDTH, CELLHEIGHT);
        cell.tag = [[arr objectAtIndex:0] intValue];
        //设置CELL内容
        [_scrollView addSubview:cell];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goDetail:)];
        tapGesture.view.tag =[[arr objectAtIndex:0] intValue];
        [cell addGestureRecognizer:tapGesture];
    }
    
    //scrollview偏移
    _scrollView.contentOffset = CGPointMake(0,_scrollView.contentOffset.y + [arrRevice count]* CELLHEIGHT);
    
    [activityView stopAnimating];
    _scrollView.scrollEnabled = YES;
}

-(void)goDetail:(id)sender{
    UITapGestureRecognizer* tap = sender;
    TipsWebViewController *tipsWeb = [[TipsWebViewController alloc]init];
    NSString *Url = [NSString stringWithFormat:@"%@/tips/showTip.aspx?id=%d",BASE_URL,tap.view.tag];
    [tipsWeb setTipsUrl:Url];
    [self.navigationController pushViewController:tipsWeb animated:YES];
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
