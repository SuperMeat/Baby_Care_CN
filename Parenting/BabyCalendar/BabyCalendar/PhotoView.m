//
//  PhotoView.m
//  BabyCalendar
//
//  Created by will on 14-5-27.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "PhotoView.h"
#import "NoteModel.h"
@implementation PhotoView

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
    
    _photoView1.contentMode = UIViewContentModeScaleAspectFill;  
}

- (void)tapAction:(UITapGestureRecognizer*)tap
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
     [UIView animateWithDuration:.3f animations:^{
         _scaleView.image = nil;
         [[UIApplication sharedApplication] setStatusBarHidden:NO];
     } completion:^(BOOL finished) {
         [_btnDelete removeFromSuperview];
         [_scaleView removeFromSuperview];
     }];
}

- (void)deleteAction
{
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除这张照片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)setModel:(NoteModel *)model
{
    _model = model;
    _photoView1.image = nil;
    _photoView2.image = nil;
    _photoView3.image = nil;
    
    
    NSArray* photoPath = [_model.photo componentsSeparatedByString:@"@"];
    
    int index = 1;
    for (NSString* name in photoPath) {
        NSString *photo_path=[BaseMethod dataFilePath:name];
        if (index == 1) {
            UIImage* image = [UIImage imageWithContentsOfFile:photo_path];
            _photoView1.image = image;
        }
        if (index == 2) {
            UIImage* image = [UIImage imageWithContentsOfFile:photo_path];
            _photoView2.image = image;
        }
        if (index == 3) {
            _photoView3.image = [UIImage imageWithContentsOfFile:photo_path];
        }
        
        index++;
    }
    
}
#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.portraitImageView.image = nil;
        [self tapAction:nil];
    }
}
#pragma mark - PortraitImageViewDelegate

- (void)PortraitImageView_scaleImage:(PortraitImageView*)portraitImageView
{
    if (_scaleView == nil) {
        _scaleView = [[UIImageView alloc] init];
        _scaleView.backgroundColor  =[UIColor blackColor];
        _scaleView.contentMode = UIViewContentModeScaleAspectFit;
        _scaleView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_scaleView addGestureRecognizer:tap];
        
        //
        _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDelete setImage:[UIImage imageNamed:@"btn_note_delete"] forState:UIControlStateNormal];
        _btnDelete.frame = CGRectMake(kDeviceWidth-50, kDeviceHeight-50, 23, 30);
        [_btnDelete addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    
    self.portraitImageView = portraitImageView;
    
    _scaleView.image = portraitImageView.image;
    _scaleView.frame = portraitImageView.frame;
    _scaleView.top = 160.0f;
    [UIView animateWithDuration:.3f animations:^{
        _scaleView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    } completion:^(BOOL finished) {
        
        [self.window addSubview:_scaleView];
        [self.window addSubview:_btnDelete];
        
    }];
}



@end
