//
//  LoginMainViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-31.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginMainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    NSArray *arrData;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

+(BOOL)validateEmail:(NSString*)email;

@end
