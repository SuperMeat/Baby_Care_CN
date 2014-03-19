//
//  ACBaseTabBarController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-19.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.

#import <UIKit/UIKit.h>

@interface ACTabBarController : UITabBarController<UITabBarControllerDelegate>{
    
    NSArray *btnImages;
    NSArray *btnHLightImages;
    NSArray *titles;
    int currentSelectedIndex;

}

@property (nonatomic, assign) int currentSelectedIndex;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) NSMutableArray *lable;

- (void)initResourece;
- (void)initCustomTabbar;
- (void)setBtnImages:(NSArray*)theBtnImages;
- (void)setBtnHLightImages:(NSArray*)theBtnHLightImages;
- (void)setTabBarTitle:(NSArray*)theTitles;


@end
