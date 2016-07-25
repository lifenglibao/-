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

@property (nonatomic        ) CGFloat                currentZoomLevel;
@property (nonatomic, strong) UIButton               *gpsBtn;
@property (nonatomic, strong) UIView                 *trafficView;
@property (nonatomic, strong) UIView                 *zoomView;

/* 起始点经纬度. */
@property (nonatomic        ) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic        ) CLLocationCoordinate2D destinationCoordinate;

/* 起始点名称. */
@property (nonatomic        ) NSString               *startLocationName;
/* 终点名称. */
@property (nonatomic        ) NSString               *destinationLocationName;

@property (nonatomic, strong) AMapBusLine            *busLine;
@property (nonatomic, strong) AMapBusStop            *busStop;
@property (nonatomic, strong) AMapRoute              *busRoute;
@property (nonatomic        ) NSInteger              currentCourse;

@property (nonatomic, strong) MAMapView              *mapView;
@property (nonatomic        ) BOOL                   needShowDetailView;
@property (nonatomic, strong) UIView                 *detailView;
@property (nonatomic        ) NSString               *titleName;
//@property (nonatomic, strong) MAAnnotationView       *userLocationAnnotationView;

@end
