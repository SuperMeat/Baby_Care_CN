//
//  ShareInfoView.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-8-15.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "ShareInfoView.h"
@implementation ShareInfoView
@synthesize titleDetail;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[ACFunction colorWithHexString:kShareImageBackgroundColor]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.iconDetail.textColor  = [ACFunction colorWithHexString:kShareImageIconFontColor];
    self.titleDetail.textColor = [ACFunction colorWithHexString:kShareImageFontColor];
    self.titleDetail.font = [UIFont fontWithName:kShareImageFont size:15];

    _shareInfoImageView.top = _headView.bottom+10;
    _footView.top = _shareInfoImageView.bottom+10;
    self.height   = _headView.height + _shareInfoImageView.height + _footView.height;
}

@end
