//
//  AddIemView.h
//  BabyCalendar
//
//  Created by will on 14-6-26.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddIemViewDelegate <NSObject>

- (void)addIemViewDidEdite;
- (void)addIemViewDidAdd;

@end

@interface AddIemView : UIView

@property(nonatomic,assign)id<AddIemViewDelegate> delegate;
- (IBAction)editeAction:(id)sender;
- (IBAction)addAction:(id)sender;

@end
