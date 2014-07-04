//
//  TipTableViewCell.h
//  MainViewController
//
//  Created by CHEN WEIBIN on 14-5-19.
//  Copyright (c) 2014年 CHEN WEIBIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIASYImageView.h"
@interface TipTableViewCell : UITableViewCell{
    
    
}

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSummary;
@property (weak, nonatomic) IBOutlet UIImageView *imagePic;

-(void)setCellContent:(NSString*)date title:(NSString*)title summary:(NSString*)summary picUrl:(NSString*)picUrl;
@end
