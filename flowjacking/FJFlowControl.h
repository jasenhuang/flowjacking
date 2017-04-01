//
//  FJFlowControl.h
//  flowjacking
//
//  Created by jasenhuang on 2017/3/24.
//  Copyright © 2017年 jasenhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FJFlowControl : NSObject
+ (FJFlowControl*)shareControl;
- (void)start;
- (void)stop;
@end
