//
//  CustomUISwitchView.h
//  BabyCalendar
//
//  Created by Will on 14-8-2.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomUISwitchView;
@protocol CustomUISwitchViewDelegate <NSObject>

- (void)customUISwitchViewTap:(CustomUISwitchView*)switchView;

@end
@interface CustomUISwitchView : UIImageView
{
    UIImage* _imageYES;
    UIImage* _imageNO;
}

@property(nonatomic,assign)id<CustomUISwitchViewDelegate> delegate;
@property(nonatomic,assign)BOOL on;

- (id)initWithImageYES:(UIImage*)imageYES WithImageNO:(UIImage*)imageNO;
@end
