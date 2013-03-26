// WHRequestSpec.m
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

#import "WebHereTests.h"

SPEC_BEGIN(WHRequestSpec)

#pragma mark - Initialization
describe(@"Initialization", ^{
    __block WHRequest *request;
    
    beforeEach(^{
        request = [WHRequest requestWithPath:@"/" target:[WHPerson class]];
    });
    
    afterEach(^{
        request = nil;
    });
    
    context(@"succeeds", ^{
        it(@"with simple parameters", ^{
            [request shouldNotBeNil];
            [[request.HTTPMethod should] equal:@"GET"];
            [[request.path should] equal:@"/"];
            [[theValue(request.targetClass) should] equal:theValue([WHPerson class])];
            [request.queryParameters shouldNotBeNil];
            [request.alternativeTargetClasses shouldNotBeNil];
            [request.userInfo shouldNotBeNil];
            [[request.queryParameters should] haveCountOf:0];
            [[request.alternativeTargetClasses should] haveCountOf:0];
            [[request.userInfo should] haveCountOf:0];
        });
        
        it(@"when query parameters are provided", ^{
            request.queryParameters[@"name1"] = @"value1";
            request.queryParameters[@"name2"] = @"value2";
            [[[request.queryParameters allKeys] should] containObjectsInArray:@[@"name1",@"name2"]];
            [[[request.queryParameters allValues] should] containObjectsInArray:@[@"value1",@"value2"]];
        });
        
        it(@"when alternative targets are provided", ^{
            request.alternativeTargetClasses[0] = [WHNSObject class];
            request.alternativeTargetClasses[1] = [WHNSObjectSubclassed class];
            [[request.alternativeTargetClasses should] containObjectsInArray:@[[WHNSObject class],[WHNSObjectSubclassed class]]];
        });
        
        it(@"when user content is provided", ^{
            request.userInfo[@"userKey1"] = @"userValue1";
            request.userInfo[@"userKey2"] = @"userValue2";
            [[[request.userInfo allKeys] should] containObjectsInArray:@[@"userKey1",@"userKey2"]];
            [[[request.userInfo allValues] should] containObjectsInArray:@[@"userValue1",@"userValue2"]];
        });
    });
    
    context(@"fails", ^{
        it(@"without path", ^{
            [[theBlock(^{
                [WHRequest requestWithPath:nil target:[WHPerson class]];
            }) should] raiseWithName:@"NSInternalInconsistencyException"];
        });
        
        it(@"without target class", ^{
            [[theBlock(^{
                [WHRequest requestWithPath:@"/" target:nil];
            }) should] raiseWithName:@"NSInternalInconsistencyException"];
        });
    });
});

SPEC_END


