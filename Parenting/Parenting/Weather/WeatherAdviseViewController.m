//
//  WeatherAdviseViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-11-28.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import "WeatherAdviseViewController.h"

@interface WeatherAdviseViewController ()

@end

@implementation WeatherAdviseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithAdviseData:(AdviseData*)adata andAdviseLevel:(AdviseLevel *)alevel
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.ad = adata;
        self.al = alevel;
        if (self) {
            self.hidesBottomBarWhenPushed=YES;
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
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.al.mLevel == 1) {
        self.detailBtn.tintColor = [UIColor greenColor];
    }
    else if (self.al.mLevel == 2)
    {
        self.detailBtn.tintColor = [UIColor yellowColor];
    }
    else
    {
        self.detailBtn.tintColor = [UIColor redColor];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailBtn = _detailBtn;
    self.detail    = _detail;
    // Do any additional setup after loading the view from its nib.
    self.detail.text      = self.ad.mContent;
    self.detail.textColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
