//
//  GeolocalisationManager.h
//  PistusApp
//
//  Created by Lucie on 26/12/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeolocalisationManager : NSObject

+(GeolocalisationManager*)sharedInstance;
+(void)beginTrack;
+(void)endTrack;
+(BOOL)trackAccept;

@end
