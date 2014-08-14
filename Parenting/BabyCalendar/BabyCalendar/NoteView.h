//
//  NoteView.h
//  BabyCalendar
//
//  Created by will on 14-5-26.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"
#import "HeaderView.h"
#import "MoodView.h"
#import "PicView.h"
#import "ContentView.h"


@protocol NoteViewDelegate <NSObject>

- (void)noteView_textViewDidBeginEditing;
- (void)noteView_textViewDidEndEditing;

@end

@class NoteModel;
@interface NoteView : BaseView<HeaderViewDelegate,ContentViewDelegate,MoodViewDelegate,PicViewDelegate>
{
    
}
@property(nonatomic,retain)NoteModel* model;
@property(nonatomic,assign)id<NoteViewDelegate> delegate;
@property(nonatomic,retain)HeaderView* headerView;
@property(nonatomic,retain)MoodView*   moodView;
@property(nonatomic,retain)PicView* picView;
@property(nonatomic,retain)ContentView* contentView;
@end
