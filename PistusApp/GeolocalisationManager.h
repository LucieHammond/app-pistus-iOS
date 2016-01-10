//
//  GeolocalisationManager.h
//  PistusApp
//
//  Created by Lucie on 26/12/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface GeolocalisationManager : NSObject <CLLocationManagerDelegate>
{
    NSTimer *timerPosition;
    CLLocationManager* locationManager;
    NSDate *dateDebutSki;
    double derniereAltitude;
    int dernierNumero;
}

@property (nonatomic) BOOL trackAccept;
@property (nonatomic) double distanceStation;
@property (nonatomic) double vitesseMax;
@property (nonatomic) double altitudeMax;
@property (nonatomic) double deniveleTotal;
@property (nonatomic) NSTimeInterval tempsDeSki;
@property (nonatomic) NSDate *derniereDate;
@property (nonatomic) int dernierX;
@property (nonatomic) int dernierY;
@property (nonatomic) NSString *dernierePiste;
@property (nonatomic) NSString *pisteProche;

+(GeolocalisationManager*)sharedInstance;
-(BOOL)beginTrack;
-(void)endTrack;
-(BOOL)trackAccept;

@end
