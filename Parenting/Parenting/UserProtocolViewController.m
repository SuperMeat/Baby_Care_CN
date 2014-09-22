//
//  UserProtocolViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-8-27.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "UserProtocolViewController.h"

@interface UserProtocolViewController ()

@end

@implementation UserProtocolViewController

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
        [titleText setText:NSLocalizedString(@"用户协议", nil)];
        [titleView addSubview:titleText];
        
        self.navigationItem.titleView = titleView;
        //self.title = NSLocalizedString(@"Copyright",nil);
        self.hidesBottomBarWhenPushed=YES;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    NSString *copyright=NSLocalizedString(@"UserProtocol", nil);
    CGSize labelSize = {0, 0};
    labelSize = [copyright sizeWithFont:[UIFont systemFontOfSize:14]
                      constrainedToSize:CGSizeMake(200.0, 2500)];
    
    //200为UILabel的宽度，5000是预设的一个高度，表示在这个范围内
    self.contentLabel = [[UITextView alloc] init];
    self.contentLabel.selectable = NO;
    self.contentLabel.frame = CGRectMake(10 , 0, 300, labelSize.height);//保持原来Label的位置和宽度，只是改变高度。
    
    [self.contentLabel setText:copyright];
    
    [self.contentLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.contentLabel setTextColor:[UIColor grayColor]];
    
    //self.contentLabel.numberOfLines = 0;//表示label可以多行显示
    
    [self.contentLabel setContentMode:UIViewContentModeCenter];
    
    [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
    
    //self.contentLabel.lineBreakMode = UILineBreakModeWordWrap;//换行模式，与上面的计算保持一致。
    self.contentLabel.editable = NO;
    
    self.scrollView.contentSize = CGSizeMake(320, 2500);
    
    [self.scrollView addSubview:self.contentLabel];
    
    _scrollView.showsHorizontalScrollIndicator=NO;
    
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    backbutton.frame=CGRectMake(0, 0, 50, 41);
    backbutton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [backbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
