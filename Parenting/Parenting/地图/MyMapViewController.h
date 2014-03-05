//
//  MyMapViewController.h
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-4.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMapViewController : UIViewController<MAMapViewDelegate,AMapSearchDelegate>
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) CLLocation *mylocation;
- (void)returnAction;

@end
