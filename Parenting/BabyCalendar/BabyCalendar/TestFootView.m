//
//  TestFootView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TestFootView.h"
#import "TestQuestionModel.h"
@implementation TestFootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setModel:(TestQuestionModel *)model
{
    _model = model;
    
    NSInteger answer = [_model.answer integerValue];
    
    [self btnState:answer];
    
    
}


- (void)btnState:(NSInteger)answer
{
    _btnCan.selected = NO;
    _btnCannot.selected = NO;
    _btnUnclear.selected = NO;
    
    if (answer == kAnswer_can) {
        _btnCan.selected = YES;
        _btnCannot.selected = NO;
        _btnUnclear.selected = NO;
    }
    if (answer == kAnswer_cannot) {
        _btnCan.selected = NO;
        _btnCannot.selected = YES;
        _btnUnclear.selected = NO;
    }
    if (answer == kAnswer_unclear) {
        _btnCan.selected = NO;
        _btnCannot.selected = NO;
        _btnUnclear.selected = YES;
    }
}

- (void)nextTest
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_next_test object:nil];
}
- (IBAction)canAction:(id)sender {
    UIButton* btn = (UIButton*)sender;
    [self btnState:btn.tag];
    
    if ([self.delegate respondsToSelector:@selector(testFootView_can:)]) {
        [self.delegate testFootView_can:_index];
    }
    [self nextTest];
}

- (IBAction)cannotAction:(id)sender {
    UIButton* btn = (UIButton*)sender;
    [self btnState:btn.tag];
    if ([self.delegate respondsToSelector:@selector(testFootView_cannot:)]) {
        [self.delegate testFootView_cannot:_index];
    }
    [self nextTest];
}

- (IBAction)unclearAction:(id)sender {
    UIButton* btn = (UIButton*)sender;
    [self btnState:btn.tag];
    if ([self.delegate respondsToSelector:@selector(testFootView_unclear:)]) {
        [self.delegate testFootView_unclear:_index];
    }
    [self nextTest];
}
@end
