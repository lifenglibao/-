//
//  Locator.h
//  AddView
//
//  Created by Kyo on 6/24/10.
//  Copyright 2010 ShowNearby Pte. Ltd.. All rights reserved.
//
//  Singleton object

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Locator : NSObject <CLLocationManagerDelegate>
{

	CLLocationManager *locationManager; ///< The location Manager
	NSError *kerror;
}
@property (nonatomic, strong) NSError *kerror;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location; //NEW



+ (id) sharedLocator;
- (BOOL) IsLocationServiceEnabled;
- (CLLocationCoordinate2D )userLocation;
- (CGFloat )getLatitude; // myint aung added
- (CGFloat )getLongitude; // myint aung added
@end
