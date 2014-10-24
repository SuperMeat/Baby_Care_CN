//
//  HomeHeadView.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-9-29.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCBaby.h"

#define kBabyPhotoImageWS       100.0f
#define kHomeheadViewHeight     173.5f 

@protocol SelectBabyPhotoDelegate <NSObject>

-(void)willSelectBabyPhoto;

@end

@interface HomeHeadView : UIView


@property (nonatomic,assign) id<SelectBabyPhotoDelegate> delegate;

@property (nonatomic,strong) BCBaby *babyInfo;

//** UI  **
@property (nonatomic,strong) UILabel *babyNameLabel;
@property (nonatomic,strong) UILabel *birthOfDaysLabel;
@property (nonatomic,strong) UILabel *curryStateLabel;
@property (nonatomic,strong) UIImageView *babyPhotoImageView;
@property (nonatomic,strong) UIImageView *babyConditonBgImageView;
@property (nonatomic,strong) UIImageView *bgImageView;

-(id)initWithFrame:(CGRect)frame;
-(void)refreshWithBabyInfo:(BCBaby *)babyInfo;
-(void)refreshBabyPic;
-(void)resetBabyPhoto;

@end
