// WHSiteManager.m
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

#import "WHSiteManager.h"
#import "AFHTTPSessionManager.h"
#import "WHResponseSerializer.h"

NSStringEncoding const kWHDefaultStringEncoding = NSUTF8StringEncoding;

#pragma mark - Private WHSiteManager
@interface WHSiteManager ()

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

#pragma mark - Implementation WHSiteManager
@implementation WHSiteManager

#pragma mark - Initialization
- (instancetype)initWithBaseURL:(NSURL *)url {
    return [self initWithBaseURL:url encoding:kWHDefaultStringEncoding];
}

- (instancetype)initWithBaseURL:(NSURL *)url encoding:(NSStringEncoding)encoding {
    return [self initWithBaseURL:url encoding:encoding sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    return [self initWithBaseURL:url encoding:kWHDefaultStringEncoding sessionConfiguration:configuration];
}

- (instancetype)initWithBaseURL:(NSURL *)url encoding:(NSStringEncoding)encoding sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [[[self class] alloc] init];
    if (self) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
        _sessionManager.responseSerializer = [WHResponseSerializer serializerWithEncoding:encoding];
    }
    return self;
}

#pragma mark - Properties
- (NSURL *)baseURL {
    return self.sessionManager.baseURL;
}


#pragma mark - <NSCoding>

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    if (self) {
        _sessionManager = [decoder decodeObjectForKey:NSStringFromSelector(@selector(sessionManager))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.sessionManager forKey:NSStringFromSelector(@selector(sessionManager))];
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone {
    WHSiteManager *siteManager = [[[self class] allocWithZone:zone] init];
    siteManager.sessionManager = [self.sessionManager copyWithZone:zone];
    return siteManager;
}

@end
