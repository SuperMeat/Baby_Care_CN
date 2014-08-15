//
//  PhySaveView.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 14-8-14.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhySaveViewDelegate<NSObject>
@optional
-(void)sendPhyReloadData;
@end

@interface PhySaveView : UIView<UITextFieldDelegate,UIActionSheetDelegate>
{
    NSString *opType;
    int itemType;
    NSString * itemUnit;
    NSString * itemName;
    long createTime;
    NSDate* measureTime;
    
    UIImageView *imageview;
    UITextField *textRecordDate; 
    UITextField *textValue;
    UIButton *buttonSave;
    UIButton *buttonCancel;
    
    UIDatePicker *datepicker;
    UIActionSheet *action;
}

- (id)initWithFrame:(CGRect)frame Type:(int)type OpType:(NSString *)operateType CreateTime:(long)create_time;
@property (assign) id<PhySaveViewDelegate> PhySaveDelegate;
@end
