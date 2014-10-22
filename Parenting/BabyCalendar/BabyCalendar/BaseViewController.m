//
//  BaseViewController.m
//  MySafedog
//
//  Created by Will on 13-12-26.
//  Copyright (c) 2013年 will. All rights reserved.
//

#import "BaseViewController.h"
#import "UIBarButtonItem+CustomForNav.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        
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

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        NSLog(@"swipe down");
        //执行程序
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        NSLog(@"swipe up");
        //执行程序
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        
        NSLog(@"swipe left");
        //执行程序
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"swipe right");
        //执行程序
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSUInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        UIBarButtonItem* backButtonItem = [UIBarButtonItem customForTarget:self image:@"item_back" title:nil action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        self.view.bounds = CGRectMake(0, 0, self.view.width, self.view.height);
        
    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
    }
    
    _loadingView = [[LoadingView alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)backAction
{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSNumber* push_testReportVc = [userDef objectForKey:kPush_testReportVc];
    if ([push_testReportVc boolValue]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)setTitle:(NSString *)title
{
    UILabel* labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [labTitle setBackgroundColor:[UIColor clearColor]];
    [labTitle setTextColor:[UIColor whiteColor]];
    [labTitle setTextAlignment:NSTextAlignmentCenter];
    [labTitle setFont:[UIFont fontWithName:kFont size:18.f]];
    [labTitle setText:title];
    [labTitle sizeToFit];
    self.navigationItem.titleView = labTitle;
}

- (void)alertView:(NSString*)text
{
    [_loadingView setType:ProgressViewTypeAlert];
    [_loadingView setText:text];
    [_loadingView show:self.view];
    
}

-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    
}

@end
