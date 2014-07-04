//
//  TipsWebViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-11-6.
//  Copyright (c) 2013年 爱摩信息科技. All rights reserved.
//

#import "TipsWebViewController.h"
#import "CustomURLCache.h"
#import "MBProgressHUD.h"
#import "UMSocial.h"
#import "UMSocialSnsData.h"

@interface TipsWebViewController ()

@end

@implementation TipsWebViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    [MobClick beginLogPageView:[NSString stringWithFormat:@"tips_%@", _url]];
    
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 34, 28)];
    title.backgroundColor = [UIColor clearColor];
    
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.text = NSLocalizedString(@"navback", nil);
    title.font = [UIFont systemFontOfSize:14];
    [backbutton addSubview:title];
    [backbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame=CGRectMake(0, 0, 44, 28);
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[rightButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 28)];
    title1.backgroundColor = [UIColor clearColor];
    [title1 setTextAlignment:NSTextAlignmentCenter];
    title1.textColor = [UIColor whiteColor];
    title1.text = NSLocalizedString(@"分享", nil);
    title1.font = [UIFont systemFontOfSize:14];
    [rightButton addSubview:title1];
    
    [rightButton addTarget:self action:@selector(ShareBtn) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame=CGRectMake(0, 0, 44, 28);
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[self.navigationController popViewControllerAnimated:NO];
    [MobClick endLogPageView:[NSString stringWithFormat:@"tips_%@", _url]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [Sharetext resignFirstResponder];
}

- (void)ShareBtn{
    
    [self hidenshareview];
    [self showshareview];
    [self Share];
}
-(void)Share
{
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                        _url];
    urlResource.url = _url;
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:_contenttitle image:[UIImage imageNamed:@"Icon-Small-50.png"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
//        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMENGAPPKEY
//                                      shareText:@"分享我的小贴士"
//                                     shareImage:[UIImage imageWithContentsOfFile:SHAREPATH]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToDouban,UMShareToEmail,UMShareToSms,UMShareToFacebook,UMShareToTwitter,nil]
//                                       delegate:nil];
    
    
}
-(void)showshareview
{
    [self.view bringSubviewToFront:Shareview];
    [UIView setAnimationDuration:1];
    [UIView beginAnimations:nil context:nil];
    Shareview.frame=CGRectMake(20, 0, 280, 300);
    [UIView commitAnimations];
}

-(void)hidenshareview
{
    [UIView setAnimationDuration:1];
    [UIView beginAnimations:nil context:nil];
    Shareview.frame=CGRectMake(20, -300, 280, 300);
    Sharetext.text=@"";
    [UIView commitAnimations];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

    
    //分享按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(320-10-40,28, 43, 28);
    [button addTarget:self action:@selector(ShareBtn) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"btn3.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    [self.tipsNavigationImageView addSubview:button];
    
    UIButton* buttonBack = [[UIButton alloc] init];
    buttonBack.frame = CGRectMake(10, 22, 40, 40);
    buttonBack.titleLabel.font = [UIFont systemFontOfSize:16];
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.tipsNavigationImageView addSubview:buttonBack];


    Shareview=[[UIImageView alloc]initWithFrame:CGRectMake(20, -300+G_YADDONVERSION, 280, 300)];
    
    
    [Shareview setImage:[UIImage imageNamed:@"save_bg.png"]];
    [Shareview.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    Shareview.userInteractionEnabled=YES;
    UIImageView *Shareimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 260, 180)];
    [Shareview addSubview:Shareimage];
    Shareimage.tag=10001;
    Shareimage.contentMode=UIViewContentModeScaleAspectFit;
    Sharetext=[[UITextField alloc]initWithFrame:CGRectMake(10, 210, 260, 30)];
    [Shareview addSubview:Sharetext];
    Sharetext.tag=10002;
    Sharetext.borderStyle=UITextBorderStyleRoundedRect;
    
    UIButton *share=[UIButton buttonWithType:UIButtonTypeCustom];
    [share setTitle:NSLocalizedString(@"Share",nil) forState:UIControlStateNormal];
    
    share.frame=CGRectMake(155, 250, 100, 40);
    [share setBackgroundImage:[UIImage imageNamed:@"btn_setting.png"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(Share) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancle=[UIButton buttonWithType:UIButtonTypeCustom];
    cancle.frame=CGRectMake(15, 250, 100, 40);
    [cancle setTitle:NSLocalizedString(@"Cancle",nil) forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(hidenshareview) forControlEvents:UIControlEventTouchUpInside];
    [cancle setBackgroundImage:[UIImage imageNamed:@"btn_setting.png"] forState:UIControlStateNormal];
    [Shareview addSubview:share];
    [Shareview addSubview:cancle];
    
    count = 0;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-G_WEBVIEWY)];
    
    [self.webView setBackgroundColor:[UIColor whiteColor]];
    
    [self.webView setScalesPageToFit:YES];
    self.webView.delegate = self;
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    if (urlRequest)
    {
        [self.webView loadRequest:urlRequest];
    }
    
    [self.view addSubview:self.webView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setTipsUrl:(NSString*)requestUrl
{
    _url = requestUrl;
}

-(void)setTipsTitle:(NSString *)title
{
    _contenttitle = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (count < 5) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.alpha = 0.5;
        hud.color = [UIColor grayColor];
        hud.labelText = NSLocalizedString(@"PlotLoading", nil);
        count++;
    }
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end