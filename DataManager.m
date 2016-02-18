//
//  DataManager.m
//  PistusApp
//
//  Created by Enguerran Henniart on 19/02/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "DataManager.h"
#import "APIManager.h"

@implementation DataManager

+ (NSString*) baseUrl {
    return @"http://apistus.via.ecp.fr";
}

+(NSDictionary*)endpoints {
    NSDictionary *ep = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"/news/AUTH_KEY/my", @"myNews",
                        @"/news/AUTH_KEY/general", @"generalNews",
                        @"/user/AUTH_KEY", @"users",
                        @"/ranking/AUTH_KEY", @"ranking",
                        @"/contest/AUTH_KEY", @"contest",
                        @"/info/AUTH_KEY", @"generalInfo",
                        @"/slope/AUTH_KEY", @"slope",
                        @"/lift/AUTH_KEY", @"lift",
                        nil];
    return ep;
}

+ (NSMutableDictionary*)getData:(NSString *)type {
    NSString *url = [NSString stringWithFormat:@"%@%@", DataManager.baseUrl, DataManager.endpoints[type]];
    return [APIManager getFromApi:url];
}


@end
