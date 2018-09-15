//
// WHHTMLResponseSerializer.m
// WebHere
//
// Created by Rui Lopes on 14/10/2014.
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

#import "WHHTMLResponseSerializer.h"
#import "GDataXMLNode.h"

static NSError *WHErrorWithUnderlyingError(NSError *error,
        NSError *underlyingError) {
    if (!error) {
        return underlyingError;
    }

    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }

    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;

    return [[NSError alloc] initWithDomain:error.domain
                                      code:error.code
                                  userInfo:mutableUserInfo];
}

static BOOL WHErrorOrUnderlyingErrorHasCodeInDomain(NSError *error,
        NSInteger code,
        NSString *domain) {
    if ([error.domain isEqualToString:domain] && error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return WHErrorOrUnderlyingErrorHasCodeInDomain(
                error.userInfo[NSUnderlyingErrorKey], code, domain);
    }

    return NO;
}

@interface WHHTMLResponseSerializer ()

@end

@implementation WHHTMLResponseSerializer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.acceptableContentTypes =
                [[NSSet alloc] initWithObjects:
                        @"text/html",
                        @"text/xml",
                        @"text/plain",
                        @"application/xml",
                        @"application/xhtml+xml",
                        @"xml",
                        nil];
    }
    return self;
}

+ (instancetype)serializer {
    WHHTMLResponseSerializer *serializer = [[self alloc] init];
    return serializer;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    if (![self validateResponse:(NSHTTPURLResponse *) response
                           data:data
                          error:error]) {
        if (!error || WHErrorOrUnderlyingErrorHasCodeInDomain(
                *error, NSURLErrorCannotDecodeContentData,
                AFURLResponseSerializationErrorDomain)) {
            return nil;
        }
    }

    NSStringEncoding stringEncoding = self.stringEncoding;
    if (response.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef) response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }

    NSError *serializationError = nil;
    GDataXMLDocument *document =
            [[GDataXMLDocument alloc] initWithHTMLData:data
                                              encoding:stringEncoding
                                                 error:&serializationError];

    if (error) {
        *error = WHErrorWithUnderlyingError(serializationError, *error);
    }

    return document;
}

#pragma mark - NSSecureCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    WHHTMLResponseSerializer *serializer = (WHHTMLResponseSerializer *) [[[self class] allocWithZone:zone] init];
    return serializer;
}

@end
