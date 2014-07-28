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
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 160, 20)];
    titleView.backgroundColor=[UIColor clearColor];
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
    titleText.backgroundColor = [UIColor clearColor];
    [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setTextAlignment:NSTextAlignmentCenter];
    [titleText setText:@"贴士详情"];
    [titleView addSubview:titleText];
    
    self.navigationItem.titleView = titleView;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:[NSString stringWithFormat:@"tips_%@", _url]];
}

- (void)ShareBtn
{
    [self Share];
}

-(void)Share
{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
    
    [UMSocialData defaultData].extConfig.wechatFavoriteData.url = _url;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;

    //加载网络图片-无缓存
    UIImage *image;
    if (_flag == 1) {
        image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_showimage]]];
    }
    else {
        image = [UIImage imageNamed:_showimage];
    }
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENGAPPKEY
                                      shareText:_contenttitle
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToSina,
                                    UMShareToQQ,
                                    UMShareToQzone,
                                    UMShareToFacebook,
                                    UMShareToSms,
                                    UMShareToEmail,nil]
                                       delegate:self];

    }

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    NSLog(@"%@",platformName);
    if ([platformName isEqualToString:@"wxsession"])
    {
        [UMSocialData defaultData].extConfig.wechatSessionData.title = _contenttitle;
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = _url;
    }
    else if ([platformName  isEqualToString:@"wxtimeline"])
    {
         [UMSocialData defaultData].extConfig.wechatFavoriteData.url = _url;
    }
    else if ([platformName  isEqualToString:@"wxfavorite"])
    {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = _url;
    }
    else if ([platformName  isEqualToString:@"qq"])
    {
        [UMSocialData defaultData].extConfig.qqData.url    = _url;
    }
    else if ([platformName  isEqualToString:@"qzone"])
    {
        [UMSocialData defaultData].extConfig.qzoneData.url = _url;

    }
    else if ([platformName  isEqualToString:@"sina"])
    {
        [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@\r\n%@", _contenttitle ,_url];
        [UMSocialData defaultData].extConfig.sinaData.shareImage = [UIImage imageNamed:_showimage];
    }
    else if ([platformName  isEqualToString:@"sms"])
    {
        [UMSocialData defaultData].extConfig.smsData.shareText = [NSString stringWithFormat:@"%@\r\n%@", _contenttitle ,_url];
    }
    else if ([platformName  isEqualToString:@"email"])
    {
        [UMSocialData defaultData].extConfig.emailData.shareText = [NSString stringWithFormat:@"%@\r\n%@", _contenttitle ,_url];

    }
    //facebook
    else
    {
    
    }
    
}

-(BOOL)isDirectShareInIconActionSheet
{
    return NO;
}

-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
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
    
    count = 0;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-G_WEBVIEWY)];
    
    [self.webView setBackgroundColor:[UIColor whiteColor]];
    
    [self.webView setScalesPageToFit:YES];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setTipsUrl:(NSString*)requestUrl
{
    _url = requestUrl;
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    if (urlRequest)
    {
        [self.webView loadRequest:urlRequest];
    }
}

-(void)setTipsTitle:(NSString *)title
{
    _contenttitle = title;
}

-(void)setShowImage:(NSString*)imagePath
{
    _showimage = imagePath;
}

-(void) setFlag:(int)flag
{
    _flag = flag;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (count < 5) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.alpha = 0.5;
        hud.color = [UIColor grayColor];
        hud.labelText = NSLocalizedString(@"PlotLoading", nil);
        count++;
    }
}


@end