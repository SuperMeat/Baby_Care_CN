//
//  LoadingView.h
//  MySafedog
//
//  Created by will on 14-2-14.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    ProgressViewTypeLoading = 1,
    ProgressViewTypeScreen,
    ProgressViewTypeAlert,
    ProgressViewTypeScreenNoneActivi,
    
}ProgressViewType;

@interface LoadingView : UIView
{
    
    UILabel* _textLabel;
    BOOL _reset;

}
@property(nonatomic,retain)UIActivityIndicatorView* activityView;
@property(nonatomic,copy)NSString* text;
@property(nonatomic,assign)ProgressViewType type;
+ (id)initLoadingView;

- (void)show:(UIView*)view;

- (void)hide;

@end
