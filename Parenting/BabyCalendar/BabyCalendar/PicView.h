//
//  PicView.h
//  BabyCalendar
//
//  Created by will on 14-7-1.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewTap.h"
@class PicView;
@class NoteModel;
@protocol PicViewDelegate <NSObject>

- (void)picView_pics:(PicView*)picView;

@end

@interface PicView : UIView<ImageViewTapDelegate,UIAlertViewDelegate>
{
    
    // 放大图
    UIImageView* _scaleView;
    UIButton* _btnDelete;
    
    NSInteger _index;
}
@property(nonatomic,retain)NoteModel* model;
@property(nonatomic,assign)id<PicViewDelegate> delegate;
@property(nonatomic,retain)NSMutableArray* pics;
@property (weak, nonatomic) IBOutlet ImageViewTap *picView1;
@property (weak, nonatomic) IBOutlet ImageViewTap *picView2;
@property (weak, nonatomic) IBOutlet ImageViewTap *picView3;




@end
