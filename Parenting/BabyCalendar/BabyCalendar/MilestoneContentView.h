//
//  MilestoneContentView.h
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MilestoneContentViewDelegate <NSObject>

- (void)milestone_delete;

@end

@interface MilestoneContentView : UIView<UITextViewDelegate>
{

    float _disMoveH;
}

@property(nonatomic,assign)id<MilestoneContentViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet MyNoteView *textView;

@property (strong, nonatomic) IBOutlet UIImageView *notetipsView;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
- (IBAction)delelte_milestone:(id)sender;

@end
