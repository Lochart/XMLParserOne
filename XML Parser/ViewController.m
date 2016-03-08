//
//  ViewController.m
//  XML Parser
//
//  Created by Nikolay on 06.03.16.
//  Copyright © 2016 Nikolay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self url];
}

-(void)url{
    NSURL *url = [NSURL URLWithString:self.videoURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
