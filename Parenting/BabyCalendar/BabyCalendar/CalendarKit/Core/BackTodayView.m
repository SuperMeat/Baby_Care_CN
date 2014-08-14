//
//  BackTodayView.m
//  BabyCalendar
//
//  Created by will on 14-6-16.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BackTodayView.h"

@implementation BackTodayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (IBAction)backToday:(id)sender {
    if ([self.delegate respondsToSelector:@selector(backTodayViewDidBackToday)]) {
        [self.delegate backTodayViewDidBackToday];
    }
}
@end
