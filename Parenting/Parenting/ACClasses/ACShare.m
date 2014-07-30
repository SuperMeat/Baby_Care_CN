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

@end
