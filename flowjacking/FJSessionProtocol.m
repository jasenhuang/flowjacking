//
//  FJSessionProtocol.m
//  flowjacking
//
//  Created by jasenhuang on 2017/3/23.
//  Copyright © 2017年 jasenhuang. All rights reserved.
//

#import "FJSessionProtocol.h"
#import "FJFlowStatistic.h"

@interface FJSessionProtocol()<NSURLSessionDelegate, NSURLSessionDataDelegate>
@property(nonatomic,strong) NSURLSession *session;
@end

@implementation FJSessionProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([NSURLProtocol propertyForKey:FJRequestKey inRequest:request]) {
        return NO;
    }
    NSString *scheme = [[request URL] scheme];
    if ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
        [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) {
        return YES;
    }
    return YES;
}

/*!
 @method canonicalRequestForRequest:
 @abstract This method returns a canonical version of the given
 request.
 @discussion It is up to each concrete protocol implementation to
 define what "canonical" means. However, a protocol should
 guarantee that the same input request always yields the same
 canonical form. Special consideration should be given when
 implementing this method since the canonical form of a request is
 used to look up objects in the URL cache, a process which performs
 equality checks between NSURLRequest objects.
 <p>
 This is an abstract method; sublasses must provide an
 implementation.
 @param request A request to make canonical.
 @result The canonical form of the given request.
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

/*!
 @method requestIsCacheEquivalent:toRequest:
 @abstract Compares two requests for equivalence with regard to caching.
 @discussion Requests are considered euqivalent for cache purposes
 if and only if they would be handled by the same protocol AND that
 protocol declares them equivalent after performing
 implementation-specific checks.
 @result YES if the two requests are cache-equivalent, NO otherwise.
 */
//+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
//{
//    return YES;
//}

/*!
 @method startLoading
 @abstract Starts protocol-specific loading of a request.
 @discussion When this method is called, the protocol implementation
 should start loading a request.
 */
- (void)startLoading
{
    if (!self.session){
        NSURLSessionConfiguration* configuration = [[NSURLSessionConfiguration alloc] init];
        self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    NSMutableURLRequest* request = [self.request mutableCopy];
    [NSURLProtocol setProperty:@(YES) forKey:FJRequestKey inRequest:request];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:self.request];
    [task resume];
    
}

/*!
 @method stopLoading
 @abstract Stops protocol-specific loading of a request.
 @discussion When this method is called, the protocol implementation
 should end the work of loading a request. This could be in response
 to a cancel operation, so protocol implementations must be able to
 handle this call while a load is in progress.
 */
- (void)stopLoading
{
    [self.client URLProtocol:self didFailWithError:[[NSError alloc] initWithDomain:@"stop loading" code:-1 userInfo:nil]];
}
@end
