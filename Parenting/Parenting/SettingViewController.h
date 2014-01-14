//
//  SettingViewController.h
//  Parenting
//
//  Created by 家明 on 13-5-17.
//  Copyright (c) 2013年 家明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "UMFeedback.h"

typedef enum apiCall {
    kAPILogout,
    kAPIGraphUserPermissionsDelete,
    kDialogPermissionsExtended,
    kDialogRequestsSendToMany,
    kAPIGetAppUsersFriendsNotUsing,
    kAPIGetAppUsersFriendsUsing,
    kAPIFriendsForDialogRequests,
    kDialogRequestsSendToSelect,
    kAPIFriendsForTargetDialogRequests,
    kDialogRequestsSendToTarget,
    kDialogFeedUser,
    kAPIFriendsForDialogFeed,
    kDialogFeedFriend,
    kAPIGraphUserPermissions,
    kAPIGraphMe,
    kAPIGraphUserFriends,
    kDialogPermissionsCheckin,
    kDialogPermissionsCheckinForRecent,
    kDialogPermissionsCheckinForPlaces,
    kAPIGraphSearchPlace,
    kAPIGraphUserCheckins,
    kAPIGraphUserPhotosPost,
    kAPIGraphUserVideosPost,
} apiCall;
@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,UMFeedbackDataDelegate>
{
    UIView *segementForMetric;
    UIAlertView *clearalert;
    UIAlertView *logoutAlert;

    
    UIButton *buttonForFacebook;
    
    UIButton *loginBtn;
    NSArray *permissions;
    UILabel *loginSuccessLabel;
    UILabel *shareInfoLabel;
    UIButton *shareBtn;
    UILabel *messageLabel;
    UIView *messageView;
    UIButton *logoutBtn;
    int currentAPICall;
}

@property (strong,nonatomic)  UMFeedback *umFeedback;
@property (nonatomic, strong) NSArray *permissions;
@property (nonatomic, strong)  UILabel *loginSuccessLabel;
@property (nonatomic,strong) UILabel *shareInfoLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *messageView;


@end
