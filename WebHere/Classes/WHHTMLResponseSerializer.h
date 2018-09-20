//
// WHHTMLResponseSerializer.h
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

#ifndef WHHTMLResponseSerializer_h
#define WHHTMLResponseSerializer_h

#import "AFURLResponseSerialization.h"

/**
 WHHTMLResponseSerializer is the AFNetworking implementation of a response serializer.
 It's used to receive the HTML response body, parse it and inject the parsed values into the WHObject defined as a target.

 @see [AFHTTPResponseSerializer](http://cocoadocs.org/docsets/AFNetworking/3.1.0/Protocols/AFURLResponseSerialization.html)
 */
@interface WHHTMLResponseSerializer : AFHTTPResponseSerializer

@end

#endif