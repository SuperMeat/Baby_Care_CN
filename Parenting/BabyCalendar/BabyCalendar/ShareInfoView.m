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
        self.iconDetail.textColor  = [ACFunction colorWithHexString:kShareImageIconFontColor];
        self.titleDetail.textColor = [ACFunction colorWithHexString:kShareImageFontColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//    [self bringSubviewToFront:self.titleDetail];
//    [self bringSubviewToFront:self.shareInfoImageView];
//    [self bringSubviewToFront:self.iconImageView];
//    [self bringSubviewToFront:self.iconDetail];
//    [self setBackgroundColor:[UIColor redColor]];
//}

@end
