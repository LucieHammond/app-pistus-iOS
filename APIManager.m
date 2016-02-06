//
//  APIManager.m
//  PistusApp
//
//  Created by Enguerran Henniart on 04/02/2016.
//  Copyright © 2016 Lucie. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

+(void)getFromApi:(NSString *)url{
    NSLog(@"get from api");
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    NSString *resp = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];

    NSLog(@"%@", resp);
    

}

+(void)postToApi:(NSString *)url :(NSObject *)dict{
    NSLog(@"post to api");
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postdata];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postdata length]] forHTTPHeaderField:@"Content-Length"];
    [request setURL:[NSURL URLWithString:url]];

    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    NSString *resp = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", resp);
}


@end