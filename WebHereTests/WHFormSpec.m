// WHFormSpec.m
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
#import "Kiwi.h"

SPEC_BEGIN(WHFormSpec)

#pragma mark - Initialization
describe(@"Initialization", ^{
    __block WHForm *form;

    beforeEach(^{
        form = [WHForm formWithPath:@"/" target:[WHPerson class]];
    });

    afterEach(^{
        form = nil;
    });

    it(@"initializes", ^{
        [form shouldNotBeNil];
    });
});

#pragma mark - Runtime
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
        [form shouldNotBeNil];
        [[form.user should] equal:@"me"];
        [[form.password should] equal:@"secret"];
        [[[form.queryParameters allKeys] should] containObjectsInArray:@[@"user",@"password"]];
        [[[form.queryParameters allValues] should] containObjectsInArray:@[@"me",@"secret"]];
    });
});

#pragma mark - Extraction
describe(@"Extraction", ^{
    __block WHLoginForm *form;
    __block HTMLDocument *page;
    __block NSError *error;

    NSString *loginFormHTML = @"<form method=\"get\" action=\"/person\">\n"
            "<input type=\"hidden\" name=\"PHPSESSID\" value=\"a3KZ78u5U56MpOYY7Q0wm6vBV5dWeNEf\">"
            "<div id=\"userBox\">\n"
            "<input type=\"text\" name=\"user\" value=\"John Doe\" id=\"id_user\">\n"
            "<label for=\"id_user\">User</label>\n"
            "</div>\n"
            "<div id=\"passwordBox\">\n"
            "<input type=\"password\" name=\"password\" value=\"******\" id=\"id_password\">\n"
            "<label for=\"id_password\">Password</label>\n"
            "</div>\n"
            "<input type=\"checkbox\" name=\"admin\" id=\"id_admin\" value=\"1\">"
            "<label for=\"id_admin\">As admin</label>\n"
            "<input type=\"submit\" value=\"Login\" class=\"button\">\n"
            "</form>";

    context(@"succeeds", ^{
        afterEach(^{
            page = nil;
            error = nil;
            form = nil;
        });

        it(@"with form node", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:loginFormHTML error:&error];
            [error shouldBeNil];
            form = (WHLoginForm *) [WHLoginForm formForXPath:@"/form" inHTMLPage:page withTarget:[WHPerson class]];
            [form shouldNotBeNil];
            [[form.HTTPMethod should] equal:@"GET"];
            [[form.user should] equal:@"John Doe"];
            [[form.password should] equal:@"******"];
            [[[form.queryParameters allKeys] should] containObjectsInArray:@[@"PHPSESSID",@"user",@"password",@"admin"]];
            [[[form.queryParameters allValues] should] containObjectsInArray:@[@"a3KZ78u5U56MpOYY7Q0wm6vBV5dWeNEf",@"John Doe",@"******",@"1"]];
        });
    });

    context(@"fails", ^{
        afterEach(^{
            page = nil;
            error = nil;
            form = nil;
        });

        it(@"when node is not a form", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:loginFormHTML error:&error];
            [error shouldBeNil];
            form = (WHLoginForm *) [WHLoginForm formForXPath:@"." inHTMLPage:page withTarget:[WHPerson class]];
            [form shouldBeNil];
        });

        it(@"when xpath is nil", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:loginFormHTML error:&error];
            [error shouldBeNil];
            form = (WHLoginForm *) [WHLoginForm formForXPath:nil inHTMLPage:page withTarget:[WHPerson class]];
            [form shouldBeNil];
        });

        it(@"when xpath is empty", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:loginFormHTML error:&error];
            [error shouldBeNil];
            form = (WHLoginForm *) [WHLoginForm formForXPath:@"" inHTMLPage:page withTarget:[WHPerson class]];
            [form shouldBeNil];
        });
    });
});

SPEC_END


