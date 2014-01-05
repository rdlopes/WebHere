// NSError+WebHere.m
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

#import "NSError+WebHere.h"

NSString *const WHErrorDomain = @"com.rdlopes.webhere";

@implementation NSError (WebHere)

+ (instancetype)errorWithCode:(WHErrorCode)errorCode
{
    NSError *error = [NSError errorWithDomain:WHErrorDomain
                                         code:errorCode
                                     userInfo:[NSError userInfoForCode:errorCode]];
    return error;
}

+ (NSDictionary *)userInfoForCode:(WHErrorCode)errorCode
{
    NSDictionary *userInfo = nil;
    switch (errorCode) {
        case WHErrorNoMatchingClassFoundForMapping:
            userInfo = @{NSLocalizedDescriptionKey: @"No target class matches HTML page",
                         NSLocalizedFailureReasonErrorKey:@"Target classes listed by WHWebRequest "
                         "have all been tested by calling [WHObject matches:fromRequest:] "
                         "but none returned a positive match, so mapping failed",
                         NSLocalizedRecoverySuggestionErrorKey:@"Try reviewing your WHObject classes "
                         "and make sure their matching filter is correctly set"
                         };
            break;
            
        default:
            break;
    }
    return userInfo;
}

@end
