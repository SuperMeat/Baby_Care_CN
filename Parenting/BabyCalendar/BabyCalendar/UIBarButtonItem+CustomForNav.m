//
//  UIBarButtonItem+CustomForNav.m
//  HuShuo
//
//  Created by ZhangJian on 7/15/11.
//  Copyright 2011 yaku.com. All rights reserved.
//

#import "UIBarButtonItem+CustomForNav.h"


@implementation UIBarButtonItem(CustomForNav)
+(UIBarButtonItem*)customForTarget:(id)target
						  image:(NSString *)imageName
						  title:(NSString *)itemTitle
						 action:(SEL)func
							
{
	UIImage  *backimg=[UIImage imageNamed:imageName];
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 20)];
	[backButton addTarget:target action:func forControlEvents:UIControlEventTouchUpInside];
	[backButton setBackgroundImage:backimg forState:UIControlStateNormal];
    
	UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	
	return backButtonItem;
}

+(UIBarButtonItem*)customForTarget2:(id)target action1:(SEL)func1 action2:(SEL)func2
{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    
    UIButton* reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reloadBtn setImage:[UIImage imageNamed:@"ic_home_refresh"] forState:UIControlStateNormal];
    [reloadBtn addTarget:target action:func1 forControlEvents:UIControlEventTouchUpInside];
    [reloadBtn setFrame:CGRectMake(0, 0, 20, 25)];
    [bgView addSubview:reloadBtn];
    
    UIButton* setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setImage:[UIImage imageNamed:@"ic_home_setting"] forState:UIControlStateNormal];
    [setBtn addTarget:target action:func2 forControlEvents:UIControlEventTouchUpInside];
    [setBtn setFrame:CGRectMake(reloadBtn.right+15, 0, 25, 25)];
    [bgView addSubview:setBtn];
    
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    return buttonItem;
    
}

+(UIBarButtonItem*)customForTarget3:(id)target
                             image:(NSString *)imageName
                             title:(NSString *)itemTitle
                            action:(SEL)func

{
	UIImage  *backimg=[UIImage imageNamed:imageName];
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
	[backButton addTarget:target action:func forControlEvents:UIControlEventTouchUpInside];
	[backButton setBackgroundImage:backimg forState:UIControlStateNormal];
    
	UIBarButtonItem* backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	
	return backButtonItem;
}

@end
