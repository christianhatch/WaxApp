//
//  AIKLocationManager.m
//  Kiwi
//
//  Created by Christian Hatch on 1/24/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "AIKLocationManager.h"
#import "AcaciaKit.h"


#define kDefaultUserDistanceFilter      kCLLocationAccuracyBestForNavigation
#define kDefaultUserDesiredAccuracy     kCLLocationAccuracyBest

NSString * const AIKLocationManagerUserLocationDidChangeNotification = @"AIKLocationManagerUserLocationDidChangeNotification";
NSString * const AIKLocationManagerNotificationLocationUserInfoKey = @"newLocation";

@interface AIKLocationManager () <CLLocationManagerDelegate>{
    BOOL _isUpdatingUserLocation;
    BOOL _isOnlyOneRefresh;
    NSTimer *_queryingTimer;
    NSDate *_startDate;
}

@property (nonatomic, readonly) CLLocationManager *userLocationManager;

- (void)_init;

@end

@interface AIKLocationManager () // Blocks

@property (copy) AIKLocationManagerLocationUpdateBlock locationBlock;
@property (copy) AIKLocationManagerLocationUpdateFailBlock errorLocationBlock;

@end

@implementation AIKLocationManager


@synthesize location = _location;

@synthesize userLocationManager = _userLocationManager;

@synthesize userDistanceFilter = _userDistanceFilter;
@synthesize userDesiredAccuracy = _userDesiredAccuracy;

@synthesize locationBlock, errorLocationBlock;

+ (AIKLocationManager *)sharedManager {
    static AIKLocationManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AIKLocationManager alloc] init];
    });
    
    return _sharedClient;
}

- (id)init{    
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (void)_init{    
    _isUpdatingUserLocation = NO;
    _isOnlyOneRefresh = NO;
    _startDate = [[NSDate alloc] init]; 
    _userLocationManager = [[CLLocationManager alloc] init];
    _userLocationManager.distanceFilter = kDefaultUserDistanceFilter;
    _userLocationManager.desiredAccuracy = kDefaultUserDesiredAccuracy;
    _userLocationManager.delegate = self;
}

#pragma mark - Setters

- (void)setUserDistanceFilter:(CLLocationDistance)userDistanceFilter{    
    _userDistanceFilter = userDistanceFilter;
    [_userLocationManager setDistanceFilter:_userDistanceFilter];
}

- (void)setUserDesiredAccuracy:(CLLocationAccuracy)userDesiredAccuracy{    
    _userDesiredAccuracy = userDesiredAccuracy;
    [_userLocationManager setDesiredAccuracy:_userDesiredAccuracy];
}

#pragma mark - Getters

- (CLLocation *)location{
    return _location;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{    
    if (self.errorLocationBlock != nil) {
        self.errorLocationBlock(manager, error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSDate *eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if(abs(howRecent) > 10.0) {
        return;
    }
    if (![self isValidLocation:newLocation]) {
        return; 
    }
    _location = newLocation;
    
    if (newLocation.horizontalAccuracy <= manager.desiredAccuracy) {
        [self stopQueryingTimer];
        
        if (_isOnlyOneRefresh) {
            [_userLocationManager stopUpdatingLocation];
            _isOnlyOneRefresh = NO;
        }
        
        if (self.locationBlock != nil) {
            self.locationBlock(manager, newLocation, oldLocation);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:AIKLocationManagerUserLocationDidChangeNotification object:self userInfo:([NSDictionary dictionaryWithObject:newLocation forKey:AIKLocationManagerNotificationLocationUserInfoKey])];
	}
}

#pragma mark - Utilities
- (BOOL) isValidLocation:(CLLocation*)location {
	// Filter out nil locations
    if (location == nil) {
        return NO;
    }

    // Filter out points by invalid accuracy
    if (location.horizontalAccuracy < 0) {
        return NO;
    }
    
    // Filter out points that are out of order
    NSTimeInterval secondsSinceLastPoint = [location.timestamp timeIntervalSinceDate:self.location.timestamp];
    
    if (secondsSinceLastPoint < 0) {
        return NO;
    }
    
    // Filter out points created before the manager was initialized
    NSTimeInterval secondsSinceManagerStarted = [location.timestamp timeIntervalSinceDate:_startDate];
    
    if (secondsSinceManagerStarted < 0) {
        return NO;
    }

    return YES;
}

#pragma mark Public Methods

+ (BOOL)locationServicesEnabled{
    return [CLLocationManager locationServicesEnabled];
}

+ (BOOL)locationPermittedOrAsk{
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
            [[AIKLocationManager sharedManager] startUpdatingLocation];
        }
        return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
    }else{
        return NO;
    }
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    [[AIKLocationManager sharedManager] stopUpdatingLocation]; 
}
- (void)startUpdatingLocation{    
    _isUpdatingUserLocation = YES;
    [self.userLocationManager startUpdatingLocation];
    [self startQueryingTimer];
}

- (void)startUpdatingLocationWithBlock:(AIKLocationManagerLocationUpdateBlock)block errorBlock:(AIKLocationManagerLocationUpdateFailBlock)errorBlock{
    
    self.locationBlock = block;
    self.errorLocationBlock = errorBlock;
    
    [self startUpdatingLocation];
}

-(void)startQueryingTimer{
    [self stopQueryingTimer];
    _queryingTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(queryingTimerPassed) userInfo: nil repeats: YES];
}

-(void)stopQueryingTimer{
    if (_queryingTimer){
		if ([_queryingTimer isValid]){
			[_queryingTimer invalidate];
		}
		_queryingTimer = nil;
	}
}

-(void)queryingTimerPassed{
    [self stopUpdatingLocation];
    [self stopQueryingTimer];
    
    if (self.locationBlock != nil) {
        self.locationBlock(self.userLocationManager, _location, nil);
    }
}

- (void)retriveUserLocationWithBlock:(AIKLocationManagerLocationUpdateBlock)block errorBlock:(AIKLocationManagerLocationUpdateFailBlock)errorBlock {
    
    _isOnlyOneRefresh = YES;
    
    [self startUpdatingLocationWithBlock:block errorBlock:errorBlock];
}

- (void)updateUserLocation{    
    if (!_isOnlyOneRefresh) {
        _isOnlyOneRefresh = YES;
        [_userLocationManager startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation{    
    _isUpdatingUserLocation = NO;
    [self.userLocationManager stopUpdatingLocation];
}



@end
