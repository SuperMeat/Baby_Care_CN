//
//  EditPhyViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-5.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPhyViewController : UIViewController{
    UIDatePicker *datepicker;
    int itemType;
    long itemCreateTime;
    long itemMeasureTime;
}

@property (strong, nonatomic) UIImageView *phyDetailImageView;
@property (strong, nonatomic) UIButton *buttonBack;
@property (strong, nonatomic) UIButton *buttonSave;
@property (strong, nonatomic) UILabel *labelPickerDate;
@property (strong, nonatomic) UILabel *labelValue;
@property (strong, nonatomic) UILabel *labelUnit;
@property (strong, nonatomic) UILabel *titleText;
@property (strong,nonatomic) UISlider *slidlerValue;

@property (strong, nonatomic) UIView *view1;
@property (strong, nonatomic) UIView *view2;
@property (strong, nonatomic) UIView *view3;
@property (strong, nonatomic) UIView *view4;

-(void)setType:(int)Type;
-(void)setCreateTime:(long)createTime;
-(void)setMeasureTime:(long)measureTime;
@end
