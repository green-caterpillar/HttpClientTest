//
//  CBHTTPClient.m
//  HttpClientTest
//
//  Created by Selim Mustafaev on 21/12/2016.
//  Copyright © 2016 Selim Mustafaev. All rights reserved.
//

#import "CBHTTPClient.h"

@interface CBHTTPClient ()

@property (nonatomic) NSString* url;

@end

@implementation CBHTTPClient

- (instancetype)initWithUrl:(NSString*)url {
    self = [super init];
    if(self) {
        self.url = url;
    }
    return self;
}

- (void)sendRequest:(NSDictionary*)params {
    NSMutableString* urlWithParams = [self.url mutableCopy];
    
    if(params && [params count]  > 0) {
        [urlWithParams appendString:@"?"];
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [urlWithParams appendFormat:@"%@=%@&", key, obj];
        }];
    }
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlWithParams]];
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error && error.code == -1001 && [self.delegate respondsToSelector:@selector(requestTimeout)]) {
            [self.delegate requestTimeout];
            return;
        }
        
        NSHTTPURLResponse* resp = (NSHTTPURLResponse*)response;
        if(self.delegate) {
            if(resp.statusCode >= 200 && resp.statusCode < 300 && [self.delegate respondsToSelector:@selector(requestOK:)]) {
                [self.delegate requestOK:data];
            } else if(resp.statusCode >= 500 && resp.statusCode < 600 && [self.delegate respondsToSelector:@selector(requestTryAgain:)]) {
                [self.delegate requestTryAgain:error];
            }
        }
    }];
    
    [task resume];
}


@end
