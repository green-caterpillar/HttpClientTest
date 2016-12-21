//
//  CBHTTPClient.h
//  HttpClientTest
//
//  Created by Selim Mustafaev on 21/12/2016.
//  Copyright © 2016 Selim Mustafaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CBHTTPClientDelegate <NSObject>

- (void)requestOK:(NSData*)response;
- (void)requestTryAgain:(NSError*)error;
- (void)requestTimeout;

@end


@interface CBHTTPClient : NSObject

@property (nonatomic) id<CBHTTPClientDelegate> delegate;

- (instancetype)initWithUrl:(NSString*)url;
- (void)sendRequest:(NSDictionary*)params;

@end
