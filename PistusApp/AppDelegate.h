//
//  AppDelegate.h
//  PistusApp
//
//  Created by Lucie on 22/10/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const int startDay;
extern const int startMonth;
extern const int startYear;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSTimer *timer1;
    NSTimer *timer2;
    NSTimer *timer3;
    NSTimer *timer4;
}

@property (strong, nonatomic) UIWindow *window;


@end

