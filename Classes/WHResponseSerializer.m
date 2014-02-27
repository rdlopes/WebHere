// WHResponseSerializer.m
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

#import <GDataXML-HTML/GDataXMLNode.h>
#import "WHResponseSerializer.h"

static NSError * WHErrorWithUnderlyingError(NSError *error, NSError *underlyingError) {
    if (!error) {
        return underlyingError;
    }
    
    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }
    
    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;
    
    return [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
}

static BOOL WHErrorOrUnderlyingErrorHasCode(NSError *error, NSInteger code) {
    if (error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return WHErrorOrUnderlyingErrorHasCode(error.userInfo[NSUnderlyingErrorKey], code);
    }
    
    return NO;
}

@implementation WHResponseSerializer

+ (instancetype)serializer {
    return [self serializerWithEncoding:NSUTF8StringEncoding];
}

+ (instancetype)serializerWithEncoding:(NSStringEncoding)encoding {
    WHResponseSerializer *serializer = [[self alloc] init];
    serializer.stringEncoding = encoding;
    return serializer;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.acceptableContentTypes = [NSSet setWithObjects:
            @"text/html",
            @"text/xml",
            @"text/plain",
            @"application/xhtml+xml",
            @"xml",
            nil];

    return self;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response
                           data:(NSData *)data
                          error:(NSError * __autoreleasing *)error {
    if (![self validateResponse:(NSHTTPURLResponse *) response data:data error:error]) {
        if (WHErrorOrUnderlyingErrorHasCode(*error, NSURLErrorCannotDecodeContentData)) {
            return nil;
        }
    }

      NSStringEncoding stringEncoding = self.stringEncoding;
//    if (response.textEncodingName) {
//        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
//        if (encoding != kCFStringEncodingInvalidId) {
//            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
//        }
//    }

    NSError *serializationError = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:data encoding:stringEncoding error:&serializationError];
    
    if (error) {
        *error = WHErrorWithUnderlyingError(serializationError, *error);
    }
    
    return document;
}


@end
