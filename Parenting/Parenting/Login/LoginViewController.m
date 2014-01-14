//
//  LoginViewController.m
//  LoginModule
//
//  Created by CHEN WEIBIN on 13-12-26.
//  Copyright (c) 2013年 CHEN WEIBIN. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginMainViewController.h"
#import "UMSocial.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "MD5.h"
#import "APService.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

-(id)initWithRootViewController:(UIViewController*)rootViewController
{
    if ((self = [super init])) {
        if (rootViewController != nil) {
            [[NSUserDefaults standardUserDefaults]setObject:[rootViewController nibName] forKey:@"ViewControllerBeforLogin"];
        }
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isPushSocialView = NO;
    [_buttonLogin addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (isPushSocialView) {
        isPushSocialView = NO;
    }
    else{
        self.navigationController.navigationBarHidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = NO;
}

- (void) move:(UIView*)view toY:(CGFloat)y
{
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

- (IBAction)goBack:(id)sender {
    NSString *targetNibName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ViewControllerBeforLogin"];

    for (UIViewController *myDT in self.navigationController.viewControllers) {
        if ([myDT.nibName isEqualToString:targetNibName]) {
            [self.navigationController popToViewController:myDT animated:YES];
            break;
        }
    }
}

-(void)goLogin
{
    LoginMainViewController *testViewController = [[LoginMainViewController alloc]initWithNibName:@"LoginMainViewController" bundle:nil];
    [self.navigationController pushViewController:testViewController animated:YES];
}

- (IBAction)goLoginByTencent:(id)sender {
    isPushSocialView = YES;
    
    BOOL isOauth = [UMSocialAccountManager isOauthWithPlatform:UMShareToTencent];
    if (isOauth) {
        //TODO:有登录过，如何处理
        //return;
    }
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
    {
        //加载登录进度条
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.alpha = 0.5;
        hud.color = [UIColor grayColor];
        hud.labelText = @"登录验证中...";
        
        if ([[snsPlatform platformName] isEqualToString:UMShareToTencent])
        {
                [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                    if ([[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToTencent] == NULL) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        return;
                    }
                    //TODO:登录接口-记录用户登录纪录
                    NSString* strUrl = [ASIHTTPADDRESS stringByAppendingString:@"/BaseService.svc/login/"];
                    strUrl = [strUrl stringByAppendingString:[MD5 md5:ASIHTTPTOKEN]];
                    NSString* openudid = [@"/" stringByAppendingString:[APService openUDID]];
                    strUrl = [strUrl stringByAppendingString:openudid];
                
                    NSString* parameter = [NSString stringWithFormat:@"/%@/Tencent",[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToTencent] objectForKey:@"username"]];
                    strUrl = [strUrl stringByAppendingString:parameter];
                    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:strUrl];
                    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                    [request startSynchronous];
                    NSError *error = [request error];
                    UIAlertView *alert;
                    if (!error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        NSString *response = [request responseString];
                        if ([response isEqualToString:@"1"]) {
                            [[NSUserDefaults standardUserDefaults]setObject:[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToTencent] objectForKey:@"username"] forKey:@"ACCOUNT_NAME"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"TENCENT" forKey:@"ACCOUNT_TYPE"];
                            alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            [alert show];
                        }
                        else if ([response isEqualToString:@"-9"]){
                            alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器连接异常!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            [alert show];
                        }
                    }
                    else{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器连接异常!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                        }
                }];
        }
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.message isEqual: @"登录成功!"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)goLoginBySina:(id)sender {
    isPushSocialView = YES;
    BOOL isOauth = [UMSocialAccountManager isOauthWithPlatform:UMShareToSina];
    if (isOauth) {
        //TODO:有登录过，如何处理
        //return;
    }
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response)
    {
        //加载登录进度条
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.alpha = 0.5;
        hud.color = [UIColor grayColor];
        hud.labelText = @"登录验证中...";
        
        if ([[snsPlatform platformName] isEqualToString:UMShareToSina])
        {
            [[UMSocialDataService defaultDataService] requestSocialAccountWithCompletion:^(UMSocialResponseEntity *accountResponse){
                if ([[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] == NULL) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    return;
                }
                //TODO:登录接口-记录用户登录纪录
                NSString* strUrl = [ASIHTTPADDRESS stringByAppendingString:@"/BaseService.svc/login/"];
                strUrl = [strUrl stringByAppendingString:[MD5 md5:ASIHTTPTOKEN]];
                NSString* openudid = [@"/" stringByAppendingString:[APService openUDID]];
                strUrl = [strUrl stringByAppendingString:openudid];
                NSString* parameter = [NSString stringWithFormat:@"/%@/Sina",[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"username"]];
                strUrl = [strUrl stringByAppendingString:parameter];
                strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:strUrl];
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                [request startSynchronous];
                NSError *error = [request error];
                UIAlertView *alert;
                if (!error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSString *response = [request responseString];
                    if ([response isEqualToString:@"1"]) {
                        [[NSUserDefaults standardUserDefaults]setObject:[[[accountResponse.data objectForKey:@"accounts"] objectForKey:UMShareToSina] objectForKey:@"username"] forKey:@"ACCOUNT_NAME"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"SINA" forKey:@"ACCOUNT_TYPE"];
                        alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登录成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }
                    else if ([response isEqualToString:@"-9"]){
                        alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器连接异常!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }
                }
                else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器连接异常!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }];
        }
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
