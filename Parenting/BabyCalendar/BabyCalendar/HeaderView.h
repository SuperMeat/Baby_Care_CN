//
//  HeaderView.h
//  BabyCalendar
//
//  Created by will on 14-5-26.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"
#import "PortraitImageView.h"
@protocol HeaderViewDelegate <NSObject>

- (void)moodClick;
- (void)addPhoto:(UIImage*)image;

@end

@class NoteModel;
@interface HeaderView : BaseView<PortraitImageViewDelegate>
{
    IBOutlet UIButton *_btnMood;

    
    
}
@property(nonatomic,assign)id<HeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *labWeek;
@property(nonatomic,retain)NoteModel* model;
@property(nonatomic,assign)NSInteger index;
@property (weak, nonatomic) IBOutlet PortraitImageView *addPhotoView;

- (IBAction)moodAction:(id)sender;




@end
