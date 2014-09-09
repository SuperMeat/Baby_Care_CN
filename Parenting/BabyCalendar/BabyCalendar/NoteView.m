//
//  NoteView.m
//  BabyCalendar
//
//  Created by will on 14-5-26.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "NoteView.h"
#import "NoteModel.h"

@implementation NoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor lightGrayColor];
        
        
        [self _initViews];
    }
    return self;
}


- (void)_initViews
{
    
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil] lastObject];
    _headerView.delegate = self;
    _moodView = [[[NSBundle mainBundle] loadNibNamed:@"MoodView" owner:self options:nil] lastObject];
    _moodView.hidden = YES;
    _moodView.delegate = self;
    
    _picView = [[[NSBundle mainBundle] loadNibNamed:@"PicView" owner:self options:nil] lastObject];
    _picView.left = 10;
    _picView.delegate = self;

    
    _contentView = [[[NSBundle mainBundle] loadNibNamed:@"ContentView" owner:self options:nil] lastObject];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.delegate = self;

    
}

- (void)setModel:(NoteModel *)model
{
    _model = model;
    
    _headerView.model = _model;
    _contentView.model = _model;
    _picView.model = _model;
    _moodView.index = [_model.mood integerValue];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _headerView.top = 10;
    _headerView.left = 10;
    [self addSubview:_headerView];
    
    _moodView.top = _headerView.bottom-11;
    [self addSubview:_moodView];
    
    _picView.top = _headerView.bottom;
    [self addSubview:_picView];
    
    _contentView.frame = CGRectMake(10, _picView.bottom, kDeviceWidth-20, _contentView.height-40);
    _contentView.delegate = self;
    [self addSubview:_contentView];
    
}
#pragma mark - HeaderView delegate
- (void)moodClick
{

    [UIView animateWithDuration:.3f animations:^{
 
        _moodView.hidden = !_moodView.hidden;
        if (_moodView.hidden) {
            _picView.top = _headerView.bottom;
            _contentView.top = _picView.bottom;
        }else
        {
            _picView.top = _moodView.bottom;
            _contentView.top = _picView.bottom;
        }
        
    }];
}
- (void)addPhoto:(UIImage*)image
{
    
    NSMutableArray* pics = _picView.pics;
    [pics addObject:image];
    _picView.pics = pics;

    
}

#pragma mark - PicView delegate
- (void)picView_pics:(PicView*)picView
{
    if (picView.pics.count >= 3) {
        _headerView.addPhotoView.index = 0;
    }else
    {
        _headerView.addPhotoView.index = 1;
    }
    
    //
    float h = 0;
    if (picView.pics.count == 0) {
        _picView.height = 0;
        
    }else
    {
        _picView.height = 70;
        h = -70;
        
    }
    _contentView.top = _picView.bottom;
    _contentView.height = kDeviceHeight-64-10-70-80+h;
    [_contentView.textView setNeedsDisplay];
}
#pragma mark - ContentViewDelegate

- (void)contentView_textViewDidBeginEditing
{
    if ([self.delegate respondsToSelector:@selector(noteView_textViewDidBeginEditing)]) {
        [self.delegate noteView_textViewDidBeginEditing];
    }
}
- (void)contentView_textViewDidEndEditing
{
    if ([self.delegate respondsToSelector:@selector(noteView_textViewDidEndEditing)]) {
        [self.delegate noteView_textViewDidEndEditing];
    }
}

#pragma mark - MoodView delegate
- (void)moodViewDidselected:(NSInteger)index
{
    _headerView.index = index;
    _moodView.hidden = YES;
    
    [UIView animateWithDuration:.3f animations:^{
        
        _picView.top = _headerView.bottom;
        _contentView.top = _picView.bottom;
    
    }];
}
@end
