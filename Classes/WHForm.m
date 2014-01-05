// WHForm.m
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

#import "WHObject.h"
#import "WHForm.h"
#import "HTMLDocument.h"
#import "HTMLNode+XPath.h"
#import "NSObject+Runtime.h"

@implementation WHForm

#pragma mark - Initialization
+(instancetype) formWithPath:(NSString *)path target:(Class<WHObject>)target {
    WHForm *form = (WHForm *) [[[self class] alloc] initWithPath:path target:target];
    form.HTTPMethod = @"POST";
    return form;
}

+ (instancetype)formForXPath:(NSString *)xpath inHTMLPage:(HTMLDocument *)page withTarget:(Class<WHObject>)target
{
    return [[self class] formForHTMLNode:[page.body nodeForXPath:xpath] withTarget:target];
}

+ (instancetype)formForHTMLNode:(HTMLNode *)formNode withTarget:(Class<WHObject>)target
{
    WHForm *form = nil;

    if (formNode && [formNode.tagName isEqualToString:@"form"]) {
        NSString *path = [formNode attributeForName:@"action"];
        form = [[self class] formWithPath:path target:target];

        // Method if provided
        NSString *method = [formNode attributeForName:@"method"];
        if (method && method.length) {
            if ([method caseInsensitiveCompare:@"post"] == NSOrderedSame) {
                form.HTTPMethod = @"POST";
            } else if ([method caseInsensitiveCompare:@"get"] == NSOrderedSame) {
                form.HTTPMethod = @"GET";
            }
        }

        // Encoding if provided
        NSString *encoding = [formNode attributeForName:@"accept-charset"];
        if (encoding && encoding.length) {
            form.encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)(encoding)));
        }

        NSArray *inputNodes = [formNode descendantsOfTag:@"input"];
        NSSet *propertiesNames = [self propertiesNames];
        for (HTMLNode *inputNode in inputNodes) {
            if (![[inputNode attributeForName:@"type"] isEqualToString:@"submit"]) {

                NSString *parameterName = [inputNode attributeForName:@"name"];
                NSString *parameterValue = [inputNode attributeForName:@"value"];

                if (parameterName) {
                    if ([propertiesNames containsObject:parameterName]) {
                        if (parameterValue) {
                            [form setValue:parameterValue forKey:parameterName];
                        }
                    } else {
                        form.queryParameters[parameterName] = parameterValue ? parameterValue : @"";
                    }
                }
            }
        }
    }

    return form;
}

#pragma mark - Properties
-(NSMutableDictionary *) queryParameters {
    for (NSString *property in [[self class] propertiesNames]) {
        id <NSObject> value = [self valueForKey:property];
        if (value) {
            _queryParameters[property] = value;
        }
    }
    return _queryParameters;
}

@end
