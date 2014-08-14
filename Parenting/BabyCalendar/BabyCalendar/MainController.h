//
//  MainController.h
//  BabyCalendar
//
//  Created by Will on 14-5-18.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemView.h"
@interface MainController : UITabBarController<ItemViewDelegate>
{
    UIImageView* _bgTabBarView;
    UIImageView* _selectView;
}

// 显示或隐藏tabbar
- (void)showOrHideTabBar:(BOOL)isHidden;
@end
