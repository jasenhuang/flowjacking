//
//  FJFlow.m
//  flowjacking
//
//  Created by jasenhuang on 2017/3/29.
//  Copyright © 2017年 jasenhuang. All rights reserved.
//

#import "FJFlow.h"

@interface FJFlow()
@property(nonatomic, strong) NSString* domain;
@property(nonatomic, assign) NSUInteger upwardFlow;
@property(nonatomic, assign) NSUInteger downwardFlow;
@end

@implementation FJFlow
- (instancetype)initWithDomain:(NSString*)domain
{
    if (self = [self init]){
        _domain = domain;
    }
    return self;
}
- (void)upward:(NSInteger)size
{
    self.upwardFlow += size;
}
- (void)downward:(NSInteger)size
{
    self.downwardFlow += size;
}
- (void)reset
{
    self.upwardFlow = 0;
    self.downwardFlow = 0;
}
@end
