//
//  ItemView.h
//  WXMovie
//
//  Created by 周泉 on 13-5-22.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G开发培训中心. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemView;
@protocol ItemViewDelegate <NSObject>

@optional
- (void)didItemView:(ItemView *)itemView atIndex:(NSInteger)index;

@end


@interface ItemView : UIView
{
@private
    UIImageView *_item;
    UILabel     *_title;
    id <ItemViewDelegate> _delegate;
}

@property (nonatomic, readonly) UIImageView *item;
@property (nonatomic, readonly) UILabel     *title;
@property (nonatomic, assign) id <ItemViewDelegate> delegate;


@end
