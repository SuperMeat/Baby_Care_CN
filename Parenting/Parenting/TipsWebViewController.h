//
//  TipsWebViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-11-6.
//  Copyright (c) 2013年 爱摩信息科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialShakeService.h"

@interface TipsWebViewController : ACViewController<UIWebViewDelegate,UMSocialUIDelegate,UMSocialDataDelegate,UMSocialShakeDelegate>
{
    NSString* _url;
    NSString* _contenttitle;
    NSString* _showimage;
    int _flag;
    int count;
}
@property (strong, nonatomic)  UIWebView *webView;
-(void) setTipsUrl:(NSString*)requestUrl;
-(void) setTipsTitle:(NSString*)title;
-(void) setShowImage:(NSString*)imagePath;
-(void) setFlag:(int)flag;
@end
