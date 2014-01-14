//
//  AdviseScrollview.m
//  Amoy Baby Care
//
//  Created by user on 13-6-20.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import "AdviseScrollview.h"

@implementation AdviseScrollview
@synthesize myscroll,mypagecontrol;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (id)initWithArray:(NSArray*)array
{
    self=[self initWithFrame:CGRectMake(0, 0, 320, 190+G_YADDONVERSION)];
    self.myscroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 190+G_YADDONVERSION)];
    [self addSubview:myscroll];
    myscroll.delegate=self;
    myscroll.pagingEnabled=YES;
    myscroll.showsHorizontalScrollIndicator=NO;
    myscroll.contentSize=CGSizeMake(320*array.count, 190);
    for (int i=0; i<array.count; i++) {
        
        NSDictionary *dict=[array objectAtIndex:i];
        SuggestView *suggest=[[SuggestView alloc]initWithTitle:[dict objectForKey:@"title"] Suggestion:[dict objectForKey:@"content"] Center:CGPointMake(160+320*i, 100) ];
        [myscroll addSubview:suggest];
    }
    
    UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"indexInfo@2x.png"]];

    image.center=CGPointMake(160, 189+G_YADDONVERSION);
    image.bounds=CGRectMake(0, 0, 320, 10);
    self.mypagecontrol=[[UIPageControl alloc]init];
    mypagecontrol.center=CGPointMake(160, 5);
    mypagecontrol.bounds=CGRectMake(0, 0, 320, 10);
    [self addSubview:image];
    [image addSubview:mypagecontrol];
    mypagecontrol.numberOfPages=array.count;

    [mypagecontrol addTarget:self action:@selector(chagepage:) forControlEvents:UIControlEventValueChanged];

    return self;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = myscroll.contentOffset.x / 320;
    mypagecontrol.currentPage = page;
}
-(void)chagepage:(UIPageControl*)sender
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [myscroll  setContentOffset:CGPointMake(320*sender.currentPage, 0)];
    [UIView commitAnimations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
