//
//  FJFlowControl.m
    //  flowjacking
//
//  Created by jasenhuang on 2017/3/24.
//  Copyright © 2017年 jasenhuang. All rights reserved.
//

#import "FJFlowControl.h"
#import "FJURLProtocol.h"
#import "FJSessionProtocol.h"
#import <objc/runtime.h>

void swizzleInstanceMethod(Class cls, SEL origSelector, SEL newSelector)
{
    /* if current class not exist selector, then get super*/
    Method originalMethod = class_getInstanceMethod(cls, origSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, newSelector);
    /* add selector if not exist, implement append with method */
    if (class_addMethod(cls,
                        origSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* replace class instance method, added if selector not exist */
        /* for class cluster , it always add new selector here */
        class_replaceMethod(cls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        /* swizzleMethod maybe belong to super */
        class_replaceMethod(cls,
                            newSelector,
                            class_replaceMethod(cls,
                                                origSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
    }
}

@interface NSURLSessionConfiguration (Hook)
@end
@implementation NSURLSessionConfiguration (Hook)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInstanceMethod([NSURLSessionConfiguration class], @selector(init), @selector(hookInit));
        
        id obj = [NSURLSessionConfiguration defaultSessionConfiguration];
        swizzleInstanceMethod([obj class], @selector(setProtocolClasses:), @selector(hookSetProtocolClasses:));
    });
}
- (instancetype)hookInit
{
    NSURLSessionConfiguration* obj = [self hookInit];
    obj.protocolClasses = @[[FJSessionProtocol class]];
    return obj;
}
- (void)hookSetProtocolClasses:(NSArray<Class> *)protocolClasses
{
    NSMutableArray* protocols = [NSMutableArray array];
    if (![protocolClasses containsObject:[FJSessionProtocol class]]){
        if (protocolClasses.count) {
            [protocols addObjectsFromArray:protocolClasses];
        }
        [protocols addObject:[FJSessionProtocol class]];
    }
    [self hookSetProtocolClasses:protocols];
}
@end

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
- (void)start
{
    [NSURLProtocol registerClass:[FJURLProtocol class]];
}
- (void)stop
{
    [NSURLProtocol unregisterClass:[FJURLProtocol class]];
}
- (void)upwardFrom:(NSTimeInterval)start to:(NSTimeInterval)end
{
    
}
@end
