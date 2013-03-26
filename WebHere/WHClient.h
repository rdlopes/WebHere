// WHClient.h
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

#import <Foundation/Foundation.h>
#import "HTMLDocument.h"
#import "WHRequest.h"
#import "WHObject.h"

FOUNDATION_EXPORT NSTimeInterval const kWHClientDefaultTimeoutInterval;
FOUNDATION_EXPORT NSInteger const kWHClientDefaultNumberOfRetries;

typedef void (^WHLoadSuccessfulBlock)(WHRequest *const request, id<WHObject> object);
typedef void (^WHLoadFailureBlock)(WHRequest *const request, NSError *const error);

@interface WHClient : NSObject

///---------------------------------------------
/// @name Accessing Client Properties
///---------------------------------------------

/**
 The url used as the base for network paths
 */
@property (nonatomic, readonly) NSURL *baseURL;

/**
 Time out expressed in seconds for a network request. Default value is given by kWHClientDefaultTimeoutInterval.
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
 Number of retries for a network request. Default value is given by kWHClientDefaultNumberOfRetries.
 
 @warning Please notice that this is only applied to network requests, not application logic.
 */
@property (nonatomic, assign) NSInteger numberOfRetries;


///---------------------------------------------
/// @name Creating and Initializing Clients
///---------------------------------------------

/** Returns the shared instance, if any. By default, this shared instance corresponds to an object initialized by calling [WHClient initWithBaseURL:] whenever the shared instance is `nil`. You can set this shared instance explicitely by calling [WHClient setSharedClient:].
 
 @return the first instance of this class that has been initialized, and not yet nil'd. It can act as the singleton for this class and be accessed in other parts of your code without dealing with passing objects along.
 */
+ (instancetype)sharedClient;

/** Sets the shared instance.
 
 @param client the client that will be accessed by a call to [WHClient sharedClient].
 
 @warning calling this method does nothing but setting the shared instance. If there are pending requests sent to the former shared instance, they'll still be active. Consider cleaning.
 */
+ (void)setSharedClient:(WHClient *)client;

/** Class factory. Calls [WHClient initWithBaseURL:]
 
 @param baseURL the base URL for network paths
 @return a newly created and initialized instance
 */
+ (instancetype)clientWithBaseURL:(NSURL *)baseURL;

/** Declared initializer. It's up to the caller to control that the URL is valid.
 
 @param baseURL the base URL for the targetted website
 @return a newly created and initialized instance
 */
- (instancetype)initWithBaseURL:(NSURL *)baseURL;

///---------------------------------------------
/// @name Dealing With Credentials
///---------------------------------------------

- (void)setAuthorizationUserName:(NSString *)username password:(NSString *)password; // not tested
- (void)setAuthorizationToken:(NSString *)token; // not tested

///---------------------------------------------
/// @name Issuing Network Requests
///---------------------------------------------

/** Issues a HTTP request to the website. The resulting HTTP request issued will depend on the HTTP method declared by the request, as described by AFNetworking API
 
 - if the method used is GET, the query parameters will be passed as a query string along with the resource path (the URL requested)
 - if the method is POST, then the query parameters will be encoded in the body of the HTTP request.
 
 @param request the WHRequest to be issued
 @param success block that will be called upon successfull loading of the resource targetted by the request from the website.
 @param failure block that will be called upon failed loading of the resource targetted by the request from the website.
 */
- (void)send:(WHRequest *)request success:(WHLoadSuccessfulBlock)success failure:(WHLoadFailureBlock)failure;

@end
