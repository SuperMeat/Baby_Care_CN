//
//  MilestoneView.m
//  BabyCalendar
//
//  Created by will on 14-5-30.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "MilestoneView.h"
#import "MilestoneModel.h"
#import "MilestoneContentView.h"
#import "AddMilestoneController.h"
@implementation MilestoneView

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
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"MilestoneHeaderView" owner:self options:nil] lastObject];
    _headerView.delegate = self;
    _contentView = [[[NSBundle mainBundle] loadNibNamed:@"MilestoneContentView" owner:self options:nil] lastObject];
}

- (void)setSQLDatas:(NSMutableArray *)SQLDatas
{
    _SQLDatas = SQLDatas;
    
    // 是否显示已完成的里程碑界面
    if (_SQLDatas.count > 0) {
        _index = [self currentIndex:_SQLDatas];
        [self showAtIndex:_index];
        _headerView.hidden = NO;
        _contentView.hidden = NO;
    }else
    {
        _headerView.hidden = YES;
        _contentView.hidden = YES;
        
        
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:_headerView];
    
    _contentView.top = _headerView.bottom;
    _contentView.height = kDeviceHeight-64-_headerView.bottom;
    [self addSubview:_contentView];
    
    [self insertSubview:_loadingView aboveSubview:_contentView];
    
    
    
}

- (NSInteger)currentIndex:(NSMutableArray*)datas
{
    NSInteger index = 0;
    NSString* selectedDateStr = [BaseMethod selectedDateFromSave];
    for (MilestoneModel* model in datas) {
        
        if ([model.date isEqualToString:selectedDateStr]) {
            
            return index;
        }
        index++;
    }
    
    return 0;
}

- (void)showAtIndex:(NSInteger)index
{
    MilestoneModel* model = self.SQLDatas[index];
    [_headerView.btnDate setTitle:model.date forState:UIControlStateNormal];
    _headerView.labWeekday.text = [BaseMethod weekdayFromDate:[BaseMethod dateFormString:model.date]];
    NSString* photoPath = [BaseMethod dataFilePath:model.photo_path];
    _headerView.photoView.image = [UIImage imageWithContentsOfFile:photoPath];
    _contentView.labTitle.text = model.title;
    _contentView.textView.text = model.content;
}
#pragma mark -  MilestoneHeaderViewDelegate

- (void)MilestoneHeaderView_left
{
    _index--;
    if (_index < 0) {
      
        _index++;
        [self alertView:kPhoto_first];
        return;
    }
    [self showAtIndex:_index];
    
}
- (void)MilestoneHeaderView_right
{
    _index++;
    if (_index > self.SQLDatas.count-1) {
        [self alertView:kPhoto_last];
        _index--;
        return;
    }
    [self showAtIndex:_index];
    
}

- (void)PortraitImageView_changeImage:(MilestoneHeaderView*)headerView
{
//    // 删除旧照片
//    MilestoneModel* model = self.SQLDatas[_index];
//    [[NSFileManager defaultManager] removeItemAtPath:model.photo_path error:nil];
//    // 保存图片到本地和数据库
//    
//    NSData* topImageData = UIImageJPEGRepresentation(_headerView.photoView.image, 0.5);
//    [BaseSQL saveImage_local_SQL:topImageData withTitle:_contentView.labTitle.text];
    
    
}

- (void)ShareToFriendByImage
{
    [self.delegate ShareToFriend];
}

@end
