//
//  SummaryViewController.h
//  Parenting
//
//  Created by 家明 on 13-5-17.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuadCurveMenu.h"
#import "QuadCurveMenuItem.h"
#import "MyCorePlot.h"
#import "OpenFunction.h"
#import "save_diaperview.h"
#import "save_bathview.h"
#import "save_feedview.h"
#import "save_playview.h"
#import "save_sleepview.h"

@interface SummaryViewController : UIViewController<QuadCurveMenuDelegate, UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,save_diaperviewDelegate,save_sleepviewDelegate,save_playviewDelegate,save_bathviewDelegate,save_feedviewDelegate>{
    MyCorePlot *plot;
    UIButton *backbutton;
    int plotTag;
    BOOL isScroll;
    int selectIndex;
    UIImageView* Shareview;
    QuadCurveMenu *menu;
    UITextField *Sharetext;
    UITableView *List;
    UITableView *Advise;
    NSArray *ListArray;
    NSArray *AdviseArray;
    NSMutableArray *plotArray;
    UIButton *Histogram;
    UIButton *Plotting;
    
    int chooseAdvise;
    
    save_diaperview *diaper;
    save_sleepview  *sleep;
    save_feedview   *feed;
    save_playview   *play;
    save_bathview   *bath;
}



@property (retain, nonatomic)NSMutableArray *dataArray;
@property (retain, nonatomic)UIScrollView *plotScrollView;
@property (strong, nonatomic) IBOutlet UIView *ExplainView;
@property (strong, nonatomic) MyCorePlot *plot;
@property (weak, nonatomic) IBOutlet UIView *Mark;



-(void)MenuSelectIndex:(int)index;


@end
