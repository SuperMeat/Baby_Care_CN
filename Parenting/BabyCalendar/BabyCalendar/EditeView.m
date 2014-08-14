//
//  EditeView.m
//  BabyCalendar
//
//  Created by will on 14-6-26.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "EditeView.h"

@implementation EditeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (IBAction)cancelAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editeViewDidCancel)]) {
        [self.delegate editeViewDidCancel];
    }
}

- (IBAction)doneAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editeViewDidDone)]) {
        [self.delegate editeViewDidDone];
    }
}
@end
