//
// WHWebsiteSpec.m
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

#import "WHPerson+HTML.h"
#import "WHPersonQueryForm.h"

SpecBegin(WHWebsite)
    setAsyncSpecTimeout(100);

    NSURL *baseURL = [NSURL URLWithString:@"http://localhost"];

    describe(@"WHWebsite", ^{
        __block WHWebsite *website;

        context(@"Initialization", ^{
            it(@"creates default properties", ^{
                website = [WHWebsite websiteWithBaseURL:baseURL];
                expect(website).toNot.beNil();
                expect(website.baseURL).to.equal(baseURL);
                expect(website.numberOfRetries).to.equal(kWHWebsiteDefaultNumberOfRetries);
                expect(website.timeoutInterval).to.equal(kWHWebsiteDefaultTimeInterval);
                expect(website.requestEncoding).to.equal(NSUTF8StringEncoding);
            });
        });

        context(@"Requests", ^{

            beforeEach(^{
                website = [WHWebsite websiteWithBaseURL:baseURL];
            });
            beforeAll(^{
                [[LSNocilla sharedInstance] start];
            });
            afterAll(^{
                [[LSNocilla sharedInstance] stop];
            });
            afterEach(^{
                [[LSNocilla sharedInstance] clearStubs];
                website = nil;
            });

            it(@"won't map unnmatching targets", ^{
                NSLog(@"HTML parsed: %@", PERSON_HTML);

                stubRequest(@"GET", @"http://localhost/person")
                        .andReturn(200)
                        .withBody(PERSON_HTML);

                WHLink *personLink = [WHLink linkWithPath:@"/person" target:[WHUnmatchedPerson class]];
                __block WHUnmatchedPerson *person = nil;

                [website send:personLink
                      success:^(WHHTTPRequest *request, id <WHObject> object) {
                          person = (WHUnmatchedPerson *) object;
                      }
                      failure:^(WHHTTPRequest *request, NSError *error) {
                          person = nil;
                      }];

                expect(person).will.beNil();
            });

            it(@"retries on error", ^{
                stubRequest(@"GET", @"http://localhost/person")
                        .andReturn(404)
                        .withBody(nil);

                WHLink *personLink = [WHLink linkWithPath:@"/person" target:[WHPerson class]];
                __block WHPerson *person = [WHPerson new];

                [website send:personLink
                      success:^(WHHTTPRequest *request, id <WHObject> object) {
                          person = (WHPerson *) object;
                      }
                      failure:^(WHHTTPRequest *request, NSError *error) {
                          person = nil;
                      }];

                expect(person).will.beNil();
                expect(personLink.retryCount).will.equal(kWHWebsiteDefaultNumberOfRetries);

            });

            it(@"creates target objects", ^{
                NSLog(@"HTML parsed: %@", PERSON_HTML);
                stubRequest(@"GET", @"http://localhost/person")
                        .andReturn(200)
                        .withBody(PERSON_HTML);

                WHLink *personLink = [WHLink linkWithPath:@"/person" target:[WHPerson class]];
                __block WHPerson *person = nil;

                [website send:personLink success:^(WHHTTPRequest *request, id <WHObject> responseObject) {
                    person = (WHPerson *) responseObject;
                }     failure:^(WHHTTPRequest *request, NSError *error) {
                    person = nil;
                }];
                expect(person).willNot.beNil();
                expect(person.fullName).will.equal(@"John Doe");
                expect(person.age).will.equal(@25);
                expect(person.city).will.equal(@"Paris");
                expect(person.country).will.equal(@"France");
            });

            it(@"handles basic authentication", ^{
                NSLog(@"HTML parsed: %@", PERSON_HTML);
                stubRequest(@"GET", @"http://localhost/person")
                        .withHeader(@"Authorization", @"Basic dXNlcjA6cGFzc3cwcmQ=")
                        .andReturn(200)
                        .withBody(PERSON_HTML);
                WHLink *personLink = [WHLink linkWithPath:@"/person" target:[WHPerson class]];
                __block  WHPerson *person = nil;

                [website setAuthorizationUserName:@"user0" password:@"passw0rd"];
                [website send:personLink success:^(WHHTTPRequest *request, id <WHObject> responseObject) {
                    person = (WHPerson *) responseObject;
                }     failure:^(WHHTTPRequest *request, NSError *error) {
                    person = nil;
                }];

                expect(person).willNot.beNil();
                expect(person.fullName).will.equal(@"John Doe");
                expect(person.age).will.equal(@25);
                expect(person.city).will.equal(@"Paris");
                expect(person.country).will.equal(@"France");
            });

            it(@"handles explicit query parameters", ^{
                NSLog(@"HTML parsed: %@", PERSON_HTML);
                stubRequest(@"POST", @"http://localhost/person/query")
                        .withBody(@"fullName=John%20Doe")
                        .andReturn(200)
                        .withBody(PERSON_HTML);

                WHForm *personQueryForm = [WHForm formWithPath:@"/person/query" target:[WHPerson class]];
                personQueryForm.queryParameters[@"fullName"] = @"John Doe";
                __block WHPerson *person = nil;

                [website send:personQueryForm
                      success:^(WHHTTPRequest *request, id <WHObject> object) {
                          person = (WHPerson *) object;
                      }
                      failure:^(WHHTTPRequest *request, NSError *error) {
                          person = nil;
                      }];
                expect(person).willNot.beNil();
                expect(person.fullName).will.equal(@"John Doe");
                expect(person.age).will.equal(@25);
                expect(person.city).will.equal(@"Paris");
                expect(person.country).will.equal(@"France");
            });

            it(@"handles query parameters as form properties", ^{
                NSLog(@"HTML parsed: %@", PERSON_HTML);
                stubRequest(@"POST", @"http://localhost/person/query")
                        .withBody(@"fullName=John%20Doe")
                        .andReturn(200)
                        .withBody(PERSON_HTML);

                WHPersonQueryForm *personQueryForm = [WHPersonQueryForm formWithPath:@"/person/query"
                                                                              target:[WHPerson class]];
                personQueryForm.fullName = @"John Doe";
                __block WHPerson *person = nil;


                [website send:personQueryForm
                      success:^(WHHTTPRequest *request, id <WHObject> object) {
                          person = (WHPerson *) object;
                      }
                      failure:^(WHHTTPRequest *request, NSError *error) {
                          person = nil;
                      }];
                expect(person).willNot.beNil();
                expect(person.fullName).will.equal(@"John Doe");
                expect(person.age).will.equal(@25);
                expect(person.city).will.equal(@"Paris");
                expect(person.country).will.equal(@"France");
            });

            it(@"can map alternative targets", ^{
                NSLog(@"HTML parsed: %@", ADMIN_HTML);
                stubRequest(@"GET", @"http://localhost/person")
                        .andReturn(200)
                        .withBody(ADMIN_HTML);

                WHLink *personLink = [WHLink linkWithPath:@"/person" target:[WHPerson class]];
                [personLink.alternativeTargets addObject:[WHAdmin class]];
                __block WHPerson *adminPerson = nil;

                [website send:personLink
                      success:^(WHHTTPRequest *request, id <WHObject> object) {
                          adminPerson = (WHPerson *) object;
                      }
                      failure:^(WHHTTPRequest *request, NSError *error) {
                          adminPerson = nil;
                      }];
                expect(adminPerson).willNot.beNil();
                expect(adminPerson).will.beInstanceOf([WHAdmin class]);
                expect(adminPerson.fullName).will.equal(@"John Doe");
                expect(adminPerson.age).will.equal(@25);
                expect(adminPerson.city).will.equal(@"Paris");
                expect(adminPerson.country).will.equal(@"France");

                WHAdmin *admin = (WHAdmin *) adminPerson;
                expect(admin.nickname).will.equal(@"The Administrator");
                expect(admin.rights).will.equal(WHAdminRightsWriteOnly);
            });

        });

    });

SpecEnd

















