//
//  UIASYImageView.h
//
//  Created by carbon on 11-6-24.
//  Copyright (c) 2013年 Carbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface UIASYImageView : UIImageView
{

}

@property (nonatomic,assign) BOOL asyFlag;

@property (nonatomic,assign) BOOL needCut;

@property (nonatomic,assign) BOOL needShowsAnimations;

- (id)initWithFrame:(CGRect)frame;

//加载网络图片，如果图片已经存在于本地，则直接显示
- (void)showImageWithUrl:(NSString*)url;
@end
