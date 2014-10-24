//
//  PortraitImageView.m
//  BabyCalendar
//
//  Created by will on 14-6-10.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "PortraitImageView.h"

@implementation PortraitImageView


#define ORIGINAL_MAX_WIDTH 1080.0f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGFloat w = 100.0f; CGFloat h = w;
//    CGFloat x = (self.view.frame.size.width - w) / 2;
//    CGFloat y = (self.view.frame.size.height - h) / 2;
//    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [self.layer setCornerRadius:self.height/2];
    [self.layer setMasksToBounds:YES];
    [self setContentMode:UIViewContentModeScaleAspectFill];
    [self setClipsToBounds:YES];
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(4, 4);
//    self.layer.shadowOpacity = 0.5;
//    self.layer.shadowRadius = 2.0;
    self.layer.borderColor = UIColorFromRGB(kColor_cal_today).CGColor;
    self.layer.borderWidth = 2.0f;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)setCanTap:(BOOL)canTap
{
    _canTap = canTap;
    
    if (_canTap) {
        if (_portraitTap == nil) {
            _portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        }
        [self addGestureRecognizer:_portraitTap];
    }else
    {
        [self removeGestureRecognizer:_portraitTap];
   
    }
}

//#pragma mark VPImageCropperDelegate
//- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
//    self.image = editedImage;
//    if ([self.delegate respondsToSelector:@selector(PortraitImageView_changeImage:)]) {
//        [self.delegate PortraitImageView_changeImage:self];
//    }
//    [cropperViewController dismissViewControllerAnimated:YES completion:^{
//        // TO DO
//    }];
//}
//
//- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
//    [cropperViewController dismissViewControllerAnimated:YES completion:^{
//    }];
//}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            UIViewController* vc = [BaseMethod baseViewController:self];
            [vc presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.allowsEditing = NO;
            controller.delegate = self;
            UIViewController* vc = [BaseMethod baseViewController:self];
            [vc presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissModalViewControllerAnimated:YES];
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if ([self.delegate respondsToSelector:@selector(PortraitImageView_changeImage:)]) {
        [self.delegate PortraitImageView_changeImage:self];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];

    
    
//    [picker dismissViewControllerAnimated:YES completion:^() {
//        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        portraitImg = [self imageByScalingToMaxSize:portraitImg];
//        // 裁剪
//        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) limitScaleRatio:3.0];
//        imgEditorVC.delegate = self;
//        UIViewController* vc = [BaseMethod baseViewController:self];
//        [vc presentViewController:imgEditorVC animated:YES completion:^{
//            // TO DO
//        }];
//    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

//#pragma mark image scale utility
//- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
//    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
//    CGFloat btWidth = 0.0f;
//    CGFloat btHeight = 0.0f;
//    if (sourceImage.size.width > sourceImage.size.height) {
//        btHeight = ORIGINAL_MAX_WIDTH;
//        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
//    } else {
//        btWidth = ORIGINAL_MAX_WIDTH;
//        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
//    }
//    CGSize targetSize = CGSizeMake(btWidth, btHeight);
//    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
//}
//
//- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
//    UIImage *newImage = nil;
//    CGSize imageSize = sourceImage.size;
//    CGFloat width = imageSize.width;
//    CGFloat height = imageSize.height;
//    CGFloat targetWidth = targetSize.width;
//    CGFloat targetHeight = targetSize.height;
//    CGFloat scaleFactor = 0.0;
//    CGFloat scaledWidth = targetWidth;
//    CGFloat scaledHeight = targetHeight;
//    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
//    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
//    {
//        CGFloat widthFactor = targetWidth / width;
//        CGFloat heightFactor = targetHeight / height;
//        
//        if (widthFactor > heightFactor)
//            scaleFactor = widthFactor; // scale to fit height
//        else
//            scaleFactor = heightFactor; // scale to fit width
//        scaledWidth  = width * scaleFactor;
//        scaledHeight = height * scaleFactor;
//        
//        // center the image
//        if (widthFactor > heightFactor)
//        {
//            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
//        }
//        else
//            if (widthFactor < heightFactor)
//            {
//                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
//            }
//    }
//    UIGraphicsBeginImageContext(targetSize); // this will crop
//    CGRect thumbnailRect = CGRectZero;
//    thumbnailRect.origin = thumbnailPoint;
//    thumbnailRect.size.width  = scaledWidth;
//    thumbnailRect.size.height = scaledHeight;
//    
//    [sourceImage drawInRect:thumbnailRect];
//    
//    newImage = UIGraphicsGetImageFromCurrentImageContext();
//    if(newImage == nil) NSLog(@"could not scale image");
//    
//    //pop the context to get back to the default
//    UIGraphicsEndImageContext();
//    return newImage;
//}
- (void)editPortrait {
    
    if (self.image == nil || _index == 1) {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self];
    }else
    {
        if ([self.delegate respondsToSelector:@selector(PortraitImageView_scaleImage:)]) {
            [self.delegate PortraitImageView_scaleImage:self];
        }
    }
    
}

-(void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    
}

-(void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    
}
@end
