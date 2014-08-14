//
//  CreatMilestoneContentView.h
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreatMilestoneContentView;
@class MilestoneModel;
@protocol CreatMilestoneContentViewDelegate <NSObject>

- (void)CreatMilestoneContentView_textViewDidBeginEditing:(CreatMilestoneContentView*)view;
- (void)CreatMilestoneContentView_keyboardHided:(CreatMilestoneContentView*)view;
@end

@interface CreatMilestoneContentView : UIView<UITextViewDelegate>
{
    
}
@property(nonatomic,retain)MilestoneModel* model;
@property (weak, nonatomic) IBOutlet MyNoteView *textView;
@property (nonatomic,assign)float disMoveH;
@property (nonatomic,assign)id<CreatMilestoneContentViewDelegate> delegate;


@end
