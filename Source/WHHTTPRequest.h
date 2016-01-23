//
// WHHTTPRequest.h
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

#ifndef WHHTTPRequest_h
#define WHHTTPRequest_h

#import <Foundation/Foundation.h>

#import "WHObject.h"

@interface WHHTTPRequest : NSObject

@property(nonatomic, strong) NSString *HTTPMethod;
@property(nonatomic, strong) NSString *path;

@property(nonatomic, readonly) NSMutableDictionary *queryParameters;
@property(nonatomic, readonly) NSMutableArray *alternativeTargets;

@property(nonatomic, readonly) NSMutableDictionary *userInfo;

@property(nonatomic, assign) Class <WHObject> targetClass;
@property(assign) NSInteger retryCount;

+ (instancetype)requestWithPath:(NSString *)path target:(Class <WHObject>)target;

- (instancetype)initWithPath:(NSString *)path target:(Class <WHObject>)target;

@end

@interface WHLink : WHHTTPRequest

@property(nonatomic, strong) NSString *label;
@property(nonatomic, strong) NSString *imagePath;

+ (instancetype)linkWithPath:(NSString *)path target:(Class <WHObject>)target;

@end

@interface WHForm : WHHTTPRequest

+ (instancetype)formWithPath:(NSString *)path target:(Class <WHObject>)target;

@end

#endif