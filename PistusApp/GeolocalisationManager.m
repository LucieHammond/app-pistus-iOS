//
//  GeolocalisationManager.m
//  PistusApp
//
//  Created by Lucie on 26/12/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "GeolocalisationManager.h"
#import "CarteViewController.h"
#import "AppDelegate.h"

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
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        
        // Les préférences par défaut sont peu précises et adaptés à un déplacement en car.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.distanceFilter = 700.0f;
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager requestWhenInUseAuthorization];
        }
        locationManager.pausesLocationUpdatesAutomatically = true;
        locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        [locationManager startUpdatingLocation];
        //timerPosition = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(boucle) userInfo:nil repeats:YES];
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

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%d",locations.count);
    CLLocation *lastLocation = locations.lastObject;
    double latitude = lastLocation.coordinate.latitude;
    float longitude = lastLocation.coordinate.longitude;
    
    // On vérifie si l'utilisateur se trouve bien sur le domaine skiable de la station
    if(latitude > 44.21 && latitude < 44.37 && longitude > 6.53 && longitude < 6.63)
    {
        NSLog(@"Potentiellement localisable sur la carte");
        _distanceStation=0;
    }
    else
    {
        /* Dans le cas où l'utilisateur ne se trouve pas sur la station, on affiche la distance
         que le sépare de la résidence */
        CLLocation *residence = [[CLLocation alloc]initWithLatitude:44.292 longitude:6.565];
        _distanceStation = [lastLocation distanceFromLocation:residence];
        NSLog(@"%f",_distanceStation);
    }
    
    // Si l'utilisateur est sur la carte, on update la vue automatiquement
    AppDelegate *tmpDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav= (UINavigationController*)tmpDelegate.window.rootViewController;
    if ([nav.visibleViewController.title isEqual:@"Carte View Controller"])
    {
        [nav.visibleViewController viewDidLoad];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Erreur de localisation");
}

- (void)locationManagerDidPausedLocationUpdates:(CLLocationManager *)manager
{
    
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    
}

@end
