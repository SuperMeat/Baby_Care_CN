//
//  BaseView.m
//  BabyCalendar
//
//  Created by will on 14-6-10.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initObjs];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initObjs];
}
- (void)initObjs
{
    
    _loadingView = [[LoadingView alloc] init];
    
    self.backgroundColor = UIColorFromRGB(kColor_baseView);
}

- (void)alertView:(NSString*)text
{
    [_loadingView setType:ProgressViewTypeAlert];
    [_loadingView setText:text];
    [_loadingView show:self];
    
}

- (void)alertViewAtWindow:(NSString*)text
{
    [_loadingView setType:ProgressViewTypeAlert];
    [_loadingView setText:text];
    [_loadingView show:self.window];
    
}

@end
