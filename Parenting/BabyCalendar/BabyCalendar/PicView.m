//
//  PicView.m
//  BabyCalendar
//
//  Created by will on 14-7-1.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "PicView.h"
#import "NoteModel.h"
#import "NoteView.h"
@implementation PicView

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
    
    self.pics = [NSMutableArray array];
    
    _picView1.delegate = self;
    _picView2.delegate = self;
    _picView3.delegate = self;
}

- (void)setPics:(NSMutableArray *)pics
{
    _pics = pics;
    
    _picView1.image = nil;
    _picView2.image = nil;
    _picView3.image = nil;
    
    int index = 0;
    for (UIImage* image in _pics) {
        if (index == 0) {
            [_picView1 setImage:image];
        }
        if (index == 1) {
            [_picView2 setImage:image];
        }
        if (index == 2) {
            [_picView3 setImage:image];
        }
        
        
        index++;
        
    }
    
    if ([self.delegate respondsToSelector:@selector(picView_pics:)]) {
        [self.delegate picView_pics:self];
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}
- (void)setModel:(NoteModel *)model
{
    _model = model;
    
    NSArray* photoPath = [_model.photo componentsSeparatedByString:@"@"];

    [_pics removeAllObjects];
    for (NSString* name in photoPath) {
        NSString *photo_path=[BaseMethod dataFilePath:name];
        UIImage* image = [UIImage imageWithContentsOfFile:photo_path];

        if (image == nil) {
            continue;
        }
        [_pics addObject:image];
    }
    self.pics = _pics;
    
}
- (void)tap:(UITapGestureRecognizer*)tap
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [UIView animateWithDuration:.3f animations:^{
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    } completion:^(BOOL finished) {
        [_btnDelete removeFromSuperview];
        [_scaleView removeFromSuperview];
        _scaleView.image = nil;
    }];
}

- (void)deleteAction
{
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除这张照片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.pics removeObjectAtIndex:_index];
        self.pics = _pics;
        [self tap:nil];
        
    }
}
#pragma mark -  ImageViewTapDelegate
- (void)tapAction:(ImageViewTap*)imgView
{
    if (imgView.image == nil) {
        return;
    }
    
    NoteView* noteView = (NoteView*)self.superview;
    [noteView.contentView.textView resignFirstResponder];
    
    
    if (_scaleView == nil) {
        _scaleView = [[UIImageView alloc] init];
        _scaleView.backgroundColor  =[UIColor blackColor];
        _scaleView.contentMode = UIViewContentModeScaleAspectFit;
        _scaleView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_scaleView addGestureRecognizer:tap];
        
        //
        _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDelete setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        _btnDelete.frame = CGRectMake(kDeviceWidth-50, kDeviceHeight-50, 23, 30);
        [_btnDelete addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    
    _index = imgView.tag;
    
    _scaleView.image = imgView.image;
    _scaleView.frame = imgView.frame;
    _scaleView.top = 160.0f;
    [UIView animateWithDuration:.3f animations:^{
        _scaleView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    } completion:^(BOOL finished) {
        
        [self.window addSubview:_scaleView];
        [self.window addSubview:_btnDelete];
        
    }];
}

@end
