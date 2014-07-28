//
//  MedicineViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-7-8.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "ACViewController.h"
#import "SummaryViewController.h"
@class save_medicineview;
@interface MedicineViewController : UIViewController<save_medicineviewDelegate>
{
    AdviseScrollview *ad;
    UIImageView *adviseImageView;
    save_medicineview *saveView;
}
@property (strong, nonatomic)SummaryViewController *summary;
@property (strong, nonatomic) IBOutlet UIButton *addRecordBtn;
@property (strong, nonatomic) IBOutlet UIView *norecordView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *norecordLabel;
+(id)shareViewController;
@end
