//
//  GuideViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-11-26.
//  Copyright (c) 2013年 奥芬多. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaultAppDelegate.h"

@interface GuideViewController : UIViewController<UIScrollViewDelegate>

@property NSInteger fitHeight;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIPageControl *pageControl;
@property (strong,nonatomic) NSMutableArray *slideImages;
@property (strong,nonatomic) UIViewController   *nextViewController;

-(id)initWithRootViewController:(UIViewController*)rootViewController;

@end
