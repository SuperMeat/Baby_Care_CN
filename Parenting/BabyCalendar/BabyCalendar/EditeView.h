//
//  EditeView.h
//  BabyCalendar
//
//  Created by will on 14-6-26.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditeViewDelegate <NSObject>

- (void)editeViewDidCancel;
- (void)editeViewDidDone;

@end

@interface EditeView : UIView

@property(nonatomic,assign)id<EditeViewDelegate> delegate;
- (IBAction)cancelAction:(id)sender;

- (IBAction)doneAction:(id)sender;

@end
