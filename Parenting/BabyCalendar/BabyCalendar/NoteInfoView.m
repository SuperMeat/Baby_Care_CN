//
//  NoteInfoView.m
//  BabyCalendar
//
//  Created by will on 14-7-3.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "NoteInfoView.h"
#import "NoteModel.h"
@implementation NoteInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setModel:(NoteModel *)model
{
    _model = model;
    
    _moodView.image = nil;
    _photoView.image = nil;
    _contentView.image = nil;
    
    _moodView.width = 0;
    _photoView.width = 0;
    _contentView.width = 0;
    
    // 心情
    if ([_model.mood intValue] > 0) {
        NSString* image = [NSString stringWithFormat:@"btn_mood_%d",[_model.mood intValue]];
        _moodView.image = [UIImage imageNamed:image];
        _moodView.width = 30;
    }
    // 照片
    if (_model.photo.length > 0) {
        _photoView.image = [UIImage imageNamed:@"btn_photo"];
        _photoView.width = 30;
    }
    // 内容
    if (_model.content.length > 0) {
        _contentView.image = [UIImage imageNamed:@"Calendar"];
        _contentView.width = 30;
    }
    
    
    [self setNeedsLayout];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _contentView.right = self.width-10;
    _photoView.right = _contentView.left;
    _moodView.right = _photoView.left;
}

@end
