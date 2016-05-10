//
//  ArrowImageView.h
//  ShowNearby
//
//  Created by Admin on 8/4/10.
//  Copyright 2010 ShowNearby Pte. Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ArrowImageView : UIImageView <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocationCoordinate2D target;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, readwrite) CLLocationCoordinate2D target;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) CLHeading *currentHeading;


- (BOOL) IsLocationServiceEnabled;
- (BOOL) IsHeadingAvailable;
@end