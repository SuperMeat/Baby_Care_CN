//
//  ACLabel.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-5-20.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "ACLabel.h"

@implementation ACLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.font = [UIFont systemFontOfSize:MIDTEXT];
        self.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
