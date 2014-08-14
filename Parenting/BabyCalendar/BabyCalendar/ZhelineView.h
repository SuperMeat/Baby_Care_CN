//
//  ZhelineView.h
//  MySafedog
//
//  Created by will on 14-2-25.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Zheline;
@interface ZhelineView : UIView<UIScrollViewDelegate>
{
    UIScrollView* _pSc;
    UIScrollView* _ySc;
    UIScrollView* _xSc;
    int HeightSc;
}
@property(nonatomic,retain)NSArray* points;
@property(nonatomic,retain)NSMutableArray* timeArr;
@property(nonatomic)BOOL bColorGreen;
@end
