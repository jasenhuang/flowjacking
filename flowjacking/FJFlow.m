//
//  FJFlow.m
//  flowjacking
//
//  Created by jasenhuang on 2017/3/29.
//  Copyright © 2017年 jasenhuang. All rights reserved.
//

#import "FJFlow.h"
#import "FJPacket.h"

@interface FJFlow()
@property(nonatomic, strong) NSString* domain;
@property(nonatomic, strong) NSMutableArray<FJPacket*>* upwardPackets;
@property(nonatomic, strong) NSMutableArray<FJPacket*>* downwardPackets;
@end

@implementation FJFlow
- (instancetype)initWithDomain:(NSString*)domain
{
    if (self = [self init]){
        _domain = domain;
    }
    return self;
}
- (void)upward:(FJPacket*)packet
{
    [self.upwardPackets addObject:packet];
}
- (void)downward:(FJPacket*)packet
{
    [self.downwardPackets addObject:packet];
}
- (void)reset
{
    [self.upwardPackets removeAllObjects];
    [self.downwardPackets removeAllObjects];
}
@end
