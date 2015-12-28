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
}

@property (nonatomic) BOOL trackAccept;
@property (nonatomic) double distanceStation;

+(GeolocalisationManager*)sharedInstance;
-(BOOL)beginTrack;
-(void)endTrack;
-(BOOL)trackAccept;

@end
