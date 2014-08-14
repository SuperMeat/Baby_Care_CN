//
//  HeaderView.m
//  BabyCalendar
//
//  Created by will on 14-5-26.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "HeaderView.h"
#import "NoteModel.h"
@implementation HeaderView

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
    self.backgroundColor = [UIColor whiteColor];
    _addPhotoView.delegate  = self;
    _addPhotoView.index = 1;
    _addPhotoView.canTap = YES;
    
}
- (void)setModel:(NoteModel *)model
{
    _model = model;
    
    _labDate.text = _model.date;
    
    
    NSDate* date = [BaseMethod dateFormString:_model.date];
    NSString* weekday = [BaseMethod weekdayFromDate:date];
    NSString* nongli = [BaseMethod LunarForSolar:date];
    _labWeek.text = [NSString stringWithFormat:@"%@，%@",weekday,nongli];
    
    self.index = [_model.mood integerValue];
    
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    NSString* image = [NSString stringWithFormat:@"btn_mood_%d",_index];
    [_btnMood setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (IBAction)moodAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(moodClick)]) {
        [self.delegate moodClick];
    }
}

#pragma mark - PortraitImageViewDelegate

- (void)PortraitImageView_changeImage:(PortraitImageView*)portraitImageView
{
    if ([self.delegate respondsToSelector:@selector(addPhoto:)]) {
        [self.delegate addPhoto:portraitImageView.image];
    }
    _addPhotoView.image = [UIImage imageNamed:@"btn_photo"];
}
- (void)PortraitImageView_scaleImage:(PortraitImageView*)portraitImageView
{
    [self alertViewAtWindow:@"最多添加三张照片"];
}

@end
