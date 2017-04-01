//
//  ViewController.m
//  flowjackingdemo
//
//  Created by jasenhuang on 2017/3/23.
//  Copyright © 2017年 jasenhuang. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <flowjacking/flowjacking.h>

@interface ViewController ()
@property(nonatomic, strong) AFHTTPSessionManager* manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL* url = [NSURL URLWithString:@"https://www.baidu.com/"];
    //NSURLRequest* req = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:0];
    //[self.webview loadRequest:req];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    [configuration setProtocolClasses:@[[FJSessionProtocol class]]];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.manager POST:url.absoluteString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* content = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"success:%@", content);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
