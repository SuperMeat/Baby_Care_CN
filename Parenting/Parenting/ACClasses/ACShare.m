//
//  ACShare.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-7-30.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "ACShare.h"
#import "UMSocial.h"
#import "UMSocialSnsData.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialSnsService.h"

@implementation ACShare
+(void)shareUrl:(UIViewController *)controller
   andshareText:(NSString *)shareText
  andshareImage:(id)shareImage
         andUrl:(NSString*)url
    anddelegate:(id <UMSocialUIDelegate>)ctrldelete
{
    [UMSocialWechatHandler setWXAppId:WXAPPID url:url];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareText;
    [UMSocialData defaultData].extConfig.qqData.url    = url;

    [UMSocialData defaultData].extConfig.qzoneData.url = url;

    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@\r\n%@",shareText ,url];
    [UMSocialData defaultData].extConfig.sinaData.shareImage = shareImage;
    
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:UMENGAPPKEY
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToSina,
                                                 UMShareToQQ,
                                                 UMShareToQzone,
                                                 nil]
                                       delegate:ctrldelete];
    
}

+(void)shareImage:(UIViewController *)controller
    andshareTitle:(NSString *)title
    andshareImage:(id)shareImage
      anddelegate:(id <UMSocialUIDelegate>)ctrldelete
{
  
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:UMENGAPPKEY
                                      shareText:title
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToSina,
                                                 UMShareToQQ,
                                                 UMShareToQzone,
                                                 nil]
                                       delegate:ctrldelete];
}

+ (void)cutView:(UIView*)view
{
    UIGraphicsBeginImageContext(CGSizeMake(kDeviceWidth, 500));
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *parentImage=UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef imageRef = parentImage.CGImage;
    CGRect windowframe = [[UIScreen mainScreen] bounds];
    CGRect contentframe = CGRectMake(windowframe.origin.x, windowframe.origin.y, windowframe.size.width, windowframe.size.height);
    CGRect myImageRect=contentframe;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size=CGSizeMake(contentframe.size.width,  contentframe.size.height);
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    } else
    {
        UIGraphicsBeginImageContext(size);
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* image = [UIImage imageWithCGImage:subImageRef];
    
    
    NSData *imagedata=UIImagePNGRepresentation(image);
    [imagedata writeToFile:SHAREPATH atomically:NO];
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    [UIView beginAnimations:@"ToggleViews" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView commitAnimations];
}
@end
