//
//  GuideViewController.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-11-26.
//  Copyright (c) 2013年 奥芬多. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController
@synthesize fitHeight;

-(id)initWithRootViewController:(UIViewController*)rootViewController
{
    if ((self = [super init])) {
        _nextViewController = rootViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //版本适配尺寸
    if ([UIScreen mainScreen].bounds.size.height==568){
        fitHeight = 568;
    }
    else if ([UIScreen mainScreen].bounds.size.height==480){
        fitHeight = 480;
    }
  
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, fitHeight)];
    _scrollView.bounces = YES; //检查是否已到边界
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_scrollView];
    
    // 初始化数组
    _slideImages = [[NSMutableArray alloc] init];
    [_slideImages addObject:@"guide_1.png"];
    [_slideImages addObject:@"guide_2.png"];
    [_slideImages addObject:@"guide_3.png"];
    [_slideImages addObject:@"guide_4.png"];
    
    // 初始化 pagecontrol x轴位置等于 windows宽度/2-控件宽度/2
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(110,0.875*fitHeight,100,18)]; // 初始化mypagecontrol
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [_pageControl setPageIndicatorTintColor:[UIColor blackColor]];
    _pageControl.numberOfPages = [self.slideImages count];
    _pageControl.currentPage = 0;
    [self.view addSubview:_pageControl];
    
    // 创建四个UImageIVew到UIScrollView中
    for (int i = 0;i<[_slideImages count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]]];
        imageView.frame = CGRectMake(320 * i, 0, 320, fitHeight);
        [_scrollView addSubview:imageView];
    }
    
    //设置UIScrollView的page 定义实际内容大小，会让滚动生效
    [_scrollView setContentSize:CGSizeMake(320*_slideImages.count, fitHeight)]; //不知道什么用
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [_scrollView scrollRectToVisible:CGRectMake(0,0,320,fitHeight) animated:NO];
    
    
    UIButton *buttonSkip = [[UIButton alloc]initWithFrame:CGRectMake(320*(_slideImages.count-1)+110, 0.8*fitHeight, 100, 24)];
    [buttonSkip setTitle:@"开始体验" forState:UIControlStateNormal];
    [buttonSkip addTarget:self action:@selector(skipToMain:) forControlEvents:(UIControlEventTouchUpInside)];
    [_scrollView addSubview:buttonSkip];

}

-(void)skipToMain:(id)sender{
    _nextViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:_nextViewController animated:YES completion:^{}];
}

// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender{
    NSInteger offsetX =self.scrollView.contentOffset.x;
    if (offsetX >=0 && offsetX <320) {
        _pageControl.currentPage = 0;
    }
    else if (offsetX >=320 && offsetX <320*2){
        _pageControl.currentPage = 1;
    }
    else if (offsetX >=320*2 && offsetX <320*3){
        _pageControl.currentPage = 2;
    }
    else if (offsetX>=320*3 && offsetX < 320*4){
        _pageControl.currentPage = 3;
    }
}

// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
