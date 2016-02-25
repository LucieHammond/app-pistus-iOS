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
+ (NSData*)getFromApi:(NSString *)url;
+ (void)getFromApi2:(NSString *)url completion:(void(^)(NSData *data, NSError *error))completion;
+ (NSMutableDictionary*)postToApi:(NSString *)url :(NSDictionary *)dict;

@end