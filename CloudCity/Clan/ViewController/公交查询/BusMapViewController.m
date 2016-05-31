//
//  BusMapViewController.m
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 29/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import "BusMapViewController.h"
#import "BusStopAnnotation.h"
#import "CommonUtility.h"
#import "CustomBusMode.h"
#import "MANaviRoute.h"

const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
const NSInteger RoutePlanningPaddingEdge                    = 20;
#define BusLinePaddingEdge 20

@interface BusMapViewController ()

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@end

@implementation BusMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
    [self initMapAssistFunction];
    [self performSelector:@selector(presentMapView) withObject:nil afterDelay:1.0];

    // Do any additional setup after loading the view.
}

- (void)initMapView
{    
    [MAMapServices sharedServices].apiKey = [NSString returnStringWithPlist:MAPKEY];
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.visibleMapRect = MAMapRectMake(LUOHE_MAP_RECT_MAKE_X,LUOHE_MAP_RECT_MAKE_Y,LUOHE_MAP_RECT_MAKE_WIDTH,LUOHE_MAP_RECT_MAKE_HEIGHT);
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initMapAssistFunction
{
    [self addUserGPS];
    [self addTraffic];
    
}

- (void)addUserGPS
{
    self.gpsBtn = [CustomBusMode setGPSButtonWithTitle:@"" imageName:@"write_upload_del" CGRect:CGRectMake(10, self.mapView.bottom - 100, 30, 30) target:self action:@selector(findUserLocation)];
    [self.mapView addSubview:self.gpsBtn];
}

- (void)addTraffic
{
    self.trafficBtn = [CustomBusMode setGPSButtonWithTitle:@"" imageName:@"write_upload_del" CGRect:CGRectMake(self.mapView.right - 100, 100, 30, 30) target:self action:@selector(showTrafficLine)];
    [self.mapView addSubview:self.trafficBtn];
}

#pragma mark - GPS

- (void)findUserLocation
{
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
}

#pragma mark - GPS

- (void)showTrafficLine
{
    self.trafficBtn.selected = !self.trafficBtn.selected;
    if (self.trafficBtn.selected) {
        self.mapView.showTraffic = YES;
    }else{
        self.mapView.showTraffic = NO;
    }
}

#pragma mark - BUS

/* 清除annotations & overlays */
- (void)clear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.naviRoute removeFromMapView];
}


/* 展示公交线路 */

- (void)presentMapView
{
    if (self.busLine != nil) {
        [self presentCurrentBusLine];
    }else if (self.busStop != nil) {
        [self presentCurrentBusStop];
    }else if (self.busRoute != nil) {
        [self presentCurrentBusRoute];
    }
}
- (void)presentCurrentBusStop
{
    NSMutableArray *busStopAnnotations = [NSMutableArray array];
    
    BusStopAnnotation *annotation = [[BusStopAnnotation alloc] initWithBusStop:self.busStop];
    
    [busStopAnnotations addObject:annotation];
    [busStopAnnotations addObject:self.mapView.userLocation];
    [self.mapView addAnnotations:busStopAnnotations];
    [self.mapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:busStopAnnotations] edgePadding:UIEdgeInsetsMake(BusLinePaddingEdge, BusLinePaddingEdge, BusLinePaddingEdge, BusLinePaddingEdge) animated:YES];

}


- (void)presentCurrentBusLine
{    
    NSMutableArray *busStopAnnotations = [NSMutableArray array];
    
    [self.busLine.busStops enumerateObjectsUsingBlock:^(AMapBusStop *busStop, NSUInteger idx, BOOL *stop) {

        BusStopAnnotation *annotation = [[BusStopAnnotation alloc] initWithBusStop:busStop];
        [busStopAnnotations addObject:annotation];

    }];
    
    [self.mapView addAnnotations:busStopAnnotations];
    
    MAPolyline *polyline = [CommonUtility polylineForBusLine:self.busLine];
    
    [self.mapView addOverlay:polyline];
    [self.mapView setVisibleMapRect:polyline.boundingMapRect edgePadding:UIEdgeInsetsMake(BusLinePaddingEdge, BusLinePaddingEdge, BusLinePaddingEdge, BusLinePaddingEdge) animated:YES];
}

- (void)presentCurrentBusRoute
{
    [self addDefaultAnnotations];
    
    self.naviRoute = [MANaviRoute naviRouteForTransit:self.busRoute.transits[self.currentCourse]];
    
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
                           animated:YES];
}

- (void)addDefaultAnnotations
{
    self.startCoordinate        = CLLocationCoordinate2DMake(self.busRoute.origin.latitude, self.busRoute.origin.longitude);
    self.destinationCoordinate  = CLLocationCoordinate2DMake(self.busRoute.destination.latitude, self.busRoute.destination.longitude);
    
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

#pragma mark - MAMapViewDelegate


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BusStopAnnotation class]])
    {
        static NSString *busStopIdentifier = @"busStopIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:busStopIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:busStopIdentifier];
            
        }else {
            while ([poiAnnotationView.subviews lastObject] != nil)
            {
                [(MAPinAnnotationView*)[poiAnnotationView.subviews lastObject] removeFromSuperview];
            }
        }
        
        poiAnnotationView.canShowCallout = YES;
        /* 起点. */
        if ([[annotation title] isEqualToString:self.busLine.startStop])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
        }
        /* 终点. */
        else if([[annotation title] isEqualToString:self.busLine.endStop])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
        }
        else {
            poiAnnotationView.image = [UIImage imageNamed:@"bus"];
        }
        return poiAnnotationView;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
            
        }
        
        return poiAnnotationView;
    }

    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if (self.busLine || self.busStop) {
        if ([overlay isKindOfClass:[MAPolyline class]])
        {
            MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
            
            polylineRenderer.lineWidth   = 8.f;
            [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]];
            
            return polylineRenderer;
        }
        
    }else {
        if ([overlay isKindOfClass:[LineDashPolyline class]])
        {
            MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
            
            polylineRenderer.lineWidth   = 7;
            polylineRenderer.strokeColor = [UIColor blueColor];
            
            return polylineRenderer;
        }
        if ([overlay isKindOfClass:[MANaviPolyline class]])
        {
            MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
            MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
            
            polylineRenderer.lineWidth = 8;
            
            [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]];

            return polylineRenderer;
        }
    }

    return nil;
}

- (void)dealloc
{
    [self clear];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
