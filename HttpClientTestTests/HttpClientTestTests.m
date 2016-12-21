//
//  HttpClientTestTests.m
//  HttpClientTestTests
//
//  Created by Selim Mustafaev on 21/12/2016.
//  Copyright © 2016 Selim Mustafaev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CBHTTPClient.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

@interface HttpClientTestTests : XCTestCase <CBHTTPClientDelegate>

@property (nonatomic) CBHTTPClient* httpClient;
@property (nonatomic) XCTestExpectation* responseExpectation;

@end

@implementation HttpClientTestTests

- (void)setUp {
    [super setUp];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return [request.URL.path isEqualToString:@"/success"];
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        return [OHHTTPStubsResponse responseWithData:[NSData new] statusCode:200 headers:nil];
    }];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return [request.URL.path isEqualToString:@"/tryagain"];
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        return [OHHTTPStubsResponse responseWithData:[NSData new] statusCode:500 headers:nil];
    }];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return [request.URL.path isEqualToString:@"/timeout"];
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSError* error = [NSError errorWithDomain:NSURLErrorDomain code:-1001 userInfo:nil];
        return [OHHTTPStubsResponse responseWithError:error];
    }];
}

- (void)tearDown {
    [OHHTTPStubs removeAllStubs];
    [super tearDown];
}

- (void)testSuccessfulQuery {
    self.responseExpectation = [self expectationWithDescription:@"successful query"];
    self.httpClient = [[CBHTTPClient alloc] initWithUrl:@"http://example.com/success"];
    self.httpClient.delegate = self;
    [self.httpClient sendRequest:@{@"param": @42}];
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testFailedQuery {
    self.responseExpectation = [self expectationWithDescription:@"failed query"];
    self.httpClient = [[CBHTTPClient alloc] initWithUrl:@"http://example.com/tryagain"];
    self.httpClient.delegate = self;
    [self.httpClient sendRequest:@{@"param": @42}];
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testTimeoutQuery {
    self.responseExpectation = [self expectationWithDescription:@"timeout query"];
    self.httpClient = [[CBHTTPClient alloc] initWithUrl:@"http://example.com/timeout"];
    self.httpClient.delegate = self;
    [self.httpClient sendRequest:@{@"param": @42}];
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

#pragma mark - CBHTTPClientDelegate

- (void)requestOK:(NSData*)response {
    if([self.responseExpectation.description isEqualToString:@"successful query"]) {
        [self.responseExpectation fulfill];
    }
}

- (void)requestTryAgain:(NSError*)error {
    if([self.responseExpectation.description isEqualToString:@"failed query"]) {
        [self.responseExpectation fulfill];
    }
}

- (void)requestTimeout {
    if([self.responseExpectation.description isEqualToString:@"timeout query"]) {
        [self.responseExpectation fulfill];
    }
}

@end
