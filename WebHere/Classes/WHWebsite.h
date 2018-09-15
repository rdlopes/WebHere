//
// WHWebsite.h
// WebHere
//  
// Created by Rui Lopes on 13/10/2014.
//
// Copyright (c) 2014 Rui Lopes.
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

#ifndef WHWebsite_h
#define WHWebsite_h

#import <Foundation/Foundation.h>
#import "WHHTTPRequest.h"

FOUNDATION_EXPORT NSTimeInterval const kWHWebsiteDefaultTimeInterval;
FOUNDATION_EXPORT NSInteger const kWHWebsiteDefaultNumberOfRetries;

@protocol WHObject;

@interface WHWebsite : NSObject

@property(nonatomic, readonly) NSURL *baseURL;

@property(nonatomic, assign) NSStringEncoding requestEncoding;

@property(nonatomic, assign) NSTimeInterval timeoutInterval;

@property(nonatomic, assign) NSInteger numberOfRetries;

- (instancetype)initWithBaseURL:(NSURL *)baseURL;

- (instancetype)initWithBaseURL:(NSURL *)baseURL sessionConfiguration:(NSURLSessionConfiguration *)configuration;

+ (instancetype)websiteWithBaseURL:(NSURL *)baseURL;

+ (instancetype)websiteWithBaseURL:(NSURL *)baseURL sessionConfiguration:(NSURLSessionConfiguration *)configuration;

- (void)setAuthorizationUserName:(NSString *)username password:(NSString *)password;

- (void)send:(WHHTTPRequest *)request
     success:(void (^)(WHHTTPRequest *request, id <WHObject> responseObject))success
     failure:(void (^)(WHHTTPRequest *request, NSError *error))failure;

@end

#endif