//
//  FeedActivityViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-4-7.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "FeedActivityViewController.h"

@interface FeedActivityViewController ()

@end

@implementation FeedActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self=[super init];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

+(id)shareViewController
{
    static dispatch_once_t pred = 0;
    __strong static FeedActivityViewController* _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
