// WHLink.m
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
#import "WHLink.h"
#import "HTMLDocument.h"
#import "HTMLNode+XPath.h"

@implementation WHLink

+ (instancetype)linkWithPath:(NSString *)path target:(Class<WHObject>)target {
    WHLink *link = (WHLink *) [[[self class] alloc] initWithPath:path target:target];
    link.HTTPMethod = @"GET";
    return link;
}

+ (instancetype)linkForXPath:(NSString *)xpath inHTMLPage:(HTMLDocument *)page withTarget:(Class<WHObject>)target
{
    return [[self class] linkForHTMLNode:[page.body nodeForXPath:xpath] withTarget:target];
}

+ (instancetype)linkForHTMLNode:(HTMLNode *)anchorNode withTarget:(Class<WHObject>)target
{
    WHLink *link = nil;

    if (anchorNode && [anchorNode.tagName isEqualToString:@"a"]) {
        link = [[self class] linkWithPath:[anchorNode attributeForName:@"href"] target:target];
        link.label = anchorNode.textContentCollapsingWhitespace;
        if (link.label.length == 0) {
            link.label = [anchorNode attributeForName:@"title"];
        }

        HTMLNode *imgNode = [anchorNode descendantOfTag:@"img"];
        if (imgNode) {
            link.imagePath = imgNode.srcValue;
            if (link.label.length == 0) {
                link.label = [imgNode attributeForName:@"alt"];
            }
        }
    }

    return link;
}

@end
