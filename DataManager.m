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
                        @"/room/AUTH_KEY/my", @"room",
                        nil];
    return ep;
}


+ (NSMutableDictionary*)getData:(NSString *)type {
    NSString *url = [NSString stringWithFormat:@"%@%@", DataManager.baseUrl, DataManager.endpoints[type]];
    NSData *apiResponseData = [APIManager getFromApi:url];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *jsonPath=[[paths objectAtIndex:0] stringByAppendingFormat:[NSString stringWithFormat:@"/%@.json", type]];
    
    if(apiResponseData == nil) {
        NSData *localResponseData = [NSData dataWithContentsOfFile:jsonPath];
        if(localResponseData == nil) {
            return NULL;
        }
        else {
            NSMutableDictionary *localResponse = [NSJSONSerialization JSONObjectWithData:localResponseData options:NSJSONReadingMutableContainers error:nil];
            return localResponse;
        }
    }
    else {
        [apiResponseData writeToFile:jsonPath atomically:YES];

        return [NSJSONSerialization JSONObjectWithData:apiResponseData options:NSJSONReadingMutableContainers error:nil];
    }
}


@end
