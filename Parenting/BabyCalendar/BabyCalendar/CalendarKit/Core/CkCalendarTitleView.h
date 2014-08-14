//
//  CkCalendarTitleView.h
//  MBCalendarKit
//
//  Created by Will on 14-3-9.
//  Copyright (c) 2014年 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CkCalendarTitleView;
@protocol CkCalendarTitleViewDataSource <NSObject>

- (NSString *)titleForHeader:(CkCalendarTitleView *)header;


@end
@protocol CkCalendarTitleViewDelegate <NSObject>

- (void)forwardTapped;
- (void)backwardTapped;

@end
@interface CkCalendarTitleView : UIView
{
    UILabel* _labDate;
    UIButton* _btnForward;
    UIButton* _btnBackward;
    
}
@property(nonatomic,retain)UILabel* labDate;
@property(nonatomic,assign)id<CkCalendarTitleViewDataSource> dataSource;
@property(nonatomic,assign)id<CkCalendarTitleViewDelegate> delegate;
@end
