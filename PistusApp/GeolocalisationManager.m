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

@implementation GeolocalisationManager

+(GeolocalisationManager*)sharedInstance
{
    static GeolocalisationManager* sharedInstance;
    return sharedInstance;
}

+(void)beginTrack
{
    trackAccept = true;
    timerPosition = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(boucle) userInfo:nil repeats:YES];
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
