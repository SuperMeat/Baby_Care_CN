//
//  ACBaseTabBarController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-19.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.

#import "ACConfig.h"

@interface ACTabBarController : UITabBarController<UITabBarControllerDelegate>{
    
    NSArray *btnImages;           //图片默认
    NSArray *btnHLightImages;     //图片高亮
    NSArray *titles;              //标题
    int     currentSelectedIndex;

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
