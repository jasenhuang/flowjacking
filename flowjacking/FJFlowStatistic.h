//
//  FJFlowStatistic.h
//  flowjacking
//
//  Created by jasenhuang on 2017/3/29.
//  Copyright © 2017年 jasenhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const FJRequestKey;

@interface FJFlowStatistic : NSObject

+ (FJFlowStatistic*)shareStatistic;

- (void) upwardPacket:(NSInteger)length domain:(NSString*)domain;

- (void) downwardPacket:(NSInteger)length domain:(NSString*)domain;

- (void) resetDomain:(NSString*)domain;

- (void) reset;
@end
