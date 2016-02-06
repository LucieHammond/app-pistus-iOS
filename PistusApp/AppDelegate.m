//
//  AppDelegate.m
//  PistusApp
//
//  Created by Lucie on 22/10/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "AppDelegate.h"
#import "NXOAuth2.h"
#import "GeolocalisationManager.h"
#import "StatsViewController.h"
#import "ClassementViewController.h"
#import "GraphsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // On récupère les données de localisation et les statistiques de l'utilisateur
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *gmEncoded = [[defaults objectForKey:@"GeolocalisationManager"] objectAtIndex:0];
    GeolocalisationManager *gm = [NSKeyedUnarchiver unarchiveObjectWithData:gmEncoded];
    [GeolocalisationManager setSharedInstance:gm];
    gm = [GeolocalisationManager sharedInstance];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendrier = [NSCalendar currentCalendar];
    NSDateComponents *composants = [calendrier components:(NSDayCalendarUnit|NSMonthCalendarUnit) fromDate:date];
    int jour = (int)[composants day];
    int mois = (int)[composants month];
    if(mois==3 && jour>5 && jour<=12)
    {
        if(!gm.joursFinis[jour-6])
        {
            // On sauvegarde les infos sur le dernier jour ou l'appli a été active
            composants = [calendrier components:NSDayCalendarUnit fromDate:gm.derniereDate];
            int dernierJour = (int)[composants day];
            for(int j=dernierJour;j<jour;j++)
            {
                [gm sauvegarderDonnéesJour:j-5 :true];
            }
        }
    }
    else if((jour>12 && mois==3)||(mois>3))
    {
        composants = [calendrier components:NSDayCalendarUnit fromDate:gm.derniereDate];
        int dernierJour = (int)[composants day];
        for(int j=dernierJour;j<=12;j++)
        {
            [gm sauvegarderDonnéesJour:j-5 :true];
        }
    }
    if(mois ==3 && jour>=5 && jour<12)
    {
        // On met en place le timer pour actualiser les statistiques de la semaine trois fois par jour même quand le GPS est désactivé
        [composants setYear:2016];
        [composants setMonth:mois];
        [composants setDay:jour];
        [composants setHour:12];
        [composants setMinute:30];
        NSDate *dateTimer1 = [[NSCalendar currentCalendar] dateFromComponents:composants];
        timer1 = [[NSTimer alloc] initWithFireDate:dateTimer1 interval:86400 target:[GeolocalisationManager sharedInstance] selector:@selector(sauvegardeParTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
        
        [composants setHour:17];
        [composants setMinute:30];
        NSDate *dateTimer2 = [[NSCalendar currentCalendar] dateFromComponents:composants];
        timer2 = [[NSTimer alloc] initWithFireDate:dateTimer2 interval:86400 target:[GeolocalisationManager sharedInstance] selector:@selector(sauvegardeParTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
        
        [composants setHour:23];
        [composants setMinute:59];
        NSDate *dateTimer3 = [[NSCalendar currentCalendar] dateFromComponents:composants];
        timer3 = [[NSTimer alloc] initWithFireDate:dateTimer3 interval:86400 target:[GeolocalisationManager sharedInstance] selector:@selector(sauvegardeParTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer3 forMode:NSDefaultRunLoopMode];
        
        // Le timer 4 permet d'invalider les trois premiers quand le Pistus est fini.
        [composants setMonth:3];
        [composants setDay:14];
        [composants setHour:0];
        [composants setMinute:0];
        NSDate *dateTimer4 = [[NSCalendar currentCalendar] dateFromComponents:composants];
        timer4 = [[NSTimer alloc] initWithFireDate:dateTimer4 interval:3600 target:self selector:@selector(stopTimers:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer4 forMode:NSDefaultRunLoopMode];
    }
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:1];
    NSData *gmEncoded = [NSKeyedArchiver archivedDataWithRootObject:[GeolocalisationManager sharedInstance]];
    [archiveArray addObject:gmEncoded];
    [defaults setObject:archiveArray forKey:@"GeolocalisationManager"];
    [defaults synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void) initialize{
    [[NXOAuth2AccountStore sharedStore] setClientID:@"33_vjatz1es19ckoo44ookw4o4w0scw0s4g0cwco8ogwsow0scok"
        secret:@"3oslqcvwxiskcw0gcws4s4k44kogw0wksggsso0co4okswwk4c"
        authorizationURL:[NSURL URLWithString:@"https://my.ecp.fr/oauth/v2/auth"]
        tokenURL:[NSURL URLWithString:@"https://my.ecp.fr/oauth/v2/token"]
        redirectURL:[NSURL URLWithString:@"monpistus://login"]
        forAccountType:@"pistonski"];
    
    NSMutableDictionary *configuration = [NSMutableDictionary dictionaryWithDictionary:[[NXOAuth2AccountStore sharedStore] configurationForAccountType:@"pistonski"]];
    [[NXOAuth2AccountStore sharedStore] setConfiguration:configuration forAccountType:@"pistonski"];
    
    // On désactive la géolocalisation par défaut
    [[GeolocalisationManager sharedInstance] endTrack];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    if([[url host]  isEqual: @"login"])
        NSLog(@"Reponse reçue !");
    else
        NSLog(@"Pas le bon URI");
    
    return YES;
}

-(void)stopTimers:(NSTimer*)timer
{
    [timer1 invalidate];
    [timer2 invalidate];
    [timer3 invalidate];
}

@end
