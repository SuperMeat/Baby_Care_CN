//
//  FootView.m
//  BabyCalendar
//
//  Created by will on 14-5-28.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "FootView.h"

@implementation FootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (IBAction)leftAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(footView_left)]) {
        [self.delegate footView_left];
    }
}

- (IBAction)rightAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(footView_right)]) {
        [self.delegate footView_right];
    }
}

- (IBAction)deleteAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(footView_delete)]) {
        [self.delegate footView_delete];
    }
}
@end
