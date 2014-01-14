//
//  MMXTabBarController.m
//  NewMC
//
//  Created by apple  on 12-9-21.
//
//

#import "MMXTabBarController.h"

@interface MMXTabBarController ()

@end

@implementation MMXTabBarController
@synthesize currentSelectedIndex=_currentSelectedIndex,buttons,lable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate=self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self setBtnImages:nil];
    [self setBtnHLightImages:nil];
    static dispatch_once_t pred = 0;
    
    dispatch_once(&pred, ^{
        [self initCustomTabbar];
        
    });

}

- (void)viewDidAppear:(BOOL)animated
{
//    CGRect frame = [[UIScreen mainScreen] bounds];
//    self.view.frame = CGRectMake(0, 0, 320, frame.size.height+4);
//    [super viewDidAppear:YES];
//    [self setBtnImages:nil];
//    [self setBtnHLightImages:nil];
//    static dispatch_once_t pred = 0;
//    
//    dispatch_once(&pred, ^{
//        [self initCustomTabbar];
//        
//    });

}

- (void)setBtnImages:(NSArray*)theBtnImages
{
    btnImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"menu1.png"],[UIImage imageNamed:@"menu2.png"],[UIImage imageNamed:@"menu3.png"],[UIImage imageNamed:@"menu4.png"], nil];
}

- (void)setBtnHLightImages:(NSArray*)theBtnHLightImages
{
    btnHLightImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"menu1_focus.png"],[UIImage imageNamed:@"menu2_focus.png"],[UIImage imageNamed:@"menu3_focus.png"],[UIImage imageNamed:@"menu4_focus.png"], nil];
}

- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
            [view setBackgroundColor:[UIColor clearColor]];
			break;
		}
	}
}

- (void)hideExistingTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}
- (void)showCustomerTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if(view.tag>=200)
		{
            [UIView animateWithDuration:.6 animations:^{
                view.alpha = 1;
            }];
		}
	}
}
- (void)hideCustomerTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if(view.tag>=200)
		{
			[UIView animateWithDuration:.4 animations:^{
                view.alpha = 0;
            }];
		}
	}
}

//- (void)setViewControllers:(NSArray *)viewControllers{
//    
//}

- (void)initCustomTabbar
{
    UIView *tab_view = [[UIView alloc] init];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    if (frame.size.height >= 568) {
        tab_view.frame = CGRectMake(0, 499, 320, 49);
    }else{
        tab_view.frame = CGRectMake(0, 411, 320, 49);
    }
    tab_view.tag = 220;
    [tab_view setClipsToBounds:YES];
    
    int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    
    NSString *home=NSLocalizedString(@"tabbarhome", nil);
    NSString *summary=NSLocalizedString(@"tabbarsummary", nil);
    NSString *advise=NSLocalizedString(@"InformationCenter", nil);
    NSString *settings=NSLocalizedString(@"tabbarsettings", nil);
    
    NSArray *ta=@[home,summary,advise,settings];
    
	for (int i = 0; i < viewCount; i++) {
		UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(320/self.viewControllers.count*i, -4, 320/self.viewControllers.count, self.tabBar.frame.size.height+4)];
        [btn setBackgroundImage:[btnImages objectAtIndex:i] forState:UIControlStateNormal];
        [btn setBackgroundImage:[btnHLightImages objectAtIndex:i]  forState:UIControlStateDisabled];
        [btn setBackgroundImage:[btnHLightImages objectAtIndex:i] forState:UIControlStateHighlighted];
        [btn setTag:200+i];
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [btn setShowsTouchWhenHighlighted:NO];
        [btn setHighlighted:NO];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
		[self.buttons addObject:btn];
        [self.tabBar addSubview:btn];

        [btn setTitle:ta[i] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor colorWithRed:0x7B/255.0 green:0x7A/255.0 blue:0x75/255.0 alpha:0xFF/255.0] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0x55/255.0 green:0x54/255.0 blue:0x4A/255.0 alpha:1] forState:UIControlStateDisabled];
        
        

	}
    

	[self selectedTab:[self.buttons objectAtIndex:0]];
    
    [self addObserver:self forKeyPath:@"selectedIndex" options:0 context:nil];
}

- (void)selectedTab:(UIButton*)theBtn
{
    [theBtn setEnabled:NO];
    for (UIButton *btn in self.buttons) {
        if (btn!=theBtn) {
            [btn setEnabled:YES];
        }
    }

    [self setSelectedIndex:theBtn.tag-200];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    int i=0;
    for (UITabBarItem *it in tabBar.items) {
        if ([it isEqual:item]) {
        }
        i++;
    }
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIButton *button=[self.buttons objectAtIndex:self.selectedIndex];
    if (!button.enabled) {
        return;
    }
    else{
    [self selectedTab:button];
    }
}

@end
