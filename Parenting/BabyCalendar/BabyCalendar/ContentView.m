//
//  ContentView.m
//  BabyCalendar
//
//  Created by will on 14-5-27.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "ContentView.h"
#import "NoteModel.h"
@implementation ContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _textView.delegate = self;

    [_textView setFont:[UIFont fontWithName:@"BaroqueScript" size:14]];
    _textView.textColor = UIColorFromRGB(kColor_textViewText);
    [self addKeyboardNotif];
}



- (void)setModel:(NoteModel *)model
{
    _model = model;
    _textView.text = _model.content;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_disMoveH > 0) {
        return;
    }

    _textView.height = self.height;
}

- (void)addKeyboardNotif
{
    //键盘通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)handleKeyboardDidShow:(NSNotification*)notification
{
    
    // 获取键盘动态高度
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    CGFloat distanceToMove = kbSize.height;
    
    
    [UIView animateWithDuration:.3f animations:^{
        _disMoveH = kDeviceHeight-64-distanceToMove-self.top;
        _textView.height = _disMoveH;
        [_textView setNeedsDisplay];
        
    }];
}

- (void)handleKeyboardWillHide:(NSNotification*)notification
{
    _disMoveH = 0;
    
    [UIView animateWithDuration:.3f animations:^{
        _textView.height = self.height;
    }];
    
    [_textView setNeedsDisplay];
}
#pragma mark - UITextView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(contentView_textViewDidBeginEditing)]) {
        [self.delegate contentView_textViewDidBeginEditing];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(contentView_textViewDidEndEditing)]) {
        [self.delegate contentView_textViewDidEndEditing];
    }
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // to update NoteView
    [_textView setNeedsDisplay];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
