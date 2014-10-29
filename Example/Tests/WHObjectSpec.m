//
// WHObjectSpec.m
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

#import "WebHereTests.h"

SpecBegin(WHObject)

        describe(@"WHObject", ^{
            __block NSError *error = nil;
            __block GDataXMLDocument *personDocument = nil;

            beforeEach(^{
                personDocument = [[GDataXMLDocument alloc] initWithHTMLString:PERSON_HTML error:&error];
            });

            afterEach(^{
                personDocument = nil;
            });

            describe(@"A person", ^{
                __block WHPerson *person = nil;

                beforeEach(^{
                    person = [[WHPerson alloc] init];
                });

                afterEach(^{
                    person = nil;
                });

                it(@"matches its HTML string", ^{
                    expect([WHPerson matches:personDocument fromRequest:nil]).to.beTruthy();
                });

                it(@"can be read from HTML string", ^{
                    [person buildFromHTML:personDocument fromRequest:nil error:&error];
                    expect(person.fullName).to.equal(@"John Doe");
                    expect(person.age).to.equal(@25);
                    expect(person.city).to.equal(@"Paris");
                    expect(person.country).to.equal(@"France");
                });

                describe(@"An unmatchable person", ^{
                    it(@"Does not match its HTML string", ^{
                        expect([WHUnmatchedPerson matches:personDocument fromRequest:nil]).to.beFalsy();
                    });
                });
            });


            describe(@"An admin", ^{
                __block GDataXMLDocument *adminDocument = nil;
                __block WHAdmin *admin = nil;

                beforeEach(^{
                    adminDocument = [[GDataXMLDocument alloc] initWithHTMLString:ADMIN_HTML error:&error];
                    admin = [[WHAdmin alloc] init];
                });

                afterEach(^{
                    adminDocument = nil;
                    admin = nil;
                });

                it(@"matches its HTML string", ^{
                    expect([WHAdmin matches:adminDocument fromRequest:nil]).to.beTruthy();
                });

                it(@"can be read from HTML string", ^{
                    [admin buildFromHTML:adminDocument fromRequest:nil error:&error];
                    expect(admin.fullName).to.equal(@"John Doe");
                    expect(admin.age).to.equal(@25);
                    expect(admin.city).to.equal(@"Paris");
                    expect(admin.country).to.equal(@"France");
                    expect(admin.nickname).to.equal(@"The Administrator");
                    expect(admin.rights).to.equal(WHAdminRightsWriteOnly);
                });

            });

        });

SpecEnd
