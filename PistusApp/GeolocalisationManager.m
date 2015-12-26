//
//  GeolocalisationManager.m
//  PistusApp
//
//  Created by Lucie on 26/12/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "GeolocalisationManager.h"

@implementation GeolocalisationManager

+(GeolocalisationManager*)sharedInstance
{
    static GeolocalisationManager* sharedInstance;
    return sharedInstance;
}

@end
