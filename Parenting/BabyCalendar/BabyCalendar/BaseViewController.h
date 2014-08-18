//
//  BaseViewController.h
//  MySafedog
//
//  Created by Will on 13-12-26.
//  Copyright (c) 2013年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
#import "LoadingView.h"
#import "UMSocialShakeService.h"
#import "UMSocial.h"
#import "UMSocialSnsData.h"
#import "UMSocialSnsService.h"

@interface BaseViewController : UIViewController<UMSocialUIDelegate,UMSocialDataDelegate,UMSocialShakeDelegate>
{
    LoadingView* _loadingView;
}

- (void)alertView:(NSString*)text;
@end
