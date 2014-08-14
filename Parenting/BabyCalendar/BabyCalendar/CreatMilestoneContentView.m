//
//  CreatMilestoneContentView.m
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "CreatMilestoneContentView.h"
#import "MilestoneModel.h"
@implementation CreatMilestoneContentView

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
    [_textView setFont:[UIFont fontWithName:@"BaroqueScript" size:14]];
    [_textView setTextColor:UIColorFromRGB(kColor_textViewText)];
    
    [self addKeyboardNotif];
}

- (void)layoutSubviews

{
    [super layoutSubviews];
    
    if (_disMoveH > 0) {
        self.height = _disMoveH;
    }
    _textView.height = self.height;

}

- (void)setModel:(MilestoneModel *)model
{
    _model = model;
    
    _textView.text = _model.content;
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
    
    if ([self.delegate respondsToSelector:@selector(CreatMilestoneContentView_textViewDidBeginEditing:)]) {
        [self.delegate CreatMilestoneContentView_textViewDidBeginEditing:self];
    }

    
    // 获取键盘动态高度
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    CGFloat distanceToMove = kbSize.height;


    [UIView animateWithDuration:.3f animations:^{
        _disMoveH = kDeviceHeight-64-distanceToMove-10;

    }];
    [_textView setNeedsDisplay];
    

}

- (void)handleKeyboardWillHide:(NSNotification*)notification
{
    _disMoveH = 0;
    if ([self.delegate respondsToSelector:@selector(CreatMilestoneContentView_keyboardHided:)]) {
        [self.delegate CreatMilestoneContentView_keyboardHided:self];
    }
    [_textView setNeedsDisplay];
    
}

#pragma mark - textView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    if ([self.delegate respondsToSelector:@selector(CreatMilestoneContentView_textViewDidBeginEditing:)]) {
//        [self.delegate CreatMilestoneContentView_textViewDidBeginEditing:self];
//    }
    
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
