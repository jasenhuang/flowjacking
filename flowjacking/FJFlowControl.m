//
//  FJFlowControl.m
    //  flowjacking
//
//  Created by jasenhuang on 2017/3/24.
//  Copyright © 2017年 jasenhuang. All rights reserved.
//

#import "FJFlowControl.h"
#import "FJFlow.h"

@interface FJFlowControl()

@end

@implementation FJFlowControl
+ (FJFlowControl*)shareControl
{
    static FJFlowControl* control;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [[FJFlowControl alloc] init];
    });
    return control;
}

@end
