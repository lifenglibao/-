//
//  Locator.m
//  AddView
//
//  Created by Kyo on 6/24/10.
//  Copyright 2010 ShowNearby Pte. Ltd.. All rights reserved.
//

#import "Locator.h"

@implementation Locator

@synthesize kerror, locationManager;

static Locator *myLocator = nil;

+ (id) sharedLocator{

	@synchronized(self) {
		if (myLocator == nil){
			[[self alloc] init];
		}
	}
	return myLocator;
}

+ (id) allocWithZone:(NSZone *)zone {

	@synchronized(self){
		if (myLocator == nil) {
			myLocator = [super allocWithZone:zone];
			return myLocator;
		}
	}
	return nil;
}

- (id) copyWithZone: (NSZone *)zone
{

	return self;
}

- (id) init 
{
    self = [super init];
	
	_location = nil;
	self = [super init];
	if (self) 
	{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
            [self.locationManager requestWhenInUseAuthorization];
        }
		[[self locationManager] startUpdatingLocation];
        [[self locationManager] startUpdatingHeading];
	}
	else
	{
		
	}
	return self;
}

#pragma mark -
#pragma mark Self Method

- (BOOL) IsLocationServiceEnabled{

	if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)])
	{
		if ([CLLocationManager locationServicesEnabled]) 
		{
			if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
			{
                return YES;
            }else{
                return NO;
            }
		}
		else 
		{
			return NO;
		}
	}else{
		if ([CLLocationManager locationServicesEnabled]) {
			return YES;
		}else {
			return NO;
		}
	}
}


- (void) refreshLocationManager 
{
    [[self locationManager] stopUpdatingLocation];
    [[self locationManager] startUpdatingLocation];
}


#pragma mark -
#pragma mark Location manager

 // -- ADDED HERE TO FOLLOW THE EXISTING ONE IN SPARKS LOCATOR RAJA
// myint aung added two public methods
- (CGFloat )getLatitude {
    if (_location) {
        return self.location.coordinate.latitude;
    }
    return 0;
}

- (CGFloat )getLongitude {
    if (_location) {
        return self.location.coordinate.longitude;
    }
    return 0;
}

- (CLLocationCoordinate2D )userLocation{
//    if (_location) {
//        return self.coordinate;
//    }
    return self.location.coordinate;
}
// -- ADDED HERE TO FOLLOW THE EXISTING ONE IN SPARKS LOCATOR RAJA

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager 
{

    if (locationManager != nil) 
	{
		return locationManager;
	}
	
	locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
	
	[locationManager setDelegate:self];
	return locationManager;
}


- (void) locationManager: (CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation 
{
    _location = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error 
{
    self.kerror = error;
    [Locator sharedLocator];
}

@end
