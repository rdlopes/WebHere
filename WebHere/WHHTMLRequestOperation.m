// WHHTMLRequestOperation.m
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

#import "WHHTMLRequestOperation.h"

static dispatch_queue_t os_html_request_operation_processing_queue;

static dispatch_queue_t html_request_operation_processing_queue() {
    if (os_html_request_operation_processing_queue == NULL) {
        os_html_request_operation_processing_queue = dispatch_queue_create("com.rdlopes.objective-scrap.html-request.processing", 0);
    }
    
    return os_html_request_operation_processing_queue;
}

@interface WHHTMLRequestOperation ()

@property(readwrite, nonatomic, strong) HTMLDocument *responseHTMLPage;
@property(readwrite, nonatomic, strong) NSError *HTMLError;

@end

@implementation WHHTMLRequestOperation

+ (instancetype)HTMLRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, HTMLDocument *page))success
                                        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, HTMLDocument *page))failure {
    
    WHHTMLRequestOperation *requestOperation = [(WHHTMLRequestOperation *) [self alloc] initWithRequest:urlRequest];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject);
        }
    }                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error, [(WHHTMLRequestOperation *) operation responseHTMLPage]);
        }
    }];
    
    return requestOperation;
}

- (HTMLDocument *)responseHTMLPage {
    if (!_responseHTMLPage && [self.responseData length] > 0 && [self isFinished]) {
        NSError *error = nil;
        self.responseHTMLPage = [[HTMLDocument alloc] initWithData:self.responseData error:&error];
        self.HTMLError = error;
    }
    
    return _responseHTMLPage;
}

- (NSError *)error {
    if (_HTMLError) {
        return _HTMLError;
    } else {
        return [super error];
    }
}

#pragma mark - AFHTTPRequestOperation

+ (NSSet *)acceptableContentTypes {
    return [NSSet setWithObjects:
            @"text/html",
            @"text/xml",
            @"text/plain",
            @"application/xhtml+xml",
            @"xml",
            nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    BOOL canProcessRequest = ![request valueForHTTPHeaderField:@"Accept"]
    || [[self acceptableContentTypes] containsObject:[request valueForHTTPHeaderField:@"Accept"]];
    return canProcessRequest;
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    self.completionBlock = ^{
        dispatch_async(html_request_operation_processing_queue(), ^(void) {
            HTMLDocument *HTMLPage = self.responseHTMLPage;
            
            if (self.error) {
                if (failure) {
                    dispatch_async(self.failureCallbackQueue ? : dispatch_get_main_queue(), ^{
                        failure(self, self.error);
                    });
                }
            } else {
                if (success) {
                    dispatch_async(self.successCallbackQueue ? : dispatch_get_main_queue(), ^{
                        success(self, HTMLPage);
                    });
                }
            }
        });
    };
#pragma clang diagnostic pop
}

@end
