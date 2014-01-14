//
//  AdviseScrollview.h
//  Amoy Baby Care
//
//  Created by user on 13-6-20.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdviseScrollview : UIView<UIScrollViewDelegate>
- (id)initWithArray:(NSArray*)array;
@property(nonatomic,strong)UIScrollView *myscroll;
@property(nonatomic,strong)UIPageControl *mypagecontrol;
@end
