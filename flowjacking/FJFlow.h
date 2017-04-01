//
//  FJFlow.h
//  flowjacking
//
//  Created by jasenhuang on 2017/3/29.
//  Copyright © 2017年 jasenhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FJPacket;
@interface FJFlow : NSObject
@property(nonatomic, strong, readonly) NSString* domain;

- (instancetype)initWithDomain:(NSString*)domain;
- (void)upward:(FJPacket*)packet;
- (void)downward:(FJPacket*)packet;
- (void)reset;
@end
