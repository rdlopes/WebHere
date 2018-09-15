//
// WHHTTPRequest+HTML.h
// WebHere
//
// Created by Rui Lopes on 19/10/14.
//
// Copyright (c) 2013 Rui D Lopes
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
//

#ifndef WHHTTPRequest_html_h
#define WHHTTPRequest_html_h

#import <Foundation/Foundation.h>

#import "WHHTTPRequest.h"

@class GDataXMLNode;

@interface WHHTTPRequest (HTML)

- (instancetype)initWithNode:(GDataXMLNode *)node
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class<WHObject>)target
                       error:(NSError **)error;

- (instancetype)initWithHTML:(GDataXMLDocument *)html
                     atXPath:(NSString *)xpath
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class<WHObject>)target
                       error:(NSError **)error;

@end

@interface WHLink (HTML)

+ (instancetype)linkWithHTML:(GDataXMLDocument *)html
                     atXPath:(NSString *)xpath
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class<WHObject>)target
                       error:(NSError **)error;

+ (instancetype)linkWithNode:(GDataXMLNode *)node
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class<WHObject>)target
                       error:(NSError **)error;

@end

@interface WHForm (HTML)

+ (instancetype)formWithHTML:(GDataXMLDocument *)html
                     atXPath:(NSString *)xpath
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class<WHObject>)target
                       error:(NSError **)error;

+ (instancetype)formWithNode:(GDataXMLNode *)node
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class<WHObject>)target
                       error:(NSError **)error;

@end

#endif