//
//  APIManager.h
//  PistusApp
//
//  Created by Enguerran Henniart on 04/02/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (NSMutableDictionary*)authenticate:(NSString *)login :(NSString *)password;
+ (NSMutableDictionary*)getFromApi:(NSString *)url;
+ (NSMutableDictionary*)postToApi:(NSString *)url :(NSDictionary *)dict;


@end