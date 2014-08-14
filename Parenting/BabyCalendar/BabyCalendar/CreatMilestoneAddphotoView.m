//
//  CreatMilestoneAddphotoView.m
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "CreatMilestoneAddphotoView.h"
#import "PortraitImageView.h"
#import "MilestoneModel.h"
@implementation CreatMilestoneAddphotoView

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
    
    _addPhotoView.index = 1;
    _addPhotoView.canTap = YES;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}
- (void)setModel:(MilestoneModel *)model
{
    _model = model;
    
    
    NSString *photo_path=[BaseMethod dataFilePath:_model.photo_path];
    UIImage* image = [UIImage imageWithContentsOfFile:photo_path];
    if (image == nil) {
        image = [UIImage imageNamed:@"bg_addphoto"];
    }
    
    _addPhotoView.image = image;
}

@end
