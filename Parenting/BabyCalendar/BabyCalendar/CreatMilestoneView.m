//
//  CreatMilestoneView.m
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "CreatMilestoneView.h"
#import "CreatMilestoneAddphotoView.h"
#import "MilestoneModel.h"
@implementation CreatMilestoneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews
{
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"CreatMilestoneHeaderView" owner:self options:nil] lastObject];
    _headerView.delegate = self;
    _contentView = [[[NSBundle mainBundle] loadNibNamed:@"CreatMilestoneContentView" owner:self options:nil] lastObject];
    _contentView.delegate = self;
    _addphotoView = [[[NSBundle mainBundle] loadNibNamed:@"CreatMilestoneAddphotoView" owner:self options:nil] lastObject];
    
    
    
}

- (void)setType:(creatMilestoneType)type
{
    _type = type;
    _headerView.type = _type;
}


- (void)setModel:(MilestoneModel *)model
{
    _model = model;
    
    _headerView.model = _model;
    _contentView.model = _model;
    _addphotoView.model = _model;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:_headerView];
    
    _contentView.top = _headerView.bottom;
    _contentView.height = kDeviceHeight-64-_headerView.height-_addphotoView.height;
    [self addSubview:_contentView];
    
    _addphotoView.top = _contentView.bottom+10;
    [self addSubview:_addphotoView];
    
}
#pragma mark - CreatMilestoneHeaderViewDelegate

- (void)selectDate
{
    [_contentView.textView resignFirstResponder];
    [_headerView.textField resignFirstResponder];
}

#pragma mark - CreatMilestoneContentrViewDelegate
- (void)CreatMilestoneContentView_textViewDidBeginEditing:(CreatMilestoneContentView*)view
{
    [UIView animateWithDuration:.3f animations:^{

        self.top = - _headerView.height;
        
    }];
}

- (void)CreatMilestoneContentView_keyboardHided:(CreatMilestoneContentView*)view
{
    [UIView animateWithDuration:.3f animations:^{
        self.top = 0;
        [self setNeedsLayout];
    }];
}
@end
