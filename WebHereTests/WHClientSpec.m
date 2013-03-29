// WHClientSpec.m
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

SPEC_BEGIN(WHClientSpec)

__block WHClient *client;

NSURL *baseURL = [NSURL URLWithString:@"http://localhost"];

NSString *personHTML = @"<html>\n"
"<head>\n"
"<title>John Doe</title>\n"
"</head>\n"
"<body>\n"
"<div id=\"age\">25</div>\n"
"<div id=\"city\">Paris</div>\n"
"<div id=\"country\">France</div>\n"
"</body>\n"
"</html>";

NSString *adminHTML = @"<html>\n"
"<head>\n"
"<title>The Administrator</title>\n"
"</head>\n"
"<body>\n"
"<div id=\"rights\">WriteOnly</div>\n"
"</body>\n"
"</html>";

#pragma mark - Initialization
describe(@"Initialization", ^{

    beforeEach(^{
        client = [WHClient clientWithBaseURL:baseURL];
    });
    
    afterEach(^{
        client = nil;
        [WHClient setSharedClient:nil];
    });
    
    context(@"succeeds", ^{
        
        it(@"with one client", ^{
            [client shouldNotBeNil];
            [[client.baseURL should] equal:baseURL];
            [[theValue(client.numberOfRetries) should] equal:theValue(kWHClientDefaultNumberOfRetries)];
            [[theValue(client.timeoutInterval) should] equal:theValue(kWHClientDefaultTimeoutInterval)];
        });
        
        it(@"with the shared client", ^{
            [[client should] equal:[WHClient sharedClient]];
        });
        
        it(@"with two clients", ^{
            WHClient *anotherClient = [WHClient clientWithBaseURL:baseURL];
            [anotherClient shouldNotBeNil];
            [[anotherClient shouldNot] equal:client];
            [[[WHClient sharedClient] should] equal:client];
        });
    });
    
    context(@"fails", ^{
        
        it(@"without base URL", ^{
            [[theBlock(^{
                [WHClient clientWithBaseURL:nil];
            }) should] raiseWithName:@"NSInternalInconsistencyException"];
        });
    });
});

#pragma mark - Requests
describe(@"Requests", ^{
    
    beforeEach(^{
        client = [WHClient clientWithBaseURL:baseURL];
    });
    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });
    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
        client = nil;
        [WHClient setSharedClient:nil];
    });
    
    it(@"can map alternative targets", ^{
        stubRequest(@"GET", @"http://localhost/person")
        .andReturn(200)
        .withBody(adminHTML);
        
        WHLink *personLink = [WHLink linkWithPath:@"/person" target:[WHPerson class]];
        [personLink.alternativeTargetClasses addObject:[WHAdmin class]];
        __block WHAdmin *admin = nil;
        
        [[WHClient sharedClient] send:personLink
                              success:^(WHRequest *request, id <WHObject> object) {
                                  [[(NSObject *)object should] beMemberOfClass:[WHAdmin class]];
                                  admin = (WHAdmin *) object;
                                  [[admin.nickname should] equal:@"The Administrator"];
                                  [[theValue(admin.rights) should] equal:theValue(WHAdminRightsWriteOnly)];
                              }
                              failure:^(WHRequest *request, NSError *error) {
                                  LogError(@"Error sending request %@:%@",request,error);
                              }];
        [[expectFutureValue(admin) shouldEventually] beNonNil];
    });
    
    it(@"won't map unnmatching targets", ^{
        stubRequest(@"GET", @"http://localhost/person")
        .andReturn(200)
        .withBody(personHTML);
        
        WHLink *personLink = [WHLink linkWithPath:@"/person" target:[WHUnmatchedPerson class]];
        [personLink.alternativeTargetClasses addObject:[WHAdmin class]]; // with an alternative target
        __block WHUnmatchedPerson *person = [[WHUnmatchedPerson alloc] init];
        
        [[WHClient sharedClient] send:personLink
                              success:^(WHRequest *request, id <WHObject> object) {
                                  person = (WHUnmatchedPerson *) object;
                              }
                              failure:^(WHRequest *request, NSError *error) {
                                  person = nil;
                                  LogError(@"Error sending request %@:%@",request,error);
                              }];
        [[expectFutureValue(person) shouldEventually] beNil];
    });
    
    it(@"retries on error", ^{
        stubRequest(@"GET", @"http://localhost/person")
        .andReturn(404);
        
        WHLink *personLink = [WHLink linkWithPath:@"/person" target:[WHPerson class]];
        __block WHPerson *person = [[WHPerson alloc] init];
        
        [[[WHClient sharedClient] should] receive:@selector(send:success:failure:)
                                        withCount:2];
        [[WHClient sharedClient] send:personLink
                              success:^(WHRequest *request, id <WHObject> object) {
                                  person = (WHPerson *) object;
                              }
                              failure:^(WHRequest *request, NSError *error) {
                                  person = nil;
                                  LogError(@"Error sending request %@:%@",request,error);
                              }];
        [[expectFutureValue(person) shouldEventually] beNil];
    });
    
});

#pragma mark - GET Requests
describe(@"GET Requests", ^{
    
    beforeEach(^{
        client = [WHClient clientWithBaseURL:baseURL];
    });
    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });
    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
        client = nil;
        [WHClient setSharedClient:nil];
    });
    
    it(@"with naked link", ^{
        stubRequest(@"GET", @"http://localhost/person")
        .andReturn(200)
        .withBody(personHTML);
        
        WHLink *personLink = [WHLink linkWithPath:@"/person" target:[WHPerson class]];
        __block WHPerson *person = nil;
        
        [[WHClient sharedClient] send:personLink
                              success:^(WHRequest *request, id <WHObject> object) {
                                  person = (WHPerson *) object;
                                  [[person.fullName should] equal:@"John Doe"];
                                  [[theValue(person.age) should] equal:@25];
                                  [[person.city should] equal:@"Paris"];
                                  [[person.country should] equal:@"France"];
                              }
                              failure:^(WHRequest *request, NSError *error) {
                                  LogError(@"Error sending request %@:%@",request,error);
                              }];
        [[expectFutureValue(person) shouldEventually] beNonNil];
    });
    
    it(@"with URL parameters", ^{
        stubRequest(@"GET", @"http://localhost/person/query?fullName=John%20Doe")
        .andReturn(200)
        .withBody(personHTML);
        
        WHLink *personQueryLink = [WHLink linkWithPath:@"/person/query" target:[WHPerson class]];
        personQueryLink.queryParameters[@"fullName"] = @"John Doe";
        __block WHPerson *person = nil;
        
        [[WHClient sharedClient] send:personQueryLink
                              success:^(WHRequest *request, id <WHObject> object) {
                                  person = (WHPerson *) object;
                                  [[person.fullName should] equal:@"John Doe"];
                                  [[theValue(person.age) should] equal:@25];
                                  [[person.city should] equal:@"Paris"];
                                  [[person.country should] equal:@"France"];
                              }
                              failure:^(WHRequest *request, NSError *error) {
                                  LogError(@"Error sending request %@:%@",request,error);
                              }];
        [[expectFutureValue(person) shouldEventually] beNonNil];
    });
    
});

#pragma mark - POST Requests
describe(@"POST Requests", ^{
    
    beforeEach(^{
        client = [WHClient clientWithBaseURL:baseURL];
    });
    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });
    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
        client = nil;
        [WHClient setSharedClient:nil];
    });
    
    it(@"with explicit query parameters", ^{
        stubRequest(@"POST", @"http://localhost/person/query")
        .withBody(@"fullName=John%20Doe")
        .andReturn(200)
        .withBody(personHTML);
        
        WHForm *personQueryForm = [WHForm formWithPath:@"/person/query" target:[WHPerson class]];
        personQueryForm.queryParameters[@"fullName"] = @"John Doe";
        __block WHPerson *person = nil;
        
        [[WHClient sharedClient] send:personQueryForm
                              success:^(WHRequest *request, id <WHObject> object) {
                                  person = (WHPerson *) object;
                                  [[person.fullName should] equal:@"John Doe"];
                                  [[theValue(person.age) should] equal:@25];
                                  [[person.city should] equal:@"Paris"];
                                  [[person.country should] equal:@"France"];
                              }
                              failure:^(WHRequest *request, NSError *error) {
                                  LogError(@"Error sending request %@:%@",request,error);
                              }];
        [[expectFutureValue(person) shouldEventually] beNonNil];
    });
    
    it(@"with query parameters as form properties", ^{
        stubRequest(@"POST", @"http://localhost/person/query")
        .withBody(@"fullName=John%20Doe")
        .andReturn(200)
        .withBody(personHTML);
        
        WHPersonQueryForm *personQueryForm = [WHPersonQueryForm formWithPath:@"/person/query" target:[WHPerson class]];
        personQueryForm.fullName = @"John Doe";
        __block WHPerson *person = nil;
        
        [[WHClient sharedClient] send:personQueryForm
                              success:^(WHRequest *request, id <WHObject> object) {
                                  person = (WHPerson *) object;
                                  [[person.fullName should] equal:@"John Doe"];
                                  [[theValue(person.age) should] equal:@25];
                                  [[person.city should] equal:@"Paris"];
                                  [[person.country should] equal:@"France"];
                              }
                              failure:^(WHRequest *request, NSError *error) {
                                  LogError(@"Error sending request %@:%@",request,error);
                              }];
        [[expectFutureValue(person) shouldEventually] beNonNil];
    });

});

SPEC_END


