//
//  CopyrightViewController.m
//  Parenting
//
//  Created by user on 13-5-21.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "CopyrightViewController.h"

@interface CopyrightViewController ()

@end

@implementation CopyrightViewController
@synthesize scrollView = _scrollView;
@synthesize contentLabel = _contentLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
        titleView.backgroundColor=[UIColor clearColor];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        titleText.textColor = [UIColor whiteColor];
        [titleText setTextAlignment:NSTextAlignmentCenter];
        [titleText setText:NSLocalizedString(@"Copyright", nil)];
        [titleView addSubview:titleText];
        
        self.navigationItem.titleView = titleView;
        //self.title = NSLocalizedString(@"Copyright",nil);
        self.hidesBottomBarWhenPushed=YES;
        //self.automaticallyAdjustsScrollViewInsets = NO;
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
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+G_YADDONVERSION, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    NSString *copyright=NSLocalizedString(@"CopyRight", nil);
    CGSize labelSize = {0, 0};
    labelSize = [copyright sizeWithFont:[UIFont systemFontOfSize:14]
                     constrainedToSize:CGSizeMake(200.0, 1900)];
    
    //200为UILabel的宽度，5000是预设的一个高度，表示在这个范围内
    self.contentLabel = [[UITextView alloc] init];
    
    self.contentLabel.frame = CGRectMake(10 , 94, 300, labelSize.height);//保持原来Label的位置和宽度，只是改变高度。
    
    [self.contentLabel setText:copyright];
    
    [self.contentLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.contentLabel setTextColor:[UIColor grayColor]];
    
    //self.contentLabel.numberOfLines = 0;//表示label可以多行显示
    
    [self.contentLabel setContentMode:UIViewContentModeCenter];
    
    [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
    
    //self.contentLabel.lineBreakMode = UILineBreakModeWordWrap;//换行模式，与上面的计算保持一致。
    self.contentLabel.editable = NO;
    
    self.scrollView.contentSize = CGSizeMake(320, 1900);
    
    [self.scrollView addSubview:self.contentLabel];

    _scrollView.showsHorizontalScrollIndicator=NO;
    
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 34, 28)];
    title.backgroundColor = [UIColor clearColor];
    [title setTextAlignment:NSTextAlignmentCenter];
    //title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.text = NSLocalizedString(@"navback", nil);
    title.font = [UIFont systemFontOfSize:14];
    [backbutton addSubview:title];
    
    [backbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame=CGRectMake(0, 0, 44, 28);
    
    
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
