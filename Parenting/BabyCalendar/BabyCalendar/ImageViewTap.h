//
//  ImageViewTap.h
//  BabyCalendar
//
//  Created by will on 14-7-1.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageViewTap;
@protocol ImageViewTapDelegate <NSObject>

- (void)tapAction:(ImageViewTap*)imgView;

@end

@interface ImageViewTap : UIImageView
@property(nonatomic,assign)id<ImageViewTapDelegate> delegate;
@end
