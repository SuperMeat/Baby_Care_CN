//
//  WeatherAdviseViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 13-11-28.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherAdviseViewController : UIViewController

@property (strong, nonatomic)  AdviseData  *ad;
@property (strong, nonatomic)  AdviseLevel *al;
@property (strong, nonatomic) UIButton *detailBtn;
@property (strong, nonatomic) UIButton *back;

@property (strong, nonatomic) IBOutlet UILabel *detail;
- (id)initWithAdviseData:(AdviseData*)adata andAdviseLevel:(AdviseLevel *)alevel;

@end
