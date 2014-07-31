//
//  TipTableViewCell.m
//  MainViewController
//
//  Created by CHEN WEIBIN on 14-5-19.
//  Copyright (c) 2014年 CHEN WEIBIN. All rights reserved.
//

#import "TipTableViewCell.h"

@implementation TipTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    //加圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_view1.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _view1.bounds;
    maskLayer.path = maskPath.CGPath;
    _view1.layer.mask = maskLayer;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_view2.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _view2.bounds;
    maskLayer2.path = maskPath2.CGPath;
    _view2.layer.mask = maskLayer2;
}

-(void)setCellContent:(NSString*)date title:(NSString*)title summary:(NSString*)summary picUrl:(NSString*)picUrl{
    _labelDate.text = date;
    _labelSummary.text = summary;
    _labelTitle.text = title;
    _labelTitle.textColor = [ACFunction colorWithHexString:TEXTCOLOR];
    
//    picUrl = @"13996157820.jpg";
    picUrl = [NSString stringWithFormat:@"%@/%@",WEBPHOTO(@"Tip"),picUrl];
    UIASYImageView *imageView = [[UIASYImageView alloc] initWithFrame:_imagePic.frame];
    [imageView showImageWithUrl:picUrl];
    [_view1 addSubview:imageView];
    [_imagePic setHidden:YES];
//    _imagePic.image = imageView.image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
