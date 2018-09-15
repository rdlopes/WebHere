//
// WHWebsite.m
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

#import "WHHTTPRequest+Internal.h"
#import "AFURLResponseSerialization.h"
#import "WHHTMLResponseSerializer.h"
#import "NSObject+Runtime.h"
#import "WHWebsite.h"
#import "AFHTTPSessionManager.h"
#import "GDataXMLNode.h"

@class AFHTTPSessionManager;

NSTimeInterval const kWHWebsiteDefaultTimeInterval = 2;
NSInteger const kWHWebsiteDefaultNumberOfRetries = 1;

NSString *const WHWebsiteErrorDomain = @"com.ruilopes.error.website";
NSInteger const WHWebsiteObjectBuildingFailureErrorCode = -3000;

@interface WHWebsite ()

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation WHWebsite

#pragma mark - Properties

- (NSURL *)baseURL {
    return _sessionManager.baseURL;
}

- (NSStringEncoding)requestEncoding {
    return _sessionManager.requestSerializer.stringEncoding;
}

- (void)setRequestEncoding:(NSStringEncoding)requestEncoding {
    _sessionManager.requestSerializer.stringEncoding = requestEncoding;
}

- (NSTimeInterval)timeoutInterval {
    return _sessionManager.requestSerializer.timeoutInterval;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    _sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
}

#pragma mark - Initializers

- (instancetype)initWithBaseURL:(NSURL *)baseURL
           sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.sessionManager =
                [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL
                                         sessionConfiguration:configuration];

        // FIXME - As of XCode 6, it's the only way to deal with security with
        // AFNetworking
        AFSecurityPolicy *securityPolicy =
                [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        self.sessionManager.securityPolicy = securityPolicy;
        // FIXME

        self.sessionManager.responseSerializer =
                [WHHTMLResponseSerializer serializer];
        self.sessionManager.requestSerializer.timeoutInterval =
                kWHWebsiteDefaultTimeInterval;
        self.numberOfRetries = kWHWebsiteDefaultNumberOfRetries;

        if (self.sessionManager == nil) {
            self = nil;
        }
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL {
    return [self initWithBaseURL:baseURL sessionConfiguration:nil];
}

+ (instancetype)websiteWithBaseURL:(NSURL *)baseURL
              sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    return
            [[self alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
}

+ (instancetype)websiteWithBaseURL:(NSURL *)baseURL {
    return [self websiteWithBaseURL:baseURL sessionConfiguration:nil];
}

#pragma mark - Methods

- (void)setAuthorizationUserName:(NSString *)username
                        password:(NSString *)password {
    [_sessionManager.requestSerializer clearAuthorizationHeader];
    [_sessionManager.requestSerializer
            setAuthorizationHeaderFieldWithUsername:username
                                           password:password];
}

- (void)send:(WHHTTPRequest *)request
     success:(void (^)(WHHTTPRequest *sentRequestOnSuccess,
             id <WHObject> responseObject))success
     failure:(void (^)(WHHTTPRequest *sentRequestOnError, NSError *error))failure {

    NSError *serializationError = nil;
    NSDictionary *queryParameters =
            request.queryParameters.count ? request.queryParameters : nil;
    self.sessionManager.requestSerializer.stringEncoding = request.encoding;

    NSMutableURLRequest *mutableURLRequest =
            [self.sessionManager.requestSerializer
                    requestWithMethod:request.HTTPMethod
                            URLString:[[NSURL URLWithString:request.path
                                              relativeToURL:self.baseURL] absoluteString]
                           parameters:queryParameters
                                error:&serializationError];
    if (serializationError) {
        if (failure) {
            dispatch_async(_sessionManager.completionQueue
                                   ?: dispatch_get_main_queue(),
                           ^{
                               failure(request, serializationError);
                           });
        }
        return;
    }

    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_sessionManager
            dataTaskWithRequest:mutableURLRequest
              completionHandler:^(NSURLResponse *response, id responseObject,
                      NSError *error) {
                  if (error) {
                      if (request.retryCount < self.numberOfRetries) {
                          // Resend
                          request.retryCount = request.retryCount + 1;
                          [self send:request success:success failure:failure];
                      } else {
                          // Report the error
                          if (failure) {
                              failure(request, error);
                          }
                      }
                  } else {
                      if (success) {
                          NSError *objectBuildingError = nil;
                          id <WHObject> object = nil;

                          // List the possible classes to be mapped through the HTML document, by
                          // priority order, starting with the target object class
                          NSMutableArray *possibleClasses = [@[] mutableCopy];
                          [possibleClasses addObject:request.targetClass];
                          [possibleClasses addObjectsFromArray:request.alternativeTargets];

                          // while we don't meet any mapping error and there are still possible classes
                          // left, go on
                          while (possibleClasses.count > 0 && objectBuildingError == nil &&
                                  object == nil) {
                              Class <WHObject> targetClass = possibleClasses.firstObject;
                              [possibleClasses removeObjectAtIndex:0];

                              // Build object from HTML page
                              BOOL canBuild =
                                      [(id) targetClass respondsToSelector:@selector(matches:fromRequest:)]
                                              ? [targetClass matches:responseObject fromRequest:request]
                                              : YES;
                              if (canBuild) {
                                  object = (id <WHObject>) [[(Class) targetClass alloc] init];
                                  [object buildFromHTML:responseObject
                                            fromRequest:request
                                                  error:&objectBuildingError];
                              }
                          }

                          if (object && objectBuildingError == nil) {
                              request.retryCount = 0;
                              success(request, object);
                          } else if (failure) {
                              NSLog(@"Failure from HTML %@",
                                    ((GDataXMLDocument *) responseObject).rootElement.XMLString);
                              NSDictionary *userInfo = @{
                                      NSLocalizedFailureReasonErrorKey : @"Object cannot be built"
                              };
                              objectBuildingError =
                                      [[NSError alloc] initWithDomain:WHWebsiteErrorDomain
                                                                 code:WHWebsiteObjectBuildingFailureErrorCode
                                                             userInfo:userInfo];
                              failure(request, objectBuildingError);
                          }
                      }
                  }
              }];

    request.dataTask = dataTask;
    [dataTask resume];
    return;
}

@end
