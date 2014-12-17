//
// WHForm_HTMLSpec.m
// WebHere
//
// Created by Rui Lopes on 20/10/2014.
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

#import "WHLoginForm.h"
#import "WHPerson.h"

SpecBegin(WHForm_HTML)

    setAsyncSpecTimeout(2);

    describe(@"WHForm_HTML", ^{
        __block WHLoginForm *form;
        __block GDataXMLDocument *html;
        __block NSError *error;

        NSString *loginFormHTML =
            @"<form method=\"get\" action=\"/person\">\n"
             "<input type=\"hidden\" name=\"PHPSESSID\" "
             "value=\"a3KZ78u5U56MpOYY7Q0wm6vBV5dWeNEf\">"
             "<div id=\"userBox\">\n"
             "<input type=\"text\" name=\"user\" value=\"John Doe\" "
             "id=\"id_user\">\n"
             "<label for=\"id_user\">User</label>\n"
             "</div>\n"
             "<div id=\"passwordBox\">\n"
             "<input type=\"password\" name=\"password\" value=\"******\" "
             "id=\"id_password\">\n"
             "<label for=\"id_password\">Password</label>\n"
             "</div>\n"
             "<input type=\"checkbox\" name=\"admin\" id=\"id_admin\" "
             "value=\"1\">"
             "<label for=\"id_admin\">As admin</label>\n"
             "<input type=\"submit\" value=\"Login\" class=\"button\">\n"
             "</form>";

        afterEach(^{
            html = nil;
            error = nil;
            form = nil;
        });

        it(@"Maps a form node", ^{
            html = (GDataXMLDocument *)
                [[GDataXMLDocument alloc] initWithHTMLString:loginFormHTML
                                                       error:&error];
            expect(error).to.beNil();
            form = [WHLoginForm formWithHTML:html
                                     atXPath:@"//form"
                                 fromRequest:nil
                                      target:[WHPerson class]
                                       error:&error];
            expect(error).to.beNil();
            expect(form).toNot.beNil();
            expect(form.HTTPMethod).to.equal(@"GET");
            expect(form.user).to.equal(@"John Doe");
            expect(form.password).to.equal(@"******");
            expect([form.queryParameters allKeys])
                .to.containAll(
                    (@[ @"PHPSESSID", @"user", @"password", @"admin" ]));
            expect([form.queryParameters allValues])
                .to.containAll((@[
                  @"a3KZ78u5U56MpOYY7Q0wm6vBV5dWeNEf",
                  @"John Doe",
                  @"******",
                  @"1"
                ]));
        });

    });

SpecEnd
