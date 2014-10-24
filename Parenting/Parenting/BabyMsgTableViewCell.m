//
//  BabyMsgTableViewCell.m
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-10-9.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "BabyMsgTableViewCell.h"
#import "BCBabyMsg.h"

#define kBabyMsgTableViewCellTitleFontSize    14  //标题大小
#define kBabyMsgTableViewCellControlSpacing     10  //控件间距
#define kBabyMsgTableViewCellContentSpacing     5  //内容内控件间距

#define kBabyMsgTableViewCellIconWidth          30  //图标宽度
#define kBabyMsgTableViewCellIconHeight         kBabyMsgTableViewCellIconWidth
#define kBabyMsgTableViewCellContentBGWidth     246 //内容背景宽度
//#define kBabyMsgTableViewCellContentBGHeight    ? 浮动高度
#define kBabyMsgTableViewCellContentBGStretchableLCW    5  //stretchable left cap width
#define kBabyMsgTableViewCellContentBGStretchableTCH    30  //stretchable top cap height

#define kBabyMsgTableViewCellPicWidth           230 //图片宽度
#define kBabyMsgTableViewCellPicHeight          160 //图片宽度


@interface BabyMsgTableViewCell(){
    UIImageView     *_imageViewIcon;         //图标
    UIImageView     *_imageViewContentBG;    //内容背景
    UIASYImageView *_asyImageViewPic;       //缓存图片
    UILabel         *_labelTime;             //时间
    UILabel         *_labelMsgTitle;       //标题内容
    UILabel         *_labelState;            //状态
    
    UIImageView *_imageViewBG_Tint;     //遮盖图片
}
@end

@implementation BabyMsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    //**  cell背景色  **
    [self setBackgroundColor:UIColorFromRGB(kColor_baseView)];
    //**  头像控件  **
    _imageViewIcon = [[UIImageView alloc]init];
    [self addSubview:_imageViewIcon];
    //**  内容背景  **
    _imageViewContentBG = [[UIImageView alloc]init];
    [self addSubview:_imageViewContentBG];
    //**  图片  **
    _asyImageViewPic = [[UIASYImageView alloc]init];
    [self addSubview:_asyImageViewPic];
    //**  时间文本  **
    _labelTime = [[UILabel alloc]init];
    _labelTime.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    _labelTime.font = [UIFont systemFontOfSize:SMALLTEXT];
    [self addSubview:_labelTime];
    //**  标题  **
    _labelMsgTitle = [[UILabel alloc]init];
    _labelMsgTitle.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    _labelMsgTitle.font = [UIFont systemFontOfSize:kBabyMsgTableViewCellTitleFontSize];
    _labelMsgTitle.numberOfLines = 0;
    //_labelMsgTitle.lineBreakMode=NSLineBreakByWordWrapping;
    [self addSubview:_labelMsgTitle];
}

#pragma mark 设置消息
-(void)setBabyMsg:(BCBabyMsg*)babyMsg{
    //设置图标大小和位置
    CGFloat iconX=15,iconY=15;
    CGRect iconRect = CGRectMake(iconX, iconY, kBabyMsgTableViewCellIconWidth, kBabyMsgTableViewCellIconHeight);
    _imageViewIcon.image = [UIImage imageNamed:babyMsg.icon];
    _imageViewIcon.frame = iconRect;
    
    //设置文本大小和位置
    CGFloat titleX=CGRectGetMaxX(_imageViewIcon.frame) + kBabyMsgTableViewCellControlSpacing * 2;
    CGFloat titleY = kBabyMsgTableViewCellControlSpacing * 2;
    //多行文本需要用boundingRectWithSize来换算Size
    CGFloat titleWidth= kBabyMsgTableViewCellContentBGWidth -kBabyMsgTableViewCellControlSpacing*2;
    CGSize titleSize=[babyMsg.msgContent boundingRectWithSize:CGSizeMake(titleWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kBabyMsgTableViewCellTitleFontSize]} context:nil].size;
    CGRect titleRect=CGRectMake(titleX, titleY, titleSize.width, titleSize.height);
    _labelMsgTitle.text=babyMsg.msgContent;
    _labelMsgTitle.frame=titleRect;
    
    //设置图片
    if (![babyMsg.picUrl isEqualToString:@""]) {
        CGFloat picX = titleX;
        CGFloat picY = CGRectGetMaxY(_labelMsgTitle.frame) + kBabyMsgTableViewCellContentSpacing;
        CGRect picRect = CGRectMake(picX, picY, kBabyMsgTableViewCellPicWidth, kBabyMsgTableViewCellPicHeight);
        _asyImageViewPic.image = [UIImage imageNamed:@"tip_loading.png"];
        NSString *picUrl = [NSString stringWithFormat:@"%@/%@",WEBPHOTO(@"Tip"),babyMsg.picUrl];
        _asyImageViewPic.frame = picRect;
        [_asyImageViewPic showImageWithUrl:picUrl];
    }
    
    //设置时间
    CGSize timeSize=[babyMsg.time sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:SMALLTEXT]}];
    CGFloat timeX = CGRectGetMaxX(_imageViewIcon.frame) + kBabyMsgTableViewCellControlSpacing + kBabyMsgTableViewCellContentBGWidth - kBabyMsgTableViewCellControlSpacing - timeSize.width;
    CGFloat timeY = (CGRectGetMaxY(_asyImageViewPic.frame) > CGRectGetMaxY(_labelMsgTitle.frame) ? CGRectGetMaxY(_asyImageViewPic.frame) : CGRectGetMaxY(_labelMsgTitle.frame)) + kBabyMsgTableViewCellContentSpacing;
    CGRect timeRect=CGRectMake(timeX, timeY, timeSize.width,timeSize.height);
    _labelTime.frame = timeRect;
    _labelTime.text = babyMsg.time;
    
    //内容背景
    CGFloat contentBGX = CGRectGetMaxX(_imageViewIcon.frame) + kBabyMsgTableViewCellControlSpacing;
    CGFloat contentBGY = kBabyMsgTableViewCellControlSpacing;
    CGRect  contentBGRect = CGRectMake(contentBGX, contentBGY, kBabyMsgTableViewCellContentBGWidth, CGRectGetMaxY(_labelTime.frame) - 2);
    _imageViewContentBG.image = [[UIImage imageNamed:@"input_word.png"]stretchableImageWithLeftCapWidth:kBabyMsgTableViewCellContentBGStretchableLCW topCapHeight:kBabyMsgTableViewCellContentBGStretchableTCH];
    
    //设置高亮背景
    _imageViewContentBG.frame = contentBGRect;
    
    //cell高度
    _height = CGRectGetMaxY(_imageViewContentBG.frame) + kBabyMsgTableViewCellControlSpacing;
}


#pragma mark 重写选择事件，取消选中
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

#pragma mark 重写高亮事件，取消选中
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animate{
    if (highlighted)
    {
        UIImage *imageBG_Tint = [_imageViewContentBG.image imageWithTintColor:[UIColor lightGrayColor]];
        _imageViewBG_Tint = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _imageViewContentBG.width, _imageViewContentBG.height)];
        _imageViewBG_Tint.image = [imageBG_Tint stretchableImageWithLeftCapWidth:kBabyMsgTableViewCellContentBGStretchableLCW topCapHeight:kBabyMsgTableViewCellContentBGStretchableTCH];
        _imageViewBG_Tint.alpha = 0.25f;
        [_imageViewContentBG addSubview:_imageViewBG_Tint];
    }
    else{
        [_imageViewBG_Tint removeFromSuperview];
    }
}

@end
