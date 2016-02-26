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
+ (void)authenticate2:(NSString *)login :(NSString *)password completion:(void(^)(NSMutableDictionary *dict))completion;
+ (NSData*)getFromApi:(NSString *)url;
+ (void)getFromApi2:(NSString *)url completion:(void(^)(NSData *data, NSError *error))completion;
+ (NSMutableDictionary*)postToApi:(NSString *)url :(NSDictionary *)dict;
+ (void)postToApi2:(NSString *)url :(NSDictionary *)dict completion:(void(^)(NSData *data, NSError *error))completion;

@end