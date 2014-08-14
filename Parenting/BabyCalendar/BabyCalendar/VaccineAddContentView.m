//
//  VaccineAddContentView.m
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "VaccineAddContentView.h"
#import "VaccineDetailController.h"
#import "VaccineModel.h"
@implementation VaccineAddContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self _initBtnState];
    
    
    [_btnLiugan addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnFei addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnB addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnDog addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnJiagan addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLun addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnShuidou addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_initBtnState) name:kNotifi_reload_add_vaccine object:nil];
}

- (void)_initBtnState
{
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    
    for (int index = 0; index < 7; index++) {
        int tag = 100+index;
        NSString* key = [NSString stringWithFormat:@"%d",tag];
        NSString* string = [userDef objectForKey:key];
        if ([key isEqualToString:string]) {
            UIButton* btn = (UIButton*)[self viewWithTag:tag];
            btn.selected = YES;
            [btn setEnabled:NO];
        }
        
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _scrollView.height = self.height;
    _scrollView.contentSize = CGSizeMake(0, 333.0f);
}

- (void)btnAction:(UIButton*)btn
{
    VaccineModel* model = [[VaccineModel alloc] init];
    model.id = [NSNumber numberWithInteger:btn.tag];
    model.vaccine = btn.titleLabel.text;
    model.illness = @"";
    model.completedDate = [BaseMethod stringFromDate:[NSDate date]];
    model.times = @"第一次";
    model.inplan = [NSNumber numberWithBool:NO];
    model.completed = [NSNumber numberWithBool:NO];
    
    UIViewController* vc = [BaseMethod baseViewController:self];
    VaccineDetailController* detailVc = [[VaccineDetailController alloc] init];
    detailVc.model = model;
    [vc.navigationController pushViewController:detailVc animated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
