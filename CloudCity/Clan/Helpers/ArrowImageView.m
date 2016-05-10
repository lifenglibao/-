//
//  ArrowImageView.m
//  ShowNearby
//
//  Created by Admin on 8/4/10.
//  Copyright 2010 ShowNearby Pte. Ltd.. All rights reserved.
//

#define degreesToRadians(x) (M_PI * x / 180.0)

#import "ArrowImageView.h"


@implementation ArrowImageView

@synthesize locationManager;
@synthesize target;
@synthesize currentHeading,currentLocation;


- (void)dealloc {
    NSLog(@"ArrowImageView dealloc --------------------------------------------------------");
	[locationManager stopUpdatingHeading];
	[locationManager stopUpdatingLocation];
	[locationManager release];
	locationManager = nil;
    
    if (currentLocation) {
        [currentLocation release];
    }
    
    if (currentHeading) {
        [currentHeading release];
    }
	
	[super dealloc];
}

#pragma mark -

- (float)bearingFromPoint:(CLLocationCoordinate2D)fromPoint toPoint:(CLLocationCoordinate2D)toPoint
{
	
	float deltaY = fromPoint.longitude - toPoint.longitude;
	
	float deltaX = fromPoint.latitude - toPoint.latitude;
	
	float radians = atan2(deltaY, deltaX);
	
	if (radians < M_PI) {
		radians += M_PI;
	}
	
	return radians;
	
}


#pragma mark -
- (id)initWithCoder:(NSCoder *)aDecoder {
	// NPLog(@"arrow image view awakeFromNib");
	if (self = [super initWithCoder:aDecoder]) {
		
		self.userInteractionEnabled = YES;
		
		self.hidden = YES;
		currentLocation = nil;
		currentHeading = nil;
		
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		
		if (![self IsHeadingAvailable]) {
			self.locationManager = nil;
			self.image = nil;
			
		} else {
			
			if([self IsLocationServiceEnabled]){
				locationManager.headingFilter = kCLHeadingFilterNone;
				
				locationManager.delegate = self;
				
				[locationManager startUpdatingLocation];
				[locationManager startUpdatingHeading];
                
			}else {
				self.locationManager = nil;
				self.image = nil;
			}
		}
        
	}
	
	return self;
}

- (id)initWithImage:(UIImage *)image {
    
	if (self = [super initWithImage:image]) {
        
		self.userInteractionEnabled = YES;
		
		self.hidden = YES;
		currentLocation = nil;
		currentHeading = nil;
		
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		//NPLog(@"Initiating");
		if (![self IsHeadingAvailable])
		{
			self.locationManager = nil;
			self.image = nil;
            //	NPLog(@"Heading Not Available");
		} else {
			
			if([self IsLocationServiceEnabled]){
				locationManager.headingFilter = kCLHeadingFilterNone;
				
				locationManager.delegate = self;
				
				[locationManager startUpdatingLocation];
				[locationManager startUpdatingHeading];
				//NPLog(@"Location Manager started to update heading");
			}else {
				self.locationManager = nil;
				self.image = nil;
				//NPLog(@"Location Service not enabled");
			}
		}
		
	}
	
	return self;
}

- (BOOL) IsLocationServiceEnabled{
	if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]){
		if ([CLLocationManager locationServicesEnabled]) {
			return YES;
		}else {
			return NO;
		}
	}else{
		if (locationManager.locationServicesEnabled) {
			return YES;
		}else {
			return NO;
		}
	}
}

- (BOOL) IsHeadingAvailable{
	if ([CLLocationManager respondsToSelector:@selector(headingAvailable)]){
		if ([CLLocationManager headingAvailable]) {
			return YES;
		}else {
			return NO;
		}
	}else{
		if (locationManager.headingAvailable) {
			return YES;
		}else {
			return NO;
		}
	}
}

#pragma mark  -
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	self.currentLocation = newLocation;
    
	//NPLog(@"lat: %f, long: %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    @autoreleasepool {
        NSString *str = [NSString stringWithFormat:@"%@",[[[self superview] superview] class]];
        if ([str isEqualToString:@"UITableViewCellContentView"]) {
            UIView *v = [[self superview] superview];
            UITableView *vTable = (UITableView *) [[[[v superview] superview] superview] superview];
            UIView *v2 = (UIView *) vTable.nextResponder;
//            NSLog(@"retaincount=%d", [self retainCount]);
            if ([v2 isKindOfClass:UIViewController.class]) {
                UIViewController * vc ;
                vc = (UIViewController *) v2.nextResponder;
//                NSLog(@"%@",vc.title);
            }
        }
        self.currentHeading = newHeading;
        
        if (self.currentHeading != nil && self.currentLocation != nil){
            self.hidden = NO;
        }
        
        float radiansToNorth = degreesToRadians(newHeading.magneticHeading);
        float bearingToTarget = [self bearingFromPoint:currentLocation.coordinate toPoint:self.target];
        CGAffineTransform transform = CGAffineTransformMakeRotation(bearingToTarget - radiansToNorth);
        self.transform = transform;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	if ( [error code] == kCLErrorDenied ) {
		[manager stopUpdatingHeading];
	} else if ([error code] == kCLErrorHeadingFailure) {
        // This error indicates that the heading could not be determined, most likely because of strong magnetic interference.
    }
}



/*-(BOOL)locationManagerShouldDisplayHeadingCalibration : (CLLocationManager *)manager {
 
 //do stuff
 
 return YES;
 }*/

@end
