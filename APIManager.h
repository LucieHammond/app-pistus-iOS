//
//  APIManager.h
//  PistusApp
//
//  Created by Enguerran Henniart on 04/02/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

@property NSString *baseUrl;

+ (void)getFromApi:(NSString *)url;
+ (void)postToApi:(NSString *)url :(NSObject *)dict;


@end
