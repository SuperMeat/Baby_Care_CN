//
//  BackTodayView.h
//  BabyCalendar
//
//  Created by will on 14-6-16.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackTodayViewDelegate <NSObject>

- (void)backTodayViewDidBackToday;

@end

@interface BackTodayView : UIView

@property(nonatomic,assign)id<BackTodayViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;

- (IBAction)backToday:(id)sender;


@end
