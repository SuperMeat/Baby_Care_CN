//
//  MilestoneContentView.m
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "MilestoneContentView.h"

@implementation MilestoneContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    _textView.delegate = self;
    [_textView setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:14]];
    [_textView setTextColor:UIColorFromRGB(kColor_textViewText)];
    
    _labTitle.font = [UIFont fontWithName:kFont size:15.f];
    
    [self addKeyboardNotif];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _textView.height = self.height - 55;
    
}

- (void)addKeyboardNotif
{
    //键盘通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)handleKeyboardDidShow:(NSNotification*)notification
{
    if (!_textView.isFirstResponder) {
        return;
    }
    
    
    // 获取键盘动态高度
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    CGFloat distanceToMove = kbSize.height;
    
    
    [UIView animateWithDuration:.3f animations:^{
        _disMoveH = kDeviceHeight-64-distanceToMove-10;
        self.superview.top = -distanceToMove;
        
    }];
    [_textView setNeedsDisplay];
    
    
}

- (void)handleKeyboardWillHide:(NSNotification*)notification
{
    [UIView animateWithDuration:.3f animations:^{
        self.superview.top = 0;
        
    }];
    [_textView setNeedsDisplay];
    
}
#pragma mark - UITextView delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
