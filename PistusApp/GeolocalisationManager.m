//
//  GeolocalisationManager.m
//  PistusApp
//
//  Created by Lucie on 26/12/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "GeolocalisationManager.h"

static GeolocalisationManager* sharedInstance=nil;

@implementation GeolocalisationManager

+(GeolocalisationManager*)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[[self class] alloc] init];
    }
    return sharedInstance;
}

-(BOOL)beginTrack
{
    _trackAccept = true;
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
    {
        [_locationManager requestAlwaysAuthorization];
    }
    if ([CLLocationManager locationServicesEnabled])
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 100.0f;
        [_locationManager startUpdatingLocation];
        timerPosition = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(boucle) userInfo:nil repeats:YES];
        return true;
    }
    else
    {
        return false;
    }
}

-(void)endTrack
{
    _trackAccept = false;
    [timerPosition invalidate];
}

-(void)boucle
{
    NSLog(@"1");
}

-(BOOL)trackAccept
{
    return _trackAccept;
}


@end
