//
//  AIKLocationManager.h
//  Kiwi
//
//  Created by Christian Hatch on 1/24/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


//extern NSString * const AIKLocationManagerUserLocationDidChangeNotification;
//extern NSString * const AIKLocationManagerNotificationLocationUserInfoKey;

typedef void(^AIKLocationManagerLocationUpdateBlock)(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation);
typedef void (^AIKLocationManagerLocationUpdateFailBlock)(CLLocationManager *manager, NSError *error);


@interface AIKLocationManager : NSObject

@property (nonatomic, readonly) CLLocation *location;


@property (nonatomic, assign) CLLocationDistance userDistanceFilter;
@property (nonatomic, assign) CLLocationAccuracy userDesiredAccuracy;


+ (AIKLocationManager *)sharedManager;

+ (BOOL)locationPermittedOrAsk;

+ (BOOL)locationServicesEnabled;
+ (BOOL)regionMonitoringAvailable;
+ (BOOL)regionMonitoringEnabled;
+ (BOOL)significantLocationChangeMonitoringAvailable;

- (void)startUpdatingLocation;
- (void)startUpdatingLocationWithBlock:(AIKLocationManagerLocationUpdateBlock)block errorBlock:(AIKLocationManagerLocationUpdateFailBlock)errorBlock; 
- (void)retriveUserLocationWithBlock:(AIKLocationManagerLocationUpdateBlock)block errorBlock:(AIKLocationManagerLocationUpdateFailBlock)errorBlock; 
- (void)updateUserLocation;
- (void)stopUpdatingLocation;


@end

