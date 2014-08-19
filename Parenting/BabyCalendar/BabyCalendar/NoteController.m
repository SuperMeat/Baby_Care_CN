//
//  NoteController.m
//  BabyCalendar
//
//  Created by will on 14-5-26.
//  Copyright (c) 2014年 will. All rights reserved.
//

#import "NoteController.h"
#import "NoteView.h"
#import "FootView.h"
#import "NoteModel.h"
#import "ShareInfoView.h"
@interface NoteController ()<NoteViewDelegate,FootViewDelegate>
{
    float startContentOffsetX;
    float willEndContentOffsetX;
    float endContentOffsetX;
}
@end

@implementation NoteController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)ShareBtnByImage
{
    UIImage *detailImage = [ACFunction cutView:self.view andWidth:kShareImageWidth_Note andHeight:kShareImageHeight_Note];
    ShareInfoView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"ShareInfoView" owner:self options:nil] lastObject];
    [shareView.shareInfoImageView setFrame:CGRectMake((320-193)/2.0, shareView.shareInfoImageView.origin.y, 217, 342)];
    [shareView.shareInfoImageView setImage:detailImage];
    shareView.titleDetail.text = [NSString stringWithFormat:kShareNoteTitle,[BabyinfoViewController getbabyname],[BabyinfoViewController getbabyage]];
    UIImage *shareimage = [ACFunction cutView:shareView andWidth:shareView.width andHeight:shareView.height];
    [ACShare shareImage:self andshareTitle:@"" andshareImage:shareimage anddelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem customForTarget:self image:@"item_share" title:nil action:@selector(ShareBtnByImage)];
    
    self.title = @"宝宝日记";
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64-50)];
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView setPagingEnabled:YES];
    [self.view addSubview:_scrollView];
    
    FootView* footView = [[[NSBundle mainBundle] loadNibNamed:@"FootView" owner:self options:nil] lastObject];
    footView.delegate = self;
    footView.top = kDeviceHeight-64-50;
    [self.view insertSubview:footView aboveSubview:_scrollView];
    
    [self _initDatas];
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self refreshCalendarView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self saveDatas];
    

}

- (void)refreshCalendarView
{
    // 刷新日历列表
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_SQLDatas object:nil];
    
    // 刷新日历
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifi_reload_calendarView object:nil];
}

- (void)saveDatas
{
    [BaseSQL delete_noteTable];
    
    for (int index = 0;index < self.datas.count;index++) {
        NoteView* noteView = (NoteView*)[self.view viewWithTag:100+index];
        
        NSString* content = [noteView.contentView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        BOOL bphoto = NO;
        if (noteView.picView.picView1.image != nil || noteView.picView.picView2.image != nil || noteView.picView.picView3.image != nil) {
            bphoto = YES;
        }
        
        if (content.length == 0 && noteView.headerView.index == 0 && !bphoto) {
            continue;
        }
        
        NoteModel* model = [[NoteModel alloc] init];
        model.id = [NSNumber numberWithInt:index];
        model.date = noteView.headerView.labDate.text;
        model.content = content;
        model.mood = [NSNumber numberWithInteger:noteView.headerView.index];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* timeStr = [formatter stringFromDate:[NSDate date]];
        
        // 保存图片到本地和数据库
        NSString* photoPath = @"";
        if (noteView.picView.picView1.image != nil) {
            
            NSString* name = [NSString stringWithFormat:@"%@%@_%d.jpg",timeStr,model.id,1];
            photoPath = [photoPath stringByAppendingString:name];
            
            // 保存到本地
            NSData* topImageData = UIImageJPEGRepresentation(noteView.picView.picView1.image, 0.5);
            NSString *photo_path=[BaseMethod dataFilePath:name];
            [topImageData writeToFile:photo_path atomically:YES];
        }
        if (noteView.picView.picView2.image != nil) {
            NSString* name = [NSString stringWithFormat:@"%@%@_%d.jpg",timeStr,model.id,2];
            NSString* name2 = [@"@" stringByAppendingString:name];
            photoPath = [photoPath stringByAppendingString:name2];
            
            // 保存到本地
            NSData* topImageData = UIImageJPEGRepresentation(noteView.picView.picView2.image, 0.5);
            NSString *photo_path=[BaseMethod dataFilePath:name];
            BOOL sucees = [topImageData writeToFile:photo_path atomically:YES];
            if (sucees) {
                
            }
            
        }
        if (noteView.picView.picView3.image != nil) {
            NSString* name = [NSString stringWithFormat:@"%@%@_%d.jpg",timeStr,model.id,3];
            NSString* name3 = [@"@" stringByAppendingString:name];
            photoPath = [photoPath stringByAppendingString:name3];
            
            // 保存到本地
            NSData* topImageData = UIImageJPEGRepresentation(noteView.picView.picView3.image, 0.5);
            NSString *photo_path=[BaseMethod dataFilePath:name];
            [topImageData writeToFile:photo_path atomically:YES];
        }
        
        model.photo = photoPath;
        NSLog(@"photoPath:%@",photoPath);
        BOOL success = [BaseSQL insertData_note:model];
        if (success) {
            NSLog(@"=========保存成功");
        }
        
    }
}


- (void)_initDatas
{
    [BaseSQL createTable_note];
    
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSString* selectedDateStr = [userDef objectForKey:kSelectedDate];
    NSMutableArray* data = [BaseSQL queryData_note_withDate:selectedDateStr];
    if (data.count > 0) {
        NSLog(@"存在日记");
        NSMutableArray* arr = [BaseSQL queryData_note];
        for (NoteModel* model in arr) {
            if ([model.date isEqualToString:selectedDateStr]) {
                break;
            }
            _index++;
        }
        
        self.datas = [BaseSQL queryData_note];
        
        [_scrollView setContentSize:CGSizeMake(kDeviceWidth*self.datas.count, 0)];
        int i = 0;
        for (NoteModel* model in self.datas) {
            NoteView* noteView = [[NoteView alloc] initWithFrame:CGRectMake(i*kDeviceWidth, 0, _scrollView.width, _scrollView.height)];
            noteView.tag = 100+i;
            noteView.delegate = self;
            noteView.model = model;
            [_scrollView addSubview:noteView];
            i++;
        }
        
        [_scrollView setContentOffset:CGPointMake( _index*kDeviceWidth,0)];

        
    }else
    {
        NSLog(@"不存在日记");
        [self addCurDateNote];
        [self _initDatas];
    }
}

- (void)addCurDateNote
{
    NoteModel* model = [[NoteModel alloc] init];
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSString* selectedDateStr = [userDef objectForKey:kSelectedDate];
    model.date = selectedDateStr;
    model.content = @"";
    [BaseSQL insertData_note:model];
}


#pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{    //拖动前的起始坐标
    
    startContentOffsetX = scrollView.contentOffset.x;
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{    //将要停止前的坐标
    
    willEndContentOffsetX = scrollView.contentOffset.x;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    endContentOffsetX = scrollView.contentOffset.x;
    
    if (endContentOffsetX < willEndContentOffsetX && willEndContentOffsetX < startContentOffsetX) { //画面从右往左移动，前一页
        _index--;
        
    } else if (endContentOffsetX > willEndContentOffsetX && willEndContentOffsetX > startContentOffsetX) {//画面从左往右移动，后一页
        _index++;
    }
    
}
#pragma mark - NoteView delegate

- (void)noteView_textViewDidBeginEditing
{
    [_scrollView setScrollEnabled:NO];
}
- (void)noteView_textViewDidEndEditing
{
    [_scrollView setScrollEnabled:YES];
}
#pragma mark - footView delegate
- (void)footView_left
{
    _index--;
    if (_index < 0) {
        _index = 0;
        return;
    }
    [_scrollView setContentOffset:CGPointMake(_index*kDeviceWidth, 0) animated:YES];
}
- (void)footView_right
{
    _index++;
    if (_index > self.datas.count -1) {
        _index--;
        return;
    }
    [_scrollView setContentOffset:CGPointMake(_index*kDeviceWidth, 0) animated:YES];
}

- (void)footView_delete
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除该日记？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}
#pragma mark - UIAlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NoteModel* model = self.datas[_index];
        model.content = @"";
        model.photo = @"";
        model.mood = [NSNumber numberWithInt:0];
        [self.datas replaceObjectAtIndex:_index withObject:model];
        
        NoteView* noteView = (NoteView*)[self.view viewWithTag:100+_index];
        noteView.model = model;
    }
}
@end
