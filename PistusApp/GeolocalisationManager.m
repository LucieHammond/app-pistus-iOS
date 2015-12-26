//
//  GeolocalisationManager.m
//  PistusApp
//
//  Created by Lucie on 26/12/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "GeolocalisationManager.h"

@implementation GeolocalisationManager
{
    NSTimer *timerPosition;
}

+(GeolocalisationManager*)sharedInstance
{
    static GeolocalisationManager* sharedInstance;
    return sharedInstance;
}

-(void)beginTrack
{
    timerPosition = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(boucle) userInfo:nil repeats:YES];
}

-(void)endTrack
{
    [timerPosition invalidate];
}

-(void)boucle
{
    NSLog(@"1");
}

@end
