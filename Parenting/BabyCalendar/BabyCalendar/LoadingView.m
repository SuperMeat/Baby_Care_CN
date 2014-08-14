//
//  LoadingView.m
//  MySafedog
//
//  Created by will on 14-2-14.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#define kWidth    10
@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initViews];
   
    }
    return self;
}


+(id)initLoadingView
{
    LoadingView* loadingView = [[LoadingView alloc] init];
    return loadingView;
    
}

- (void)initViews
{
    
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self addSubview:_activityView];
    
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_textLabel setBackgroundColor:[UIColor clearColor]];
    [_textLabel setTextColor:[UIColor whiteColor]];
    [_textLabel setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:_textLabel];
}

- (void)setText:(NSString *)text
{
    [_textLabel setText:text];
    [_textLabel sizeToFit];
}

- (void)setType:(ProgressViewType)type
{
    _type = type;
    if (_type == ProgressViewTypeLoading) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        self.layer.cornerRadius = 10;
    }else if(_type == ProgressViewTypeScreen || _type == ProgressViewTypeScreenNoneActivi)
    {
        self.layer.cornerRadius = 0;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }else
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        self.layer.cornerRadius = 8;
        
    }
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_type == ProgressViewTypeLoading) {
        self.frame = CGRectMake((320-_textLabel.width)/2-kWidth, ([self superview].height-100)/2, _textLabel.width+kWidth*2, _textLabel.height+50+10);
        
        [_activityView setFrame:CGRectMake((self.width)/2, (self.height/2-50)/2+5, 0, 50)];
        CGPoint point = _activityView.center;
        point.y = _activityView.bottom+10;
        _textLabel.center = point;
        
    }else if(_type == ProgressViewTypeScreen || _type == ProgressViewTypeScreenNoneActivi)
    {
        [_activityView setFrame:CGRectMake((self.width)/2, (self.height-100)/2, 0, 50)];
        CGPoint point = _activityView.center;
        point.y = _activityView.bottom+10;
        _textLabel.center = point;
    }else
    {
        self.frame = CGRectMake((320-_textLabel.width)/2-kWidth, ([self superview].height-_textLabel.height+kWidth*2)/2, _textLabel.width+kWidth*2, _textLabel.height+kWidth*2);
        
        CGRect rect = _textLabel.frame;
        rect.origin.x = kWidth;
        rect.origin.y = kWidth;
        _textLabel.frame = rect;
        
        
    }
    
    
    
    
}

- (void)show:(UIView*)view
{
    if (_type == ProgressViewTypeAlert) {
        [_activityView stopAnimating];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hide) userInfo:nil repeats:NO];
    }else if(_type == ProgressViewTypeScreenNoneActivi)
    {
        [_activityView stopAnimating];
    }
    else
    {
        [_activityView startAnimating];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    [view addSubview:self];
    

}

- (void)hide
{
    [_activityView stopAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }];
    
    
}

@end
