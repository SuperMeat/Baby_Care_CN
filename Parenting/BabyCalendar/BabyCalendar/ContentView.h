//
//  ContentView.h
//  BabyCalendar
//
//  Created by will on 14-5-27.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentViewDelegate <NSObject>

- (void)contentView_textViewDidBeginEditing;
- (void)contentView_textViewDidEndEditing;

@end

@class NoteModel;
@interface ContentView : UIView<UITextViewDelegate>
{
    float _disMoveH;

}
@property(nonatomic,retain)NoteModel* model;
@property (weak, nonatomic) IBOutlet MyNoteView *textView;
@property(nonatomic,assign)id<ContentViewDelegate> delegate;

@end
