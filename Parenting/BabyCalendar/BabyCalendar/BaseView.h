//
//  BaseView.h
//  BabyCalendar
//
//  Created by will on 14-6-10.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
@interface BaseView : UIView
{
    LoadingView* _loadingView;
}

- (void)alertView:(NSString*)text;
- (void)alertViewAtWindow:(NSString*)text;
@end
