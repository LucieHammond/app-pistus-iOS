//
//  GeolocalisationManager.h
//  PistusApp
//
//  Created by Lucie on 26/12/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GeolocalisationManager : NSObject <CLLocationManagerDelegate>
{
    NSTimer *timerPosition;
}

@property (nonatomic) BOOL trackAccept;
@property (nonatomic) CLLocationManager* locationManager;

+(GeolocalisationManager*)sharedInstance;
-(BOOL)beginTrack;
-(void)endTrack;
-(BOOL)trackAccept;

@end
