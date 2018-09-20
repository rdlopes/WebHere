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

/**
 WHHTTPRequest extension to allow a developer to create request fragments out of an HTML page received from the internet.
 This extension is used when one has to create a fragment that is not a link (a tags) or a form (form tags).
 Usually, creating requests fragments would only require to use WHLink and WHForm extensions.
 */
@interface WHHTTPRequest (HTML)

/**
 Creates a WHHTTPRequest fragment out of a GDataXMLNode.

 @param node the node containing the description of this request, in HTML
 @param request the request that the GDataXMLNode originated from.
 @param target the resulting object expected out of sending this newly created request to the internet.
 @param error in case the creation of this object fails, then error would hold information on the underlying error.

 @return a new request built from the passed node.

 @see [WHLink linkWithNode:fromRequest:target:error:] and [WHForm formWithNode:fromRequest:target:error:] for concrete examples
 @see [GDataXMLNode](http://cocoadocs.org/docsets/GDataXML-HTML/1.3.0/Classes/GDataXMLNode.html)
 @see [GDataXMLDocument](http://cocoadocs.org/docsets/GDataXML-HTML/1.3.0/Classes/GDataXMLDocument.html)
 */
- (instancetype)initWithNode:(GDataXMLNode *)node
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class <WHObject>)target
                       error:(NSError **)error;

/**
 Creates a WHHTTPRequest fragment out of a GDataXMLDocument.

 @param html the html document containing the description of this request
 @param xpath the xpath where to find the GDataXMLNode that will be used to populate this request.
 @param request the request that the GDataXMLDocument originated from.
 @param target the resulting object expected out of sending this newly created request to the internet.
 @param error in case the creation of this object fails, then error would hold information on the underlying error.

 @return a new request built from the passed node.

 @see [WHLink linkWithHTML:atXPath:fromRequest:target:error:] and [WHForm formWithHTML:atXPath:fromRequest:target:error:] for concrete examples
 */
- (instancetype)initWithHTML:(GDataXMLDocument *)html
                     atXPath:(NSString *)xpath
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class <WHObject>)target
                       error:(NSError **)error;

@end

/**
 WHLink extension to allow a developer to create links out of GDataXMLNode or GDataXMLDocument.

 Methods are to be used when parsing an GDataXMLDocument or a GDataXMLNode received from the HTML response, whenever you
 want to parse an existing link (a tag) in the parsed document.

 Consider the following HTML document received from the internet and parsed into a GDataXMLDocument:

    <html>
        <body>
            <a href="/person" title="title / John Doe"><img src="person/johndoe.jpg" alt="alt / John Doe">text / John Doe</a>
        </body>
    </html>

 You could create a WHLink by calling:

    WHLink *link = [WHLink linkWithHTML:html atXPath:@"//a" fromRequest:nil target:[WHPerson class] error:&error];

 */
@interface WHLink (HTML)

/**
 Creates a WHLink fragment out of a GDataXMLDocument.

 @param html the html document containing the description of this request
 @param xpath the xpath where to find the GDataXMLNode that will be used to populate this request.
 @param request the request that the GDataXMLNode originated from.
 @param target the resulting object expected out of sending this newly created request to the internet.
 @param error in case the creation of this object fails, then error would hold information on the underlying error.

 @return a new link request built from the passed node.
 */
+ (instancetype)linkWithHTML:(GDataXMLDocument *)html
                     atXPath:(NSString *)xpath
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class <WHObject>)target
                       error:(NSError **)error;

/**
 Creates a WHLink fragment out of a GDataXMLNode.

 @param node the node containing the description of this request, in HTML
 @param request the request that the GDataXMLDocument originated from.
 @param target the resulting object expected out of sending this newly created request to the internet.
 @param error in case the creation of this object fails, then error would hold information on the underlying error.

 @return a new link request built from the passed node.
 */
+ (instancetype)linkWithNode:(GDataXMLNode *)node
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class <WHObject>)target
                       error:(NSError **)error;

@end

/**
 WHForm extension to allow a developer to create links out of GDataXMLNode or GDataXMLDocument.

 Methods are to be used when parsing an GDataXMLDocument or a GDataXMLNode received from the HTML response, whenever you
 want to parse an existing form (form tag) in the parsed document.

 Consider the following HTML, received in an HTML target and parsed as a GDataXMLDocument:

    <form method="get" action="/person">
        <input type="hidden" name="PHPSESSID" value="a3KZ78u5U56MpOYY7Q0wm6vBV5dWeNEf">
        <div id="userBox">
            <input type="text" name="user" value="John Doe" id="id_user">
            <label for="id_user">User</label>
        </div>
        <div id="passwordBox">
            <input type="password" name="password" value="******" id="id_password">
            <label for="id_password">Password</label>
        </div>
        <input type="checkbox" name="admin" id="id_admin" value="1">
        <label for="id_admin">As admin</label>
        <input type="submit" value="Login" class="button">
    </form>

 You could create a WHForm by calling:

      WHForm *form = [WHForm formWithHTML:html
                                  atXPath:@"//form"
                              fromRequest:nil
                                   target:[WHPerson class]
                                    error:&error];

 Assuming you'd have a WHPerson target conforming to protocol WHObject.

 @see test class WHForm_HTMLSpec to learn about how this is called in place.

 */
@interface WHForm (HTML)

/**
 Creates a WHLink fragment out of a GDataXMLDocument.

 @param html the html document containing the description of this request
 @param xpath the xpath where to find the GDataXMLNode that will be used to populate this request.
 @param request the request that the GDataXMLNode originated from.
 @param target the resulting object expected out of sending this newly created request to the internet.
 @param error in case the creation of this object fails, then error would hold information on the underlying error.

 @return a new form request built from the passed node.
 */
+ (instancetype)formWithHTML:(GDataXMLDocument *)html
                     atXPath:(NSString *)xpath
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class <WHObject>)target
                       error:(NSError **)error;

/**
 Creates a WHForm fragment out of a GDataXMLDocument.

 @param node the html document containing the description of this request
 @param request the request that the GDataXMLNode originated from.
 @param target the resulting object expected out of sending this newly created request to the internet.
 @param error in case the creation of this object fails, then error would hold information on the underlying error.

 @return a new form request built from the passed node.
 */
+ (instancetype)formWithNode:(GDataXMLNode *)node
                 fromRequest:(WHHTTPRequest *)request
                      target:(Class <WHObject>)target
                       error:(NSError **)error;

@end

#endif