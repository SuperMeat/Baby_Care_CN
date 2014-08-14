//
//  NoteInfoView.h
//  BabyCalendar
//
//  Created by will on 14-7-3.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteModel;
@interface NoteInfoView : UIView
{
    __weak IBOutlet UIImageView *_moodView;
    __weak IBOutlet UIImageView *_photoView;
    __weak IBOutlet UIImageView *_contentView;
    
}
@property(nonatomic,retain)NoteModel* model;
@end
