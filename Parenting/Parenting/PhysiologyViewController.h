//
//  PhysiologyViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-18.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhyDetailViewController.h"
@interface PhysiologyViewController : ACViewController
{
    UIView *contentView;
    UIDatePicker *datepicker;
    UISlider *slider;
    
    UIButton *buttonSave;
    UIButton *buttonCancel;
    
    PhyDetailViewController *phyDetailViewController;
}

@property (strong, nonatomic) UIImageView *physiologyImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollerView;

//HEIGHT
@property (weak, nonatomic) IBOutlet UIView *viewHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelHeightValue;
@property (weak, nonatomic) IBOutlet UILabel *labelHeightDate;
@property (weak, nonatomic) IBOutlet UIImageView *imageHeightPrompt;
@property (weak, nonatomic) IBOutlet UIButton *buttonHeightChart;

//WEIGHT
@property (weak, nonatomic) IBOutlet UIView *viewWeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageWeightPrompt;
@property (weak, nonatomic) IBOutlet UILabel *labelWeightValue;
@property (weak, nonatomic) IBOutlet UILabel *labelWeightDate;
@property (weak, nonatomic) IBOutlet UIButton *buttonWeightChart;


//BMI
@property (weak, nonatomic) IBOutlet UIView *viewBMI;
@property (weak, nonatomic) IBOutlet UIImageView *imageBMIPrompt;
@property (weak, nonatomic) IBOutlet UILabel *labelBMIValue;
@property (weak, nonatomic) IBOutlet UIButton *buttonBMIChart;
@property (weak, nonatomic) IBOutlet UILabel *labelBMIDate;

//CIR
@property (weak, nonatomic) IBOutlet UIView *viewCir;
@property (weak, nonatomic) IBOutlet UIImageView *imageCirPrompt;
@property (weak, nonatomic) IBOutlet UILabel *labelCirValue;
@property (weak, nonatomic) IBOutlet UIButton *buttonCirChart;
@property (weak, nonatomic) IBOutlet UILabel *labelCirDate;

//Temperature
@property (weak, nonatomic) IBOutlet UIView *viewTemperature;
@property (weak, nonatomic) IBOutlet UIImageView *imageTemperPrompt;
@property (weak, nonatomic) IBOutlet UILabel *labelTemperValue;
@property (weak, nonatomic) IBOutlet UIButton *buttonTemperChart;
@property (weak, nonatomic) IBOutlet UILabel *labelTemperDate;


@end
