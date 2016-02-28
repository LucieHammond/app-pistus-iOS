//
//  APIManager.h
//  PistusApp
//
//  Created by Enguerran Henniart on 04/02/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (void)authenticate:(NSString *)login :(NSString *)password completion:(void(^)(NSMutableDictionary *dict))completion;
+ (void)getFromApi:(NSString *)url completion:(void(^)(NSData *data, NSError *error))completion;
+ (void)postToApi:(NSString *)url :(NSDictionary *)dict completion:(void(^)(NSData *data, NSError *error))completion;

@end