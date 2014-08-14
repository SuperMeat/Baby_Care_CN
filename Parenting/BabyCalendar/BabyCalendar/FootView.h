//
//  FootView.h
//  BabyCalendar
//
//  Created by will on 14-5-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"


@protocol FootViewDelegate <NSObject>

- (void)footView_left;
- (void)footView_right;
- (void)footView_delete;

@end

@interface FootView : BaseView
@property(nonatomic,assign)id<FootViewDelegate> delegate;
- (IBAction)leftAction:(id)sender;
- (IBAction)rightAction:(id)sender;
- (IBAction)deleteAction:(id)sender;

@end
