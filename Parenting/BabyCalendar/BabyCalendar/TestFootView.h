//
//  TestFootView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestQuestionModel;
@protocol TestFootViewDelegate <NSObject>

- (void)testFootView_can:(NSInteger)index;
- (void)testFootView_cannot:(NSInteger)index;
- (void)testFootView_unclear:(NSInteger)index;

@end

@interface TestFootView : UIView
{
    __weak IBOutlet UIButton *_btnCan;
    __weak IBOutlet UIButton *_btnCannot;
    __weak IBOutlet UIButton *_btnUnclear;
    
}
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,retain)TestQuestionModel* model;
@property(nonatomic,assign)id<TestFootViewDelegate> delegate;
- (IBAction)canAction:(id)sender;
- (IBAction)cannotAction:(id)sender;
- (IBAction)unclearAction:(id)sender;


@end
