//
//  LoginView.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-10-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginMainViewController.h"
#import "MBProgressHUD.h"
#import "DataContract.h"
#import "NetWorkConnect.h"

@interface LoginView : UIView{
    BOOL isPushSocialView;
}

@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) UIViewController *mainViewController;

-(id)initWithFrame:(CGRect)frame;  
@end
