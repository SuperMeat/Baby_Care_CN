//
//  LoginViewController.h
//  LoginModule
//
//  Created by CHEN WEIBIN on 13-12-26.
//  Copyright (c) 2013年 CHEN WEIBIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UIAlertViewDelegate>
{
    BOOL isPushSocialView;
}

@property (weak, nonatomic) IBOutlet UIView *viewButtons;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;

-(id)initWithRootViewController:(UIViewController*)rootViewController;
@end
