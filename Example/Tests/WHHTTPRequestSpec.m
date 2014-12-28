//
// WHRequestSpec.m
// WebHere
//
// Created by Rui Lopes on 06/10/2014.
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
//

#import "WHPerson.h"
#import "WHLoginForm.h"

SpecBegin(WHHTTPRequest)

    setAsyncSpecTimeout(2);

    describe(@"WHHTTPRequest", ^{
            __block WHHTTPRequest *request;

            beforeEach(^{
                request =
                        [WHHTTPRequest requestWithPath:@"/" target:[WHPerson class]];
            });

            afterEach(^{
                request = nil;
            });

            describe(@"Initialization", ^{

                it(@"succeeds with simple parameters", ^{
                    expect(request).notTo.beNil;
                    expect(request.HTTPMethod).to.equal(@"GET");
                    expect(request.path).to.equal(@"/");
                    expect(request.targetClass).to.equal([WHPerson class]);
                    expect(request.queryParameters).notTo.beNil;
                    expect(request.queryParameters).to.haveCountOf(0);
                    expect(request.userInfo).notTo.beNil;
                });

                it(@"succeeds when query parameters are provided", ^{
                    request.queryParameters[@"name1"] = @"value1";
                    request.queryParameters[@"name2"] = @"value2";

                    expect(request.queryParameters.allKeys)
                            .to.containAll((@[@"name1", @"name2"]));
                    expect(request.queryParameters.allValues)
                            .to.containAll((@[@"value1", @"value2"]));
                });

                it(@"succeeds when user content is provided", ^{
                    request.userInfo[@"userKey1"] = @"userValue1";
                    request.userInfo[@"userKey2"] = @"userValue2";

                    expect(request.userInfo.allKeys)
                            .to.containAll((@[@"userKey1", @"userKey2"]));
                    expect(request.userInfo.allValues)
                            .to.containAll((@[@"userValue1", @"userValue2"]));
                });

                it(@"fails without path", ^{
                    expect(
                            ^{
                                [WHHTTPRequest requestWithPath:nil target:[WHPerson class]];
                            }).to.raise(@"NSInternalInconsistencyException");
                });

                it(@"fails without target class", ^{
                    expect(^{
                        [WHHTTPRequest requestWithPath:@"/" target:nil];
                    })
                            .to.raise(@"NSInternalInconsistencyException");
                });

            });
        });

        describe(@"WHLink", ^{
            __block WHLink *link;

            beforeEach(^{
                link = [WHLink linkWithPath:@"/person" target:[WHPerson class]];
                link.label = @"Person";
                link.imagePath = @"/person.jpg";
            });

            afterEach(^{
                link = nil;
            });

            describe(@"Initialization", ^{

                it(@"initializes", ^{
                    expect(link).notTo.beNil;
                    expect(link.label).to.equal(@"Person");
                    expect(link.imagePath).to.equal(@"/person.jpg");
                });

            });
        });

        describe(@"WHForm", ^{

            describe(@"Initialization", ^{
                __block WHForm *form;

                beforeEach(
                        ^{
                            form = [WHForm formWithPath:@"/" target:[WHPerson class]];
                        });

                afterEach(^{
                    form = nil;
                });

                it(@"initializes", ^{
                    expect(form).notTo.beNil;
                    expect(form.HTTPMethod).to.equal(@"POST");
                });
            });

            describe(@"Runtime", ^{
                __block WHLoginForm *form;

                beforeEach(^{
                    form = [WHLoginForm formWithPath:@"/" target:[WHPerson class]];
                    form.user = @"me";
                    form.password = @"secret";
                });

                afterEach(^{
                    form = nil;
                });

                it(@"extracts query parameters from properties", ^{
                    expect(form).notTo.beNil;
                    expect(form.user).to.equal(@"me");
                    expect(form.password).to.equal(@"secret");
                    expect(form.queryParameters).notTo.beNil;
                    expect(form.queryParameters).to.haveCountOf(2);
                    expect(form.queryParameters.allKeys)
                            .to.containAll((@[@"user", @"password"]));
                    expect(form.queryParameters.allValues)
                            .to.containAll((@[@"me", @"secret"]));
                });
            });

        });

SpecEnd
