//
//  AppDelegate.m
//  PistusApp
//
//  Created by Lucie on 22/10/2015.
//  Copyright (c) 2015 Lucie. All rights reserved.
//

#import "AppDelegate.h"
#import "NXOAuth2.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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

@end
