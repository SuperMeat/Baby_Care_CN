//
//  HomeHeadView.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-9-29.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "HomeHeadView.h"

//static const double kBGImageWidth = kDeviceWidth;
static const double kBGImageHeight = kHomeheadViewHeight;

static const double kBabyConditionBgImageX = 105.0f;
static const double kBabyConditionBgImageY = 45.0f;
static const double kBabyConditionBgImageWidth = 201.5;
static const double kBabyConditionBgImageHeight = 63.0f;

static const double kBirthOfDaysLabelX = kBabyConditionBgImageX + 137.0f;
static const double kBirthOfDaysLabelY = kBabyConditionBgImageY + 9.0f;
static const double kBirthOfDaysLabelWidth = 65.0f;
static const double kBirthOfDaysLabelHeight = 48.0f;

static const double kCurryStateLabelX = kBabyConditionBgImageX + 17.0f;
static const double kCurryStateLabelY = kBabyConditionBgImageY + 22.0f;
static const double kCurryStateLabelWidth = 160.0f;
static const double kCurryStateLabelHeight = 20.0f;

static const double kBabyNameLabelX = 130.0f;
static const double kBabyNameLabelY = 145.0f;
static const double kBabyNameLabelWidth = 160.0f;
static const double kBabyNameLabelHeight = 24.0f;

static const double kBabyPhotoImageX = 10.0f;
static const double kBabyPhotoImageY = kHomeheadViewHeight - kBabyPhotoImageWS / 2;
static const double kBabyPhotoImageWidth = kBabyPhotoImageWS;
static const double kBabyPhotoImageHeight = kBabyPhotoImageWS;


@implementation HomeHeadView
 

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:UIColorFromRGB(kColor_baseView)];
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    //**  背景  **
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, - kBGImageHeight, kDeviceWidth, kBGImageHeight * 2)];
    _bgImageView.image = [UIImage imageNamed:@"new_home_bg.png"];
    [self addSubview:_bgImageView];

    _babyConditonBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kBabyConditionBgImageX, kBabyConditionBgImageY, kBabyConditionBgImageWidth, kBabyConditionBgImageHeight)];
    _babyConditonBgImageView.image = [UIImage imageNamed:@"home_whatstate.png"];
    [self addSubview:_babyConditonBgImageView];
    
    //**  标签  **
    _birthOfDaysLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBirthOfDaysLabelX, kBirthOfDaysLabelY, kBirthOfDaysLabelWidth, kBirthOfDaysLabelHeight)];
    [_birthOfDaysLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:MIDTEXT]];
    [_birthOfDaysLabel setTextColor:[UIColor whiteColor]];
    [_birthOfDaysLabel setTextAlignment:NSTextAlignmentCenter];
    _birthOfDaysLabel.numberOfLines = 2;
    [self addSubview:_birthOfDaysLabel];
    
    _curryStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCurryStateLabelX, kCurryStateLabelY, kCurryStateLabelWidth, kCurryStateLabelHeight)];
    [_curryStateLabel setFont:[UIFont fontWithName:kShareImageFont size:MIDTEXT]];
    [_curryStateLabel setTextColor:[ACFunction colorWithHexString:@"#68bfcc"]];
    [_curryStateLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:_curryStateLabel];
    
    _babyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBabyNameLabelX, kBabyNameLabelY, kBabyNameLabelWidth, kBabyNameLabelHeight)];
    [_babyNameLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:MOREMIDTEXT]];
    [_babyNameLabel setTextColor:[UIColor whiteColor]];
    [_babyNameLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:_babyNameLabel];
    
    
    //**  头像  **
    _babyPhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kBabyPhotoImageX, kBabyPhotoImageY, kBabyPhotoImageWidth, kBabyPhotoImageHeight)];
    _babyPhotoImageView.image = [UIImage imageNamed:@"defaulthead.png"];
    _babyPhotoImageView.layer.masksToBounds = YES;
    _babyPhotoImageView.layer.cornerRadius = kBabyPhotoImageHeight / 2;
    _babyPhotoImageView.userInteractionEnabled=YES;
    _babyPhotoImageView.clipsToBounds=YES;
    [self addSubview:_babyPhotoImageView];
    //**  头像手势事件  **
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBabyPhoto)];
    [_babyPhotoImageView addGestureRecognizer:tapgesture];
}

-(void)initData{
    _babyNameLabel.text = _babyInfo.babyName;
    _birthOfDaysLabel.text = _babyInfo.birthOfDaysStr;
    _curryStateLabel.text = _babyInfo.growthStage;
    
    //**  加载照片  **
    [self refreshBabyPic];
}

#pragma mark 根据新的宝贝信息进行刷新
-(void)refreshWithBabyInfo:(BCBaby *)babyInfo{
    self.babyInfo = babyInfo;
    [self initData];
}

#pragma mark 刷新宝贝头像
-(void)refreshBabyPic{
    //**  加载照片  **
    NSFileManager *fileManage = [[NSFileManager alloc] init];
    if ([fileManage fileExistsAtPath:_babyInfo.babyPhotoPath]) {
        _babyPhotoImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:_babyInfo.babyPhotoPath]];
    }
}

#pragma mark 选择宝贝头像照片
-(void)selectBabyPhoto{ 
    [self.delegate willSelectBabyPhoto];
}

@end
