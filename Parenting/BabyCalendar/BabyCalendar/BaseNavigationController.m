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
