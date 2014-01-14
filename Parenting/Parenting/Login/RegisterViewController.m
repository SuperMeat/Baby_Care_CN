//
//  RegisterViewController.m
//  LoginModule
//
//  Created by CHEN WEIBIN on 13-12-26.
//  Copyright (c) 2013年 CHEN WEIBIN. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginMainViewController.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "MD5.h"
#import "APService.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1]];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1]];
    
    //UINavigationItem stuff
    self.tableView.scrollEnabled = NO;
    self.navigationItem.title = NSLocalizedString(@"navRegister", nil);
    
    UIButton *backbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setBackgroundImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 34, 28)];
    title.backgroundColor = [UIColor clearColor];
    [title setTextAlignment:NSTextAlignmentCenter];
    title.textColor = [UIColor whiteColor];
    title.text = NSLocalizedString(@"navback", nil);
    title.font = [UIFont systemFontOfSize:14];
    [backbutton addSubview:title];
    
    [backbutton addTarget:self action:@selector(doGoBack) forControlEvents:UIControlEventTouchUpInside];
    backbutton.frame=CGRectMake(0, 0, 44, 28);
    
    UIBarButtonItem *backbar=[[UIBarButtonItem alloc]initWithCustomView:backbutton];
    self.navigationItem.leftBarButtonItem=backbar;
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"btn1.png"] forState:UIControlStateNormal];
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 28)];
    title1.backgroundColor = [UIColor clearColor];
    [title1 setTextAlignment:NSTextAlignmentCenter];
    title1.textColor = [UIColor whiteColor];
    title1.text =NSLocalizedString(@"navRegister", nil);
    title1.font = [UIFont systemFontOfSize:14];
    [rightButton addSubview:title1];
    [rightButton addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame=CGRectMake(0, 0, 44, 28);
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;

    arrData = @[@"邮箱",@"密码",@"重复"];
}

-(void)doGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doRegister{
    //输入判断
    UITextField *inputEmail = (UITextField*)[_tableView viewWithTag:1];
    UITextField *inputPd = (UITextField*)[_tableView viewWithTag:3];
    UITextField *inputRePd = (UITextField*)[_tableView viewWithTag:4];
    
    if ([inputEmail.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"邮箱地址不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (![LoginMainViewController validateEmail:inputEmail.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"邮箱格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    if ([inputPd.text isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (inputPd.text.length < 6) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"密码长度至少要求6位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if ([inputRePd.text isEqual:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"重复密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (inputRePd.text.length < 6) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"重复密码长度至少要求6位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (![inputPd.text isEqualToString:inputRePd.text]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"输入密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    //注册接口
    NSString* strUrl = [ASIHTTPADDRESS stringByAppendingString:@"/BaseService.svc/register/"];
    strUrl = [strUrl stringByAppendingString:[MD5 md5:ASIHTTPTOKEN]];
    NSString* openudid = [@"/" stringByAppendingString:[APService openUDID]];
    strUrl = [strUrl stringByAppendingString:openudid];
    
    NSString* parameter = [NSString stringWithFormat:@"/%@/%@/APP",inputEmail.text,[MD5 md5:inputPd.text]];
    strUrl = [strUrl stringByAppendingString:parameter];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //隐藏键盘
    [inputEmail resignFirstResponder];
    [inputPd resignFirstResponder];
    [inputRePd resignFirstResponder];
    hud.yOffset = -60.0f;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.alpha = 0.5;
    hud.color = [UIColor grayColor];
    hud.labelText = @"注册中...";
    
	[request startSynchronous];
	NSError *error = [request error];
    UIAlertView *alert;
	if (!error) {
		NSString *response = [request responseString];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([response isEqualToString:@"1"]) {
            [[NSUserDefaults standardUserDefaults]setObject:inputEmail.text forKey:@"ACCOUNT_NAME"];
            [[NSUserDefaults standardUserDefaults] setObject:@"APP" forKey:@"ACCOUNT_TYPE"];
            alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else if ([response isEqualToString:@"-1"]){
            alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"账户名已存在,请重新选择您的账户名!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.message isEqual: @"注册成功!"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma textfield protocol
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doRegister];
    return YES;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UILabel *title;
    UITextField *input;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, 48, 32)];
        title.text = [arrData objectAtIndex:indexPath.row];
        input = [[UITextField alloc]initWithFrame:CGRectMake(80,7, 180, 32)];
        input.returnKeyType =UIReturnKeyDone;
        input.delegate = self;
        
        if (indexPath.row == 0) {
            input.tag = 1;
            input.placeholder = @"请输入邮箱地址";
            input.keyboardType = UIKeyboardTypeEmailAddress;
            input.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [input becomeFirstResponder];
            
        }
//        else if (indexPath.row == 1){
//            input.tag = 2;
//            input.placeholder = @"请输入昵称";
//            input.keyboardType = UIKeyboardTypeDefault;
//        }
        else if (indexPath.row == 1){
            input.tag = 3;
            input.placeholder = @"请输入密码";
            input.secureTextEntry = YES;
        }
        else if (indexPath.row == 2){
            input.tag = 4;
            input.placeholder = @"请输入密码";
            input.secureTextEntry = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:input];
        title.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:title];
    }
    return cell;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
