//
//  ACShare.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-7-30.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  在使用分享函数的时候对应的viewcontroller需要包含UMSocialUIDelegate,UMSocialDataDelegate进来
    并且实现这三个函数
 -(BOOL)isDirectShareInIconActionSheet
 {
 return NO; //返回NO，不直接分享
 }
 
 -(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
 {
 
 }
 -(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
 {
 //根据`responseCode`得到发送结果,如果分享成功
 if(response.responseCode == UMSResponseCodeSuccess)
 {
 //得到分享到的微博平台名
 NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
 }
 }

 */
@interface ACShare : NSObject
+(void)shareUrl:(UIViewController *)controller
   andshareText:(NSString *)shareText
  andshareImage:(id)shareImage
         andUrl:(NSString*)url
    anddelegate:(id <UMSocialUIDelegate>)ctrldelete;

+(void)shareImage:(UIViewController *)controller
    andshareTitle:(NSString *)title
    andshareImage:(id)shareImage
      anddelegate:(id <UMSocialUIDelegate>)ctrldelete;

+(void)cutView:(UIView *)view;

@end
