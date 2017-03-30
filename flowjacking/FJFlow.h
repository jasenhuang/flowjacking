//
//  FJFlow.h
//  flowjacking
//
//  Created by jasenhuang on 2017/3/29.
//  Copyright © 2017年 jasenhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJFlow : NSObject
@property(nonatomic, strong, readonly) NSString* domain;

- (instancetype)initWithDomain:(NSString*)domain;
- (void)upward:(NSInteger)size;
- (void)downward:(NSInteger)size;
- (void)reset;
@end
