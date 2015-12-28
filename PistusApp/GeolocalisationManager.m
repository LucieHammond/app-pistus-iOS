//
//  GeolocalisationManager.m
//  PistusApp
//
//  Created by Lucie on 26/12/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "GeolocalisationManager.h"

static BOOL trackAccept;
static NSTimer *timerPosition;
static CLLocationManager* locationManager;

@implementation GeolocalisationManager

+(GeolocalisationManager*)sharedInstance
{
    static GeolocalisationManager* sharedInstance=nil;
    if (sharedInstance == nil) {
        sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

+(BOOL)beginTrack
{
    trackAccept = true;
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
    {
        [locationManager requestAlwaysAuthorization];
    }
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
    {
        return false;
    }
    
    locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 100.0f;
        [locationManager startUpdatingLocation];
    }
    timerPosition = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(boucle) userInfo:nil repeats:YES];
    return true;
}

+(void)endTrack
{
    trackAccept = false;
    [timerPosition invalidate];
}

+(void)boucle
{
    NSLog(@"1");
}

+(BOOL)trackAccept
{
    return trackAccept;
}


@end
