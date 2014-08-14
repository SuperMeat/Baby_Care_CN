//
//  MilestoneContentView.h
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MilestoneContentView : UIView<UITextViewDelegate>
{

    float _disMoveH;
}
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet MyNoteView *textView;


@end
