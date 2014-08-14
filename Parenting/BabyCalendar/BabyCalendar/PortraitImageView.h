//
//  PortraitImageView.h
//  BabyCalendar
//
//  Created by will on 14-6-10.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>




@class PortraitImageView;
@protocol PortraitImageViewDelegate <NSObject>
@optional
- (void)PortraitImageView_changeImage:(PortraitImageView*)portraitImageView;
- (void)PortraitImageView_scaleImage:(PortraitImageView*)portraitImageView;
@end

@interface PortraitImageView : UIImageView<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
{
    UITapGestureRecognizer *_portraitTap;
}
@property(nonatomic,assign)id<PortraitImageViewDelegate> delegate;
@property(nonatomic,assign)int index;
@property(nonatomic,assign)BOOL canTap;
@end
