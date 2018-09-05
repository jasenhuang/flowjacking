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

@interface FJFlowControl()
@property(nonatomic, strong) NSMutableArray* configurations;
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
- (instancetype)init
{
    self = [super init];
    if (self) {
        _configurations = [NSMutableArray array];
    }
    return self;
}

- (void)addConfiguration:(NSURLSessionConfiguration *)configuration
{
    [_configurations addObject:configuration];
}
- (void)removeConfiguration:(NSURLSessionConfiguration *)configuration
{
    [_configurations removeObject:configuration];
}

- (void)start
{
    [NSURLProtocol registerClass:[FJURLProtocol class]];
    NSMutableArray* protocols;
    for (NSURLSessionConfiguration* configuration in self.configurations) {
        if (configuration.protocolClasses.count){
            protocols = [NSMutableArray arrayWithArray:protocols];
        }else{
            protocols = [NSMutableArray array];
        }
        [protocols addObject:[FJSessionProtocol class]];
        configuration.protocolClasses = protocols;
    }
}
- (void)stop
{
    [NSURLProtocol unregisterClass:[FJURLProtocol class]];
    NSMutableArray* protocols;
    for (NSURLSessionConfiguration* configuration in self.configurations) {
        if (configuration.protocolClasses.count){
            protocols = [NSMutableArray arrayWithArray:protocols];
        }
        [protocols removeObject:configuration];
        configuration.protocolClasses = protocols;
    }
}
- (void)upwardFrom:(NSTimeInterval)start to:(NSTimeInterval)end
{
    
}
@end

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
    });
}

- (instancetype)hookInit
{
    NSURLSessionConfiguration* obj = [self hookInit];
    [[FJFlowControl shareControl] addConfiguration:obj];
    return obj;
}
@end
