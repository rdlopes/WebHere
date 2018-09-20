//
// WHObject.h
// WebHere
//
// Created by Rui Lopes on 06/10/2014.
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
//

#ifndef WHObject_h
#define WHObject_h

#import <Foundation/Foundation.h>

@class WHHTTPRequest;
@class GDataXMLDocument;

/**
 WHObject defines a protocol that needs to be implemented by all possible targets. This defines how an HTML document
 can be parsed to be turned into a WHObject by parsing its content.
 */
@protocol WHObject <NSObject>

/**
 Tells whether this object can be parsed from the HTML it receives, issued by the passed request.

 @param html the HTML to test
 @param request the request issued to the website.
 */
@optional
+ (BOOL)matches:(GDataXMLDocument *)html
    fromRequest:(WHHTTPRequest *)request;

/**
 Performs the actual parsing of the HTML document into the final form of this object.
 A developer needs to implement that method in order to inject the desired properties into its target object.
 You can use CSS selectors and various parsing methods found in the GDataXML-HTML library.

 @param html the HTML to test
 @param request the request issued to the website.

 @see [GDataXMLNode](http://cocoadocs.org/docsets/GDataXML-HTML/1.3.0/Classes/GDataXMLNode.html)
 @see [GDataXMLDocument](http://cocoadocs.org/docsets/GDataXML-HTML/1.3.0/Classes/GDataXMLDocument.html)
 */
@required
- (void)buildFromHTML:(GDataXMLDocument *)html
          fromRequest:(WHHTTPRequest *)request
                error:(NSError **)error;

@end

#endif