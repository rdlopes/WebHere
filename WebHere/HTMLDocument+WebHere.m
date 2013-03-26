// HTMLDocument+WebHere.m
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

#import "HTMLDocument+WebHere.h"
#import "HTMLNode.h"
#import "HTMLNode+XPath.h"
#import "WHLink.h"
#import "WHForm.h"

@implementation HTMLDocument (WebHere)

-(WHLink *) linkForXPath:(NSString *)xpath withTarget:(Class<WHObject>)target
{
    return [self linkForHTMLNode:[self.body nodeForXPath:xpath] withTarget:target];
}

-(WHLink *) linkForHTMLNode:(HTMLNode *)anchorNode withTarget:(Class<WHObject>)target
{
    return [WHLink linkForHTMLNode:anchorNode withTarget:target];
}

-(WHForm *) formForXPath:(NSString *)xpath withTarget:(Class<WHObject>)target
{
    return [self formForHTMLNode:[self.body nodeForXPath:xpath] withTarget:target];
}

-(WHForm *) formForHTMLNode:(HTMLNode *)formNode withTarget:(Class<WHObject>)target
{
    return [WHForm formForHTMLNode:formNode withTarget:target];
}

@end
