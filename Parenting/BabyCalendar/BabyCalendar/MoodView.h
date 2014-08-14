//
//  MoodView.h
//  BabyCalendar
//
//  Created by will on 14-5-26.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoodViewDelegate <NSObject>

- (void)moodViewDidselected:(NSInteger)index;

@end

@interface MoodView : UIView
{
    __weak IBOutlet UIButton *_btnHappy;
    __weak IBOutlet UIButton *_btnActive;
    __weak IBOutlet UIButton *_btnTiaopi;
    __weak IBOutlet UIButton *_btnQuite;
    __weak IBOutlet UIButton *_btnUnsafe;
    
    UIImageView* _markView;
    
}
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)id<MoodViewDelegate> delegate;
@end
