//
//  AppDelegate.m
//  PistusApp
//
//  Created by Lucie on 22/10/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "AppDelegate.h"
#import "GeolocalisationManager.h"
#import "StatsViewController.h"
#import "ClassementViewController.h"
#import "GraphsViewController.h"
#import "DataManager.h"

@interface AppDelegate ()

@property (nonatomic,strong) NSDictionary *news;

@end

// 1er jour du Pistus (samedi de l'arrivée)
int const startDay = 5;
int const startMonth = 3;
int const startYear = 2016;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSString *authKey = [defaults stringForKey:@"authKey"];
    UIViewController *viewController;
    if([authKey length] < 1)
    {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewNavigator"];
    }
    else {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewNavigator"];
    }
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
        
    // On récupère les données de localisation et les statistiques de l'utilisateur
    NSData *gmEncoded = [[defaults objectForKey:@"GeolocalisationManager"] objectAtIndex:0];
    GeolocalisationManager *gm = [NSKeyedUnarchiver unarchiveObjectWithData:gmEncoded];
    [GeolocalisationManager setSharedInstance:gm];
    gm = [GeolocalisationManager sharedInstance];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendrier = [NSCalendar currentCalendar];
    NSDateComponents *composants = [calendrier components:(NSDayCalendarUnit|NSMonthCalendarUnit) fromDate:date];
    int jour = (int)[composants day];
    int mois = (int)[composants month];
    if(mois==startMonth && jour>startDay && jour<=startDay+7)
    {
        if(![gm.joursFinis[jour-startDay-1] boolValue])
        {
            // On sauvegarde les infos sur le dernier jour ou l'appli a été active
            composants = [calendrier components:NSDayCalendarUnit fromDate:gm.derniereDate];
            int dernierJour = (int)[composants day];
            for(int j=dernierJour;j<jour;j++)
            {
                [gm sauvegarderDonneesJour:j-startDay :true];
            }
        }
    }
    else if((jour>startDay+7 && mois==startMonth)||(mois>startMonth))
    {
        composants = [calendrier components:NSDayCalendarUnit fromDate:gm.derniereDate];
        int dernierJour = (int)[composants day];
        for(int j=dernierJour;j<=startDay+7;j++)
        {
            [gm sauvegarderDonneesJour:j-startDay :true];
        }
    }
    if(mois ==startMonth && jour>=startDay && jour<startDay+7)
    {
        // On met en place le timer pour actualiser les statistiques de la semaine trois fois par jour même quand le GPS est désactivé
        [composants setYear:startYear];
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
        [composants setMonth:startMonth];
        [composants setDay:startDay+9];
        [composants setHour:0];
        [composants setMinute:0];
        NSDate *dateTimer4 = [[NSCalendar currentCalendar] dateFromComponents:composants];
        timer4 = [[NSTimer alloc] initWithFireDate:dateTimer4 interval:3600 target:self selector:@selector(stopTimers:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer4 forMode:NSDefaultRunLoopMode];
    }
    
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        [[GeolocalisationManager sharedInstance] endTrack];
    }
    if([[GeolocalisationManager sharedInstance] trackAccept])
    {
        [[GeolocalisationManager sharedInstance] beginTrack];
    }
    
    // On supprime toutes les notifications locales précédemment enregistrées
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // On télécharge les news
    // Get News from API
    [DataManager getData:@"allNews" completion:^(NSMutableDictionary *dict) {
        _news = dict;
        NSMutableArray *myAndGeneralNews = [[NSMutableArray alloc] init];
        [myAndGeneralNews addObjectsFromArray:_news[@"myNews"]];
        [myAndGeneralNews addObjectsFromArray:_news[@"generalNews"]];
        
        // Sort news to keep only those with an earlier date
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        for(long i=myAndGeneralNews.count-1;i>=0;i--){
            NSDate *dateTime = [df dateFromString:myAndGeneralNews[i][@"date"]];
            if([dateTime compare:[NSDate date]]==NSOrderedDescending)
            {
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.fireDate = dateTime;
                @try {
                    localNotification.alertTitle= myAndGeneralNews[i][@"title"];
                } @catch (NSException *exception) {
                    //
                }
                // Transformer le texte HTML en texte sans balises HTML
                localNotification.alertBody = [self convertHTML:myAndGeneralNews[i][@"text"]];
                localNotification.alertAction = @"Faire glisser pour voir la news";
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                localNotification.applicationIconBadgeNumber = 1;
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            }
        }
    }];
    
    // Ask the user the permission to display alerts
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];
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
    // On désactive la géolocalisation par défaut
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:notification.alertTitle
                          message:notification.alertBody delegate:self
                          cancelButtonTitle:@"J'ai compris" otherButtonTitles:nil];
    [alert show];
}

-(void)stopTimers:(NSTimer*)timer
{
    [timer1 invalidate];
    [timer2 invalidate];
    [timer3 invalidate];
}

-(NSString *)convertHTML:(NSString *)html {
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString: @"&nbsp;" withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

@end
