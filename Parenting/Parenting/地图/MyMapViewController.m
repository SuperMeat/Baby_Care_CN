//
//  MyMapViewController.m
//  Amoy Baby Care
//
//  Created by @Arvi@ on 14-3-4.
//  Copyright (c) 2014年 爱摩科技有限公司. All rights reserved.
//

#import "MyMapViewController.h"
#import "POIAnnotation.h"
#import "CommonUtility.h"
@interface MyMapViewController ()

@end

@implementation MyMapViewController

-(id)init
{
    self=[super init];
    if (self){
        // Custom initialization
        [self.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, 100, 20)];
        titleView.backgroundColor=[UIColor clearColor];
        UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        titleText.backgroundColor = [UIColor clearColor];
        [titleText setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        titleText.textColor = [UIColor whiteColor];
        [titleText setTextAlignment:NSTextAlignmentCenter];
        [titleText setText:NSLocalizedString(@"附近", nil)];
        [titleView addSubview:titleText];
        
        self.navigationItem.titleView = titleView;
        //self.title = NSLocalizedString(@"Copyright",nil);
        self.hidesBottomBarWhenPushed=YES;
        //self.automaticallyAdjustsScrollViewInsets = NO;
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        if ( IOS7_OR_LATER )
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)modeAction
{
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];  //设置为地图跟着位置移动}
}

-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if (userLocation.location != _mylocation) {
        self.mylocation = userLocation.location;
        [self searchPlaceByAround:userLocation andPlace:@"母婴"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    self.mapView.frame = self.view.bounds;
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    self.mapView.showsCompass  = NO;          //关闭指南针
    self.mapView.showsScale    = NO;         //关闭比例尺
    self.mapView.scaleOrigin   = CGPointMake(220, 420);    //设置比例尺位置
    [self.view addSubview:self.mapView];
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:AMAP_KEY  Delegate:self];

    self.mapView.rotateEnabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self modeAction];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility

- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}

- (void)clearSearch
{
    self.search.delegate = nil;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id<MAAnnotation> annotation = view.annotation;
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
      //  POIAnnotation *poiAnnotation = (POIAnnotation*)annotation;
        
//        PoiDetailViewController *detail = [[PoiDetailViewController alloc] init];
//        detail.poi = poiAnnotation.poi;
//        
//        /* 进入POI详情页面. */
//        [self.navigationController pushViewController:detail animated:YES];
    }

}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
            
            poiAnnotationView.canShowCallout = YES;
            
            poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

- (void)search:(id)searchRequest error:(NSString *)errInfo
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [searchRequest class], errInfo);
}

- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self clearMapView];
    
    [self clearSearch];
}

- (void)searchPlaceByAround:(MAUserLocation*)userLocation andPlace:(NSString*)place
{
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceAround;
    poiRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    poiRequest.keywords = place;
    poiRequest.radius= 1000;
    [self.search AMapPlaceSearch: poiRequest];
}

- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)respons
{
    if (respons.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:respons.pois.count];
    
    [respons.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        POIAnnotation *poi= poiAnnotations[0];
        self.mapView.centerCoordinate = [poi coordinate];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:YES];
    }
}

@end
