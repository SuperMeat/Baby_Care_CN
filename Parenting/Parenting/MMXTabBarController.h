//
//  MMXTabBarController.h
//  NewMC
//
//  Created by apple  on 12-9-21.
//
//

#import <UIKit/UIKit.h>

@interface MMXTabBarController : UITabBarController<UITabBarControllerDelegate>{
    
    NSArray *btnImages;
    NSArray *btnHLightImages;
    NSArray *textLab;
    int currentSelectedIndex;

}

@property (nonatomic, assign) int currentSelectedIndex;
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) NSMutableArray *lable;
- (void)initCustomTabbar;

//- (void)setBtnImages:(NSArray*)theBtnImages;
//- (void)setBtnHLightImages:(NSArray*)theBtnHLightImages;
//- (void)showCustomerTabBar;
//- (void)hideCustomerTabBar;
//+ (void)hidden:(UITabBarController *)tabbarcontroller isHidden:(BOOL)hidden;

@end
