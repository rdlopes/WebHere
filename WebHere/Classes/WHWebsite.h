//
// WHWebsite.h
// WebHere
//  
// Created by Rui Lopes on 13/10/2014.
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

#ifndef WHWebsite_h
#define WHWebsite_h

#import <Foundation/Foundation.h>
#import "WHHTTPRequest.h"

FOUNDATION_EXPORT NSTimeInterval const kWHWebsiteDefaultTimeInterval;
FOUNDATION_EXPORT NSInteger const kWHWebsiteDefaultNumberOfRetries;

@protocol WHObject;

/**
 WHWebsite describes a website to be scraped.
 Internally, it hides the AFNetworking methods for dealing with HTTP requests.

 The example provided with WebHere is the one of a search request to Google.

 The website would be declared as

    WHWebsite *googleWebsite = [WHWebsite websiteWithBaseURL:[NSURL URLWithString:@"http://www.google.com/"]];

 In order to send requests to Google and receive search results, you would have to:

 1. Define a WHObject that would be the target object of your request, holding the information you're interested with.
 2. Create a subclass of WHHTTPRequest that would hold the parameters of your request. In our case, you would need a WHForm to hold the query parameters.
 3. Implement the HTML parsing inside your subclass of WHObject to be able to inject the HTML parts received from Google into the WHObject subclass
 4. Perform the request and use the WHObject like any other object in Objective-C.

 According to the example, we have defined a WHObject to hold the search results, namely WHSearchResponse, that implements
 WHObject protocol, searching through the results page of Google to build the WHSearchResponse object:

     - (void)buildFromHTML:(GDataXMLDocument *)html fromRequest:(WHHTTPRequest *)request error:(NSError **)error {
        NSArray *webResults = [html nodesForXPath:@"//div[@id='ires']//div[@class='g']" error:error];

        for (GDataXMLNode *webResultNode in webResults) {

            GDataXMLNode *linkNode = [webResultNode firstNodeForXPath:@".//h3/a" error:error];
            GDataXMLNode *detailsNode = [webResultNode firstNodeForXPath:@".//div[@class='s']/span" error:error];


            WHSearchResult *searchResult = [[WHSearchResult alloc] initWithNode:linkNode
                                                                    fromRequest:request
                                                                          error:error];

            searchResult.details = [detailsNode.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

            [self.searchResults addObject:searchResult];
        }
    }

 If we follow along with the example provided, we have defined a WHSearchRequest that subclasses a WHForm and holds the query parameter "q"
 because Google asks for requests of the form http://www.google.com/search?q=<query>, so we could have a query like

    WHSearchRequest *googleSearchRequest = [WHSearchRequest formWithPath:@"/search" target:[MySearchResultsPage class]];
    googleSearchRequest.queryParameters[@"q"] = @"cute little puppies";

 You would then send the request to Google:

        [googleWebsite send:googleSearchRequest
                     success:^(WHHTTPRequest *request, id <WHObject> responseObject) {
                         NSLog(@"Received a response from Google: %@", [responseObject fullDescription]);
                     }
                     failure:^(WHHTTPRequest *request, NSError *error) {
                         NSLog(@"Requesting Google raised an error: %@", error);
                     }];

 */
@interface WHWebsite : NSObject

/**
 The base URL for this website, often of the form http(s)://www.example.com
 */
@property(nonatomic, readonly) NSURL *baseURL;

/**
 The requests encoding, by default NSUTF8StringEncoding
 */
@property(nonatomic, assign) NSStringEncoding requestEncoding;

/**
 The timeout authorized for this website requests.
 */
@property(nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 The number of retries whenever an error occurs in the requests.
 */
@property(nonatomic, assign) NSInteger numberOfRetries;

/**
 Creates a new WHWebsite.

 @param baseURL the base URL for this website
 */
- (instancetype)initWithBaseURL:(NSURL *)baseURL;

/**
 Creates a new WHWebsite.

 @param baseURL the base URL for this website
 @param configuration a NSURLSessionConfiguration as used by AFNetworking
 */
- (instancetype)initWithBaseURL:(NSURL *)baseURL sessionConfiguration:(NSURLSessionConfiguration *)configuration;

/**
 Creates a new WHWebsite.

 @param baseURL the base URL for this website
 */
+ (instancetype)websiteWithBaseURL:(NSURL *)baseURL;

/**
 Creates a new WHWebsite.

 @param baseURL the base URL for this website
 @param configuration a NSURLSessionConfiguration as used by AFNetworking
 */
+ (instancetype)websiteWithBaseURL:(NSURL *)baseURL sessionConfiguration:(NSURLSessionConfiguration *)configuration;

/**
 Some websites request authentication via user/password

 @param username the username to use
 @param password the password to authenticate with
 */
- (void)setAuthorizationUserName:(NSString *)username password:(NSString *)password;

/**
 Send a WHHTTPRequest to the website and waits for either a payload that will be transformed into the subclass of WHObject
 set in the request, or an error with the reason of the failure.

 If the website has set a numberOfRetries or the request has set a retryCount, it will first retry the corresponding number of times
 before failing.

 @param request the request to send
 @param success the success callback, in case an HTML document has been received
 @param failure the failure callback, in case something wrong happened during the call to the website.
 */
- (void)send:(WHHTTPRequest *)request
     success:(void (^)(WHHTTPRequest *request, id <WHObject> responseObject))success
     failure:(void (^)(WHHTTPRequest *request, NSError *error))failure;

@end

#endif