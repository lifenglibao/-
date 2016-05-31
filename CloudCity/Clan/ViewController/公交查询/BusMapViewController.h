//
//  BusMapViewController.h
//  CloudCity
//
//  Created by iAPPS Pte Ltd on 29/04/16.
//  Copyright © 2016年 Youzu. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>

@interface BusMapViewController : BaseViewController<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) UIButton *gpsBtn;
@property (nonatomic, strong) UIButton *trafficBtn;
/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

@property (nonatomic, strong) AMapBusLine *busLine;
@property (nonatomic, strong) AMapBusStop *busStop;
@property (nonatomic, strong) AMapRoute *busRoute;
@property (nonatomic) NSInteger currentCourse;

@property (nonatomic, strong) MAMapView *mapView;

@end
