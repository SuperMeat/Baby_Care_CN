//
//  VaccineAddView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VaccineAddHeaderView;
@class VaccineAddContentView;
@interface VaccineAddView : UIView
{
    VaccineAddHeaderView* _headerView;
    VaccineAddContentView* _contentView;
}
@end
