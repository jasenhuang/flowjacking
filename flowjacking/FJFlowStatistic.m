//
//  FJFlowStatistic.m
//  flowjacking
//
//  Created by jasenhuang on 2017/3/29.
//  Copyright © 2017年 jasenhuang. All rights reserved.
//

#import "FJFlowStatistic.h"
#import "FJFlow.h"
#import "FJPacket.h"

NSString* const FJRequestKey = @"FJRequestKey";

@interface FJFlowStatistic()
@property(nonatomic, strong) NSMutableDictionary<NSString*, FJFlow*>* statistic;
@end

@implementation FJFlowStatistic
+ (FJFlowStatistic*)shareStatistic
{
    static FJFlowStatistic* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FJFlowStatistic alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _statistic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void) upwardPacket:(NSInteger)length domain:(NSString*)domain
{
    NSAssert(domain.length, @"domain is empty!");
    FJFlow* flow = self.statistic[domain];
    if (!flow){
        flow = [[FJFlow alloc] initWithDomain:domain];
        [self.statistic setObject:flow forKeyedSubscript:domain];
    }
    FJPacket* packet = [[FJPacket alloc] initWithSize:length];
    [flow upward:packet];
}

- (void) downwardPacket:(NSInteger)length domain:(NSString*)domain
{
    NSAssert(domain.length, @"domain is empty!");
    FJFlow* flow = self.statistic[domain];
    if (!flow){
        flow = [[FJFlow alloc] initWithDomain:domain];
        [self.statistic setObject:flow forKeyedSubscript:domain];
    }
    FJPacket* packet = [[FJPacket alloc] initWithSize:length];
    [flow downward:packet];
}

- (void)resetDomain:(NSString*)domain
{
    FJFlow* flow = self.statistic[domain];
    if (flow){
        [flow reset];
    }
}

- (void)reset
{
    [self.statistic removeAllObjects];
}

@end
