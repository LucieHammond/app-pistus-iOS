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
    int dernierNumero;
    NSDate *derniereDate;
    CLLocation *avantDerniereLoc;
}

// Statistiques
@property (nonatomic) double distanceStation;
@property (nonatomic) double vitesseActuelle;
@property (nonatomic) double vitesseMax;
@property (nonatomic) double vitesseCumulee;
@property (nonatomic) double totalPositions;
@property (nonatomic) double altitudeActuelle;
@property (nonatomic) double altitudeMin;
@property (nonatomic) double altitudeMax;
@property (nonatomic) double distanceSki;
@property (nonatomic) double distanceTot;
@property (nonatomic) double deniveleTotal;
@property (nonatomic) NSTimeInterval tempsDeSki;

// Carte
@property (nonatomic) BOOL trackAccept;
@property (nonatomic) int dernierX;
@property (nonatomic) int dernierY;
@property (nonatomic) NSString *dernierePiste;
@property (nonatomic) NSString *pisteProche;

+(GeolocalisationManager*)sharedInstance;
-(BOOL)beginTrack;
-(void)endTrack;
-(BOOL)trackAccept;

@end
