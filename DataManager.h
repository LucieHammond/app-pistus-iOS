//
//  DataManager.h
//  PistusApp
//
//  Created by Enguerran Henniart on 19/02/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (NSString*) baseUrl;
+ (NSDictionary*) endpoints;

+ (NSMutableDictionary*)getData:(NSString *)type;

@end
