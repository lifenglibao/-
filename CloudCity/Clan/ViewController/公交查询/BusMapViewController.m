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

#define BusLinePaddingEdge 20

@interface BusMapViewController ()

@end

@implementation BusMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self initMapAssistFunction];
    [self performSelector:@selector(presentMapView) withObject:nil afterDelay:1.0];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initMapAssistFunction
{
    self.mapView.showsUserLocation = YES;
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
    [self.gpsBtn  removeFromSuperview];
}


/* 展示公交线路 */

- (void)presentMapView
{
    if (self.busLine != nil) {
        [self presentCurrentBusLine];
    }else if (self.busStop != nil) {
        [self presentCurrentBusStop];
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
    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 8.f;
        [polylineRenderer loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]];
        
        return polylineRenderer;
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
