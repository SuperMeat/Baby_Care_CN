//
//  TestMiddleView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "TestMiddleView.h"
#import "TestQuestionModel.h"
@implementation TestMiddleView

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
    _textView.textColor = UIColorFromRGB(kColor_test_TextViewText);
    _textView.font = [UIFont fontWithName:kFont size:15.f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextAction:) name:kNotifi_next_test object:nil];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _textView.height = self.height - 70-30;
    _labPage.top = _textView.bottom;
    
    
    
}

- (void)setDatas:(NSMutableArray *)datas
{
    _datas = datas;
    
    [self question_num:_datas];
    
}

- (void)question_num:(NSMutableArray*)datas
{
    TestQuestionModel* model = _datas[_index];
    _textView.text = model.content;
    
    _labPage.text = [NSString stringWithFormat:@"%d/%d",_index+1,_datas.count];
    
    [self testType:model.type];
}
- (void)testType:(NSString*)type
{
    if ([type isEqualToString:kTest_type_active]) {
        _moodView.selected = YES;
        _knowledgeView.selected = YES;
        _lanuageView.selected = YES;
        _moveView.selected = NO;
    }
    if ([type isEqualToString:kTest_type_knowledge]) {
        _moodView.selected = YES;
        _knowledgeView.selected = NO;
        _lanuageView.selected = YES;
        _moveView.selected = YES;
    }
    if ([type isEqualToString:kTest_type_language]) {
        _moodView.selected = YES;
        _knowledgeView.selected = YES;
        _lanuageView.selected = NO;
        _moveView.selected = YES;
    }
    if ([type isEqualToString:kTest_type_society]) {
        _moodView.selected = NO;
        _knowledgeView.selected = YES;
        _lanuageView.selected = YES;
        _moveView.selected = YES;
    }
}



- (IBAction)nextAction:(id)sender {
    
    _index++;
    if (_index > _datas.count-1) {
        _index--;
        [self alertView:@"已经是最后一道题目了"];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"测评已完成，需要检查一下吗？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alertView show];
        return;
    }
    
    [self question_num:_datas];
    
    if ([self.delegate respondsToSelector:@selector(testMiddleView_next:)]) {
        [self.delegate testMiddleView_next:_index];
    }
}

- (IBAction)backAction:(id)sender {
    
    _index--;
    if (_index < 0) {
        _index++;
        [self alertView:@"已经是第一道题目了"];
        return;
    }
    [self question_num:_datas];
    
    if ([self.delegate respondsToSelector:@selector(testMiddleView_back:)]) {
        [self.delegate testMiddleView_back:_index];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_done_test object:nil];
    }
}

#pragma mark - UITextView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // to update NoteView
    [_textView setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
