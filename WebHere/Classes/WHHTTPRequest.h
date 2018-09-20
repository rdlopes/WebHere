//
// WHHTTPRequest.h
// WebHere
//
// Created by Rui Lopes on 13/10/2014.
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

#ifndef WHHTTPRequest_h
#define WHHTTPRequest_h

#import <Foundation/Foundation.h>

#import "WHObject.h"

/**
 WHHTTPRequest provides a base class for describing a request that can be sent to the internet.

 ## Subclassing notes

 It is rarely used as is, rather you would create a WHLink describing a link (the *a* tag in HTML) of a WHForm
 (the *form* tag) that would hold the properties for an HTTP request.

 For instance, consider Google's web site. Imagine you're interested in scraping the search page (not the query results,
 just the first page), you would create a link of the form:

    WHWebsite *googleWebsite = [WHWebsite websiteWithBaseURL:[NSURL URLWithString:@"http://www.google.com/"]];
    WHLink *googleFrontPageRequest = [WHLink linkWithPath:@"" target:[MyFrontPage class]];

 That googleFrontPageRequest could then be requested against the googleWebsite to retrieve the front page in the form of
 a MyFrontPage object, given that you would have described how to parse the HTML returned and populate the requiring properties
 from the front page into the MyFrontPage object.

 Another case would be to send a request to Google with query parameters and expecting search results. Then you would
 use a WHForm to hold request parameters and send it against the googleWebsite, as follow:

    WHForm *googleSearchRequest = [WHForm formWithPath:@"/search" target:[MySearchResultsPage class]];

 This in terms would allow you to send a request to Google by adding query parameters to the form, like so:

    googleSearchRequest.queryParameters[@"q"] = @"cute little puppies";

 By sending this request, you would receive a MySearchResultsPage object as a result containing the information you would
 want to receive, as defined by the mapping you would provide in MySearchResultsPage.

 @see WHObject on the definition of mappings and HTML parsing.
 */
@interface WHHTTPRequest : NSObject

/**
 The HTTP method to use for the request (GET, POST, PUT, DELETE, etc.)
 */
@property(nonatomic, strong) NSString *HTTPMethod;

/**
 The path to request. Since the WHWebsite holds a baseURL, this path is the path starting from the baseURL.
 */
@property(nonatomic, strong) NSString *path;

/**
 The query parameters, if applicable to this type of request
 */
@property(nonatomic, readonly) NSMutableDictionary *queryParameters;

/**
 In case of multiple possible targets (if request is redirected or request fails, some websites can send a different payload
 back to us.
 */
@property(nonatomic, readonly) NSMutableArray *alternativeTargets;

/**
 User info is a convenient data holder where you could put anything you want. For instance, you could store a tag or
 even information about how you should parse the HTML, because this user info is available to you when you are parsing the HTML.
 */
@property(nonatomic, readonly) NSMutableDictionary *userInfo;

/**
 The target class tells WebHere what is the target object to create whenever it receives an HTML content
 */
@property(nonatomic, assign) Class <WHObject> targetClass;

/**
 In case of failure, you can set this value so that WebHere will retry to send the request to the web.
 Please use with caution, you don't want to spam the website or build an infinite loop.
 */
@property(assign) NSInteger retryCount;

/**
 Creates a request.

 @param path the path to be requested. Since the WHWebsite holds a baseURL, this path should be starting from the baseURL.
 @param target the target WHObject subclass to be created whenever this requests succeeds and received an HTML document back.
 */
+ (instancetype)requestWithPath:(NSString *)path target:(Class <WHObject>)target;

/**
 Creates a request.

 @param path the path to be requested. Since the WHWebsite holds a baseURL, this path should be starting from the baseURL.
 @param target the target WHObject subclass to be created whenever this requests succeeds and received an HTML document back.
 */
- (instancetype)initWithPath:(NSString *)path target:(Class <WHObject>)target;

@end

/**
 WHLink represents an *a* tag, which is an HTTP request in the form of a GET/POST method
 */
@interface WHLink : WHHTTPRequest

/**
 the text label contained in this *a* tag
 */
@property(nonatomic, strong) NSString *label;

/**
 the image contained in this *a* tag, if applicable
 */
@property(nonatomic, strong) NSString *imagePath;

/**
 Creates a link.

 @param path the path to be requested. Since the WHWebsite holds a baseURL, this path should be starting from the baseURL.
 @param target the target WHObject subclass to be created whenever this requests succeeds and received an HTML document back.
 */
+ (instancetype)linkWithPath:(NSString *)path target:(Class <WHObject>)target;

@end

/**
 WHForm represents a *form* tag, which is an HTTP request in the form of a GET/POST method
 */
@interface WHForm : WHHTTPRequest

/**
 Creates a form.

 @param path the path to be requested. Since the WHWebsite holds a baseURL, this path should be starting from the baseURL.
 @param target the target WHObject subclass to be created whenever this requests succeeds and received an HTML document back.
 */
+ (instancetype)formWithPath:(NSString *)path target:(Class <WHObject>)target;

@end

#endif