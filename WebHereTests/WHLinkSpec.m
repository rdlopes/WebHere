// WHLinkSpec.m
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

SPEC_BEGIN(WHLinkSpec)

#pragma mark - Initialization
describe(@"Initialization", ^{
    __block WHLink *link;

    beforeEach(^{
        link = [WHLink linkWithPath:@"/person" target:[WHPerson class]];
        link.label = @"Person";
        link.imagePath = @"/person.jpg";
    });

    afterEach(^{
        link = nil;
    });

    it(@"initializes", ^{
        [link shouldNotBeNil];
        [[link.label should] equal:@"Person"];
        [[link.imagePath should] equal:@"/person.jpg"];
    });

});

#pragma mark - Extraction
describe(@"Extraction", ^{
    __block WHLink *link;
    __block HTMLDocument *page;
    __block NSError *error;

    NSString *personAnchorWithAllAttributes = @"<html>\n"
            "<body>\n"
            "<a href=\"/person\" title=\"title / John Doe\">"
            "<img src=\"person/johndoe.jpg\" alt=\"alt / John Doe\">"
            "text / John Doe"
            "</a>"
            "</body>\n"
            "</html>\n";
    NSString *personAnchorWithText = @"<html>\n"
            "<body>\n"
            "<a href=\"/person\">"
            "text / John Doe"
            "</a>"
            "</body>\n"
            "</html>\n";
    NSString *personAnchorWithTitle = @"<html>\n"
            "<body>\n"
            "<a href=\"/person\" title=\"title / John Doe\">"
            "</a>"
            "</body>\n"
            "</html>\n";
    NSString *personAnchorWithImgAltAndTitle = @"<html>\n"
            "<body>\n"
            "<a href=\"/person\" title=\"title / John Doe\">"
            "<img src=\"person/johndoe.jpg\" alt=\"alt / John Doe\">"
            "</a>"
            "</body>\n"
            "</html>\n";
    NSString *personAnchorWithImgAlt = @"<html>\n"
            "<body>\n"
            "<a href=\"/person\">"
            "<img src=\"person/johndoe.jpg\" alt=\"alt / John Doe\">"
            "</a>"
            "</body>\n"
            "</html>\n";

    context(@"succeeds", ^{
        afterEach(^{
            page = nil;
            error = nil;
            link = nil;
        });

        it(@"with anchor with img", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:personAnchorWithAllAttributes error:&error];
            [error shouldBeNil];
            link = [WHLink linkForXPath:@"/a" inHTMLPage:page withTarget:[WHPerson class]];
            [link shouldNotBeNil];
            [[link.label should] equal:@"text / John Doe"];
            [[link.imagePath should] equal:@"person/johndoe.jpg"];
        });

        it(@"with naked anchor", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:personAnchorWithText error:&error];
            [error shouldBeNil];
            link = [WHLink linkForXPath:@"/a" inHTMLPage:page withTarget:[WHPerson class]];
            [link shouldNotBeNil];
            [[link.label should] equal:@"text / John Doe"];
            [link.imagePath shouldBeNil];
        });
    });

    context(@"fails", ^{
        afterEach(^{
            page = nil;
            error = nil;
            link = nil;
        });

        it(@"when node is not an anchor", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:personAnchorWithAllAttributes error:&error];
            [error shouldBeNil];
            link = [WHLink linkForXPath:@"." inHTMLPage:page withTarget:[WHPerson class]];
            [link shouldBeNil];
        });

        it(@"when xpath is nil", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:personAnchorWithAllAttributes error:&error];
            [error shouldBeNil];
            link = [WHLink linkForXPath:nil inHTMLPage:page withTarget:[WHPerson class]];
            [link shouldBeNil];
        });

        it(@"when xpath is empty", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:personAnchorWithAllAttributes error:&error];
            [error shouldBeNil];
            link = [WHLink linkForXPath:@"" inHTMLPage:page withTarget:[WHPerson class]];
            [link shouldBeNil];
        });
    });

    context(@"sets link label", ^{
        afterEach(^{
            page = nil;
            error = nil;
            link = nil;
        });

        it(@"from text", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:personAnchorWithText error:&error];
            [error shouldBeNil];
            link = [WHLink linkForXPath:@"/a" inHTMLPage:page withTarget:[WHPerson class]];
            [link shouldNotBeNil];
            [[link.label should] equal:@"text / John Doe"];
        });

        it(@"from title", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:personAnchorWithTitle error:&error];
            [error shouldBeNil];
            link = [WHLink linkForXPath:@"/a" inHTMLPage:page withTarget:[WHPerson class]];
            [link shouldNotBeNil];
            [[link.label should] equal:@"title / John Doe"];
        });

        it(@"from img alt", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:personAnchorWithImgAlt error:&error];
            [error shouldBeNil];
            link = [WHLink linkForXPath:@"/a" inHTMLPage:page withTarget:[WHPerson class]];
            [link shouldNotBeNil];
            [[link.label should] equal:@"alt / John Doe"];
        });

        it(@"from text first", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:personAnchorWithAllAttributes error:&error];
            [error shouldBeNil];
            link = [WHLink linkForXPath:@"/a" inHTMLPage:page withTarget:[WHPerson class]];
            [link shouldNotBeNil];
            [[link.label should] equal:@"text / John Doe"];
        });

        it(@"from title first when no text", ^{
            page = (HTMLDocument *) [HTMLDocument documentWithHTMLString:personAnchorWithImgAltAndTitle error:&error];
            [error shouldBeNil];
            link = [WHLink linkForXPath:@"/a" inHTMLPage:page withTarget:[WHPerson class]];
            [link shouldNotBeNil];
            [[link.label should] equal:@"title / John Doe"];
        });
    });
});

SPEC_END


