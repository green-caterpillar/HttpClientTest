//
//  ViewController.m
//  HttpClientTest
//
//  Created by Selim Mustafaev on 21/12/2016.
//  Copyright © 2016 Selim Mustafaev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) CBHTTPClient* httpClient;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.httpClient = [[CBHTTPClient alloc] initWithUrl:@"https://api.desktoppr.co/1/wallpapers"];
    self.httpClient.delegate = self;
    [self.httpClient sendRequest:@{@"page": @2}];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

#pragma mark - CBHTTPClientDelegate

- (void)requestOK:(NSData*)response {
    NSLog(@"requestOK");
}

- (void)requestTryAgain:(NSError*)error {
    NSLog(@"requestTryAgain");
}

- (void)requestTimeout {
    NSLog(@"requestTimeout");
}

@end
