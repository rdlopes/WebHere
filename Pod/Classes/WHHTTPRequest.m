//
// WHHTTPRequest.m
// WebHere
//
// Created by Rui Lopes on 13/10/2014.
//
// Copyright (c) 2014 Rui Lopes
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "WHHTTPRequest.h"
#import "NSObject+Runtime.h"

NSString *const kWHHTTPRequestRetryCount = @"kWHHTTPRequestRetryCount";

@interface WHHTTPRequest () {
@protected
    NSMutableDictionary *_queryParameters;
    NSMutableArray *_alternativeTargets;
}
@property(nonatomic, weak) NSURLSessionDataTask *dataTask;
@property(nonatomic, assign) NSStringEncoding encoding;

@end

@implementation WHHTTPRequest

@synthesize queryParameters = _queryParameters;
@synthesize alternativeTargets = _alternativeTargets;

- (NSInteger)retryCount {
    return [_userInfo[kWHHTTPRequestRetryCount] integerValue];
}

- (void)setRetryCount:(NSInteger)retryCount {
    _userInfo[kWHHTTPRequestRetryCount] = @(retryCount);
}

- (instancetype)initWithPath:(NSString *)path target:(Class <WHObject>)target {
    NSParameterAssert(path);
    NSParameterAssert(target);

    self = [super init];
    if (self) {
        _HTTPMethod = @"GET";
        _path = path;
        _targetClass = target;
        _encoding = NSUTF8StringEncoding;
        _alternativeTargets = [@[] mutableCopy];
        _queryParameters = [@{} mutableCopy];
        _userInfo = [@{} mutableCopy];
        self.retryCount = 0;
    }
    return self;
}

+ (instancetype)requestWithPath:(NSString *)path
                         target:(Class <WHObject>)target {
    return [[self alloc] initWithPath:path target:target];
}

- (NSString *)description {
    __block NSString *description =
            [NSString stringWithFormat:@"[%@ - %@ \"%@\" -> %@", [super description],
                                       self.HTTPMethod, self.path,
                                       NSStringFromClass(self.targetClass)];

    [self.alternativeTargets
            enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                description = [description
                        stringByAppendingFormat:@"/%@",
                                                NSStringFromClass((Class <WHObject>) obj)];
            }];

    if (self.queryParameters.count > 0) {
        description = [description stringByAppendingString:@" ("];
        [[self.queryParameters allKeys]
                               enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                   description = [description
                                           stringByAppendingFormat:@"%@=%@;", obj,
                                                                   (self.queryParameters)[obj]];
                               }];
        description = [description stringByAppendingString:@")]"];
    }
    return description;
}

@end

@implementation WHLink

+ (instancetype)linkWithPath:(NSString *)path target:(Class <WHObject>)target {
    WHLink *link = [[self alloc] initWithPath:path target:target];
    return link;
}

@end

@implementation WHForm

+ (instancetype)formWithPath:(NSString *)path target:(Class <WHObject>)target {
    WHForm *form = [[self alloc] initWithPath:path target:target];
    if (form) {
        form.HTTPMethod = @"POST";
    }
    return form;
}

- (NSMutableDictionary *)queryParameters {
    for (NSString *property in [[self class] propertiesNames]) {
        id <NSObject> value = [self valueForKey:property];
        if (value) {
            _queryParameters[property] = value;
        }
    }
    return _queryParameters;
}

@end
