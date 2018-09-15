//
// WHHTTPRequest+HTML.m
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

#import "WHHTTPRequest+HTML.h"
#import "WHHTTPRequest+Internal.h"
#import "NSObject+Runtime.h"
#import "GDataXMLNode.h"

@implementation WHHTTPRequest (HTML)

- (instancetype)initWithNode:(GDataXMLNode *)node
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class)target
                       error:(NSError **)error {
    return [self initWithPath:@"" target:target];
}

- (instancetype)initWithHTML:(GDataXMLDocument *)html atXPath:(NSString *)xpath fromRequest:(WHHTTPRequest *)request target:(Class <WHObject>)target error:(NSError **)error {
    return [self initWithNode:[html firstNodeForXPath:xpath error:error] fromRequest:request target:target error:error];
}

@end

@implementation WHLink (HTML)

+ (instancetype)linkWithHTML:(GDataXMLDocument *)html
                     atXPath:(NSString *)xpath
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class)target
                       error:(NSError **)error {
    return [[self alloc] initWithHTML:html atXPath:xpath fromRequest:request target:target error:error];
}

+ (instancetype)linkWithNode:(GDataXMLNode *)node fromRequest:(WHHTTPRequest *)request target:(Class <WHObject>)target error:(NSError **)error {
    return [[self alloc] initWithNode:node fromRequest:request target:target error:error];
}

- (instancetype)initWithNode:(GDataXMLNode *)node
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class)target
                       error:(NSError **)error {

    self = [super initWithNode:node
                   fromRequest:request
                        target:target
                         error:error];

    if (self && !*error) {
        if (node && node.kind == GDataXMLElementKind &&
                [node.name isEqualToString:@"a"]) {

            GDataXMLElement *element = (GDataXMLElement *) node;
            self.path = [element attributeForName:@"href"].stringValue;
            self.label = element.stringValue;
            if (self.label.length == 0) {
                self.label = [element attributeForName:@"title"].stringValue;
            }

            GDataXMLElement *imgElement = [element elementsForName:@"img"].firstObject;
            if (imgElement) {
                self.imagePath = [imgElement attributeForName:@"src"].stringValue;
                if (self.label.length == 0) {
                    self.label = [imgElement attributeForName:@"alt"].stringValue;
                }
            }
        }
    }

    return self;
}

@end

@implementation WHForm (HTML)

- (instancetype)initWithNode:(GDataXMLNode *)node
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class)target
                       error:(NSError **)error {

    self = [super initWithNode:node
                   fromRequest:request
                        target:target
                         error:error];

    if (self && !*error) {
        if (node && node.kind == GDataXMLElementKind &&
                [node.name isEqualToString:@"form"]) {

            GDataXMLElement *element = (GDataXMLElement *) node;
            self.path = [element attributeForName:@"action"].stringValue;

            // Method if provided
            NSString *method = [element attributeForName:@"method"].stringValue;
            if (method && method.length) {
                if ([method caseInsensitiveCompare:@"post"] == NSOrderedSame) {
                    self.HTTPMethod = @"POST";
                } else if ([method caseInsensitiveCompare:@"get"] == NSOrderedSame) {
                    self.HTTPMethod = @"GET";
                }
            }

            // Encoding if provided
            NSString *encoding = [element attributeForName:@"accept-charset"].stringValue;
            if (encoding && encoding.length) {
                self.encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef) (encoding)));
            }

            NSArray *inputNodes = [node nodesForXPath:@".//input" error:error];
            NSSet *propertiesNames = [[self class] propertiesNames];
            for (GDataXMLNode *inputNode in inputNodes) {

                if (inputNode.kind == GDataXMLElementKind) {
                    element = (GDataXMLElement *) inputNode;

                    if (![[element attributeForName:@"type"].stringValue isEqualToString:@"submit"]) {
                        NSString *parameterName = [element attributeForName:@"name"].stringValue;
                        NSString *parameterValue = [element attributeForName:@"value"].stringValue;

                        if (parameterName) {
                            if ([propertiesNames containsObject:parameterName]) {
                                if (parameterValue) {
                                    [self setValue:parameterValue forKey:parameterName];
                                }
                            } else {
                                self.queryParameters[parameterName] = parameterValue ? parameterValue : @"";
                            }
                        }
                    }
                }

            }
        }
    }

    return self;
}

+ (instancetype)formWithHTML:(GDataXMLDocument *)html
                     atXPath:(NSString *)xpath
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class)target
                       error:(NSError **)error {
    return [[self alloc] initWithHTML:html atXPath:xpath fromRequest:request target:target error:error];
}

+ (instancetype)formWithNode:(GDataXMLNode *)node fromRequest:(WHHTTPRequest *)request target:(Class)target error:(NSError **)error {
    return [[self alloc] initWithNode:node fromRequest:request target:target error:error];
}

@end