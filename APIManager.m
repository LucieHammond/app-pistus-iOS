//
//  APIManager.m
//  PistusApp
//
//  Created by Enguerran Henniart on 04/02/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "APIManager.h"
#include <CommonCrypto/CommonDigest.h>

@implementation APIManager

+ (void)authenticate:(NSString *)login :(NSString *)password completion:(void(^)(NSMutableDictionary *dict))completion {
    // Encoding sha1
    const char *cStr = [password UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, (unsigned int)strlen(cStr), result);
    
    // Base64 encoding
    NSData *nsdataPassword = [[NSData alloc] initWithBytes:result length:sizeof(result)];
    NSString *hash = [nsdataPassword base64EncodedStringWithOptions:0];
    NSString *finalHash = [@"{SHA}" stringByAppendingString:hash];

    NSMutableDictionary *body = [[NSMutableDictionary alloc]initWithCapacity:1];
    [body setObject:finalHash forKey:@"pass"];
    
    NSString *url = [NSString stringWithFormat:@"http://apistus.via.ecp.fr/auth/%@", login];

    [self postToApi:url :body completion:^(NSData *data, NSError *error) {
        if(data != nil)
        {
            NSMutableDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if(responseJson != NULL) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:responseJson[@"authKey"] forKey:@"authKey"];
                [defaults setObject:responseJson[@"data"][@"login"] forKey:@"login"];
                [defaults synchronize];
                
                if(completion) {
                    completion(responseJson);
                }
            }
            else {
                if(completion) {
                    completion(nil);
                }
            }
        }
        else {
            if(completion) {
                completion(nil);
            }
        }
    }];
}

+(void)getFromApi:(NSString *)url completion:(void(^)(NSData *data, NSError *error))completion {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *authKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"authKey"];

    if(authKey != NULL)
    {
        url = [url stringByReplacingOccurrencesOfString:@"AUTH_KEY" withString:authKey];
    }
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

        if((long)[httpResponse statusCode] == 200) {
            if(completion) {
                completion(data, error);
            }
        }
        else {
            if(completion) {
                completion(nil, error);
            }
        }
     }];
}

+ (void)postToApi:(NSString *)url :(NSDictionary *)dict completion:(void(^)(NSData *data, NSError *error))completion {
    NSLog(@"post to api");
    NSError *error = nil;
    
    NSString *authKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"authKey"];
    
    if(authKey != NULL)
    {
        url = [url stringByReplacingOccurrencesOfString:@"AUTH_KEY" withString:authKey];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postdata];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if((long)[httpResponse statusCode] == 200) {
            if(completion) {
                completion(data, error);
            }
        }
        else {
            if(completion) {
                completion(nil, error);
            }
        }
    }];    
}


@end