//
//  TestMiddleView.h
//  BabyCalendar
//
//  Created by Will on 14-5-31.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "BaseView.h"

@protocol TestMiddleViewDelegate <NSObject>

- (void)testMiddleView_back:(NSInteger)index;
- (void)testMiddleView_next:(NSInteger)index;

@end

@interface TestMiddleView : BaseView<UIAlertViewDelegate,UITextViewDelegate>
{
    __weak IBOutlet MyNoteView *_textView;
    __weak IBOutlet UIButton *_knowledgeView;
    __weak IBOutlet UIButton *_lanuageView;
    __weak IBOutlet UIButton *_moodView;
    __weak IBOutlet UIButton *_moveView;
    
    __weak IBOutlet UILabel *_labPage;
    
    
    
}
@property(nonatomic,retain)NSMutableArray* datas;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)id<TestMiddleViewDelegate> delegate;
- (IBAction)nextAction:(id)sender;
- (IBAction)backAction:(id)sender;



@end
