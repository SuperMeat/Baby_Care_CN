//
//  PhyDetailViewController.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-4-18.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhyCorePlot.h"
@interface PhyDetailViewController : UIViewController
{
    NSInteger itemIndex;
    NSString * itemName;
    UIButton * buttonBack;
    
    PhyCorePlot *plot;
    float yBaseValue;
    float ySizeInterval;
    UIImageView *adviseImageView;
}

@property (strong, nonatomic) UIImageView *phyDetailImageView;

-(void)setItemIndex:(NSInteger)index;


@end
