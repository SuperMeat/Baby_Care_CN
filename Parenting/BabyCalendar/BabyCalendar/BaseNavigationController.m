//
//  BaseNavigationController.m
//  MySafedog
//
//  Created by Will on 13-12-26.
//  Copyright (c) 2013年 will. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UINavigationBar+CustomImage.h"
#import "PublicDefine.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

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
    
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"btn3.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"btn3.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) {
        [[UINavigationBar appearance] setBarTintColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
        
    }
    
    [[UINavigationBar appearance] setBackgroundColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    
    [[UINavigationBar appearance] setTintColor:[ACFunction colorWithHexString:@"0x68bfcc"]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor],
                                                          UITextAttributeTextColor,
                                                          
                                                          [UIFont fontWithName:@"Arival-MTBOLD" size:20],
                                                          
                                                          UITextAttributeFont,
                                                          nil]];

    
//	if (kSystemVersion >= 5) {
//        
//        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg"] forBarMetrics:UIBarMetricsDefault];
//    }else
//    {
//        [self.navigationBar setNeedsDisplay];
//        
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
