//
//  PHYDetailViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-24.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhyCorePlot.h"
#import "AddPHYRecordViewController.h"

@interface PHYDetailViewController : UIViewController{
    NSArray *arrayCurrent;
    NSString *itemName;
    
    PhyCorePlot *plot;
    float yBaseValue;
    float ySizeInterval;
    UIImageView *adviseImageView;
    
    AddPHYRecordViewController *addRecordViewController;
}

@property (strong, nonatomic) UIImageView *phyDetailImageView;
@property (strong, nonatomic) UIButton *buttonBack;
@property (strong, nonatomic) UIButton *buttonAdd;
@property (strong, nonatomic) UIButton *buttonTip;

//顶部数值视图
@property (strong, nonatomic) UIView *viewTop1;
@property (strong, nonatomic) UILabel *labelLastValue;
@property (strong, nonatomic) UILabel *labelLastDate;
@property (strong, nonatomic) UILabel *labelCURValue;
@property (strong, nonatomic) UILabel *labelCURDate;
@property (strong, nonatomic) UILabel *labelChangeValue;

//详细数值视图
@property (strong, nonatomic) UIView *viewHistroy;


-(void)setVar:(NSArray*) array;

@end
