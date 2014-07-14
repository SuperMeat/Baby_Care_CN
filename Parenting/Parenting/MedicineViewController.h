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
@interface MedicineViewController : UIViewController<save_sleepviewDelegate>
{
    AdviseScrollview *ad;
    UIImageView *adviseImageView;
    save_medicineview *saveView;
}
@property (strong, nonatomic)SummaryViewController *summary;
@property (strong, nonatomic) IBOutlet UIButton *addRecordBtn;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UILabel *detailTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailTimeHour;
@property (strong, nonatomic) IBOutlet UILabel *detailTimeYear;
@property (strong, nonatomic) IBOutlet UILabel *detailTimeInternalLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailTimeInternal;
@property (strong, nonatomic) IBOutlet UILabel *detailMedicine;
@property (strong, nonatomic) IBOutlet UILabel *detailMedicineAmount;
@property (strong, nonatomic) IBOutlet UIView *norecordView;
@property (strong, nonatomic) IBOutlet UILabel *setTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *norecordLabel;
@property (strong, nonatomic) IBOutlet UIButton *setTimeBtn;
- (IBAction)SetNextTimeReminder:(UIButton *)sender;
+(id)shareViewController;
@property (strong, nonatomic) IBOutlet UILabel *detailMedicineLabel;
@end
