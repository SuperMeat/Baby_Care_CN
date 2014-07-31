//
//  QuestionSurveyViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-7-29.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionSurveyViewController : ACViewController<UIWebViewDelegate>
{
    NSString* _url;
    NSString* _contenttitle;
    int count;
}
@property (strong, nonatomic)  UIWebView *webView;
-(void) setTipsUrl:(NSString*)requestUrl;
-(void) setTipsTitle:(NSString*)title;
@end
