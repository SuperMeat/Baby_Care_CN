//
//  ZhuView.h
//  BabyCalendar
//
//  Created by Will on 14-6-14.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZhuModel;
@interface ZhuView : UIView
{
    __weak IBOutlet UILabel *_labTitle;
    __weak IBOutlet UILabel *_labValue;
    __weak IBOutlet UIView *_valueView;
    
    UIImageView* _bgView;
    
}
@property(nonatomic,retain)ZhuModel* model;
@property(nonatomic,assign)NSInteger superViewHeight;
@end
