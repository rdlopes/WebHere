//
// WHPerson+HTML.m
// WebHere
//
// Created by Rui Lopes on 06/10/2014.
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

#import <GDataXML-HTML/GdataXMLNode.h>
#import "WHPerson+HTML.h"

@interface WHPerson ()
@end

@implementation WHPerson (HTML)

+ (BOOL)matches:(GDataXMLDocument *)html
    fromRequest:(WHHTTPRequest *)request {
    NSError *error = nil;
    return [html firstNodeForXPath:@"//div[@id='age']" error:&error] != nil
            && [html firstNodeForXPath:@"//div[@id='rights']" error:&error] == nil
            && error == nil;
}

- (void)buildFromHTML:(GDataXMLDocument *)html
          fromRequest:(WHHTTPRequest *)request
                error:(NSError **)error {
    self.fullName = [html firstNodeForXPath:@"//title" error:error].stringValue;
    self.age = [html firstNodeForXPath:@"//div[@id='age']" error:error].stringValue.integerValue;
    self.city = [html firstNodeForXPath:@"//div[@id='city']" error:error].stringValue;
    self.country = [html firstNodeForXPath:@"//div[@id='country']" error:error].stringValue;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@ - %@ | %ld y/o | %@ - %@]",
                                      [super description], self.fullName, (unsigned long) self.age, self.city, self.country];
}

@end

@implementation WHAdmin (HTML)

+ (BOOL)matches:(GDataXMLDocument *)html
    fromRequest:(WHHTTPRequest *)request {
    NSError *error = nil;
    return [html firstNodeForXPath:@"//div[@id='rights']" error:&error] != nil
            && error == nil;
}

- (void)buildFromHTML:(GDataXMLDocument *)html
          fromRequest:(WHHTTPRequest *)request
                error:(NSError **)error {
    [super buildFromHTML:html fromRequest:request error:error];

    self.nickname = [html firstNodeForXPath:@"//div[@id='nickname']" error:error].stringValue;

    NSString *rights = [html firstNodeForXPath:@"//div[@id='rights']" error:error].stringValue;
    if ([rights isEqualToString:@"ReadWrite"]) {
        self.rights = WHAdminRightsReadWrite;
    } else if ([rights isEqualToString:@"WriteOnly"]) {
        self.rights = WHAdminRightsWriteOnly;
    } else {
        self.rights = WHAdminRightsUnknown;
    }
}

@end

@implementation WHUnmatchedPerson (HTML)

+ (BOOL)matches:(GDataXMLDocument *)html
    fromRequest:(WHHTTPRequest *)request {
    return NO;
}

- (void)buildFromHTML:(GDataXMLDocument *)html
          fromRequest:(WHHTTPRequest *)request
                error:(NSError **)error {
}

@end

