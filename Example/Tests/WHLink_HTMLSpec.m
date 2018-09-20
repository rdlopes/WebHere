//
// WHLink_HTMLSpec.m
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

#import "WebHereTests.h"

#import "WHPerson.h"

SpecBegin(WHLink_HTML)

    setAsyncSpecTimeout(2);

    describe(@"WHLink_HTML", ^{
        __block WHLink *link;
        __block GDataXMLDocument *html;
        __block NSError *error;

        NSString *personAnchorWithAllAttributes =
            @"<html>\n"
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
        NSString *personAnchorWithTitle =
            @"<html>\n"
             "<body>\n"
             "<a href=\"/person\" title=\"title / John Doe\">"
             "</a>"
             "</body>\n"
             "</html>\n";
        NSString *personAnchorWithImgAltAndTitle =
            @"<html>\n"
             "<body>\n"
             "<a href=\"/person\" title=\"title / John Doe\">"
             "<img src=\"person/johndoe.jpg\" alt=\"alt / John Doe\">"
             "</a>"
             "</body>\n"
             "</html>\n";
        NSString *personAnchorWithImgAlt =
            @"<html>\n"
             "<body>\n"
             "<a href=\"/person\">"
             "<img src=\"person/johndoe.jpg\" alt=\"alt / John Doe\">"
             "</a>"
             "</body>\n"
             "</html>\n";

        afterEach(^{
            html = nil;
            error = nil;
            link = nil;
        });

        it(@"Maps link with anchor and image", ^{
            html = (GDataXMLDocument *)[[GDataXMLDocument alloc] initWithHTMLString:personAnchorWithAllAttributes error:&error];
            expect(error).to.beNil();

            link = [WHLink linkWithHTML:html atXPath:@"//a" fromRequest:nil target:[WHPerson class] error:&error];
            expect(error).to.beNil();
            expect(link).toNot.beNil();
            expect(link.label).to.equal(@"text / John Doe");
            expect(link.imagePath).to.equal(@"person/johndoe.jpg");
        });
        
        it(@"Maps link with naked anchor", ^{
            html = (GDataXMLDocument *)[[GDataXMLDocument alloc] initWithHTMLString:personAnchorWithText error:&error];
            expect(error).to.beNil();

            link = [WHLink linkWithHTML:html atXPath:@"//a" fromRequest:nil target:[WHPerson class] error:&error];
            expect(error).to.beNil();
            expect(link).toNot.beNil();
            expect(link.label).to.equal(@"text / John Doe");
            expect(link.imagePath).to.beNil();
        });
        
        it(@"Sets link label from text", ^{
            html = (GDataXMLDocument *) [[GDataXMLDocument alloc] initWithHTMLString:personAnchorWithText error:&error];
            expect(error).to.beNil();

            link = [WHLink linkWithHTML:html atXPath:@"//a" fromRequest:nil target:[WHPerson class] error:&error];
            expect(link).toNot.beNil();
            expect(link.label).to.equal(@"text / John Doe");
        });
        
        it(@"Sets link label from title", ^{
            html = (GDataXMLDocument *) [[GDataXMLDocument alloc] initWithHTMLString:personAnchorWithTitle error:&error];
            expect(error).to.beNil();

            link = [WHLink linkWithHTML:html atXPath:@"//a" fromRequest:nil target:[WHPerson class] error:&error];
            expect(link).toNot.beNil();
            expect(link.label).to.equal(@"title / John Doe");
        });
        
        it(@"Sets link label from img alt", ^{
            html = (GDataXMLDocument *) [[GDataXMLDocument alloc] initWithHTMLString:personAnchorWithImgAlt error:&error];
            expect(error).to.beNil();

            link = [WHLink linkWithHTML:html atXPath:@"//a" fromRequest:nil target:[WHPerson class] error:&error];
            expect(link).toNot.beNil();
            expect(link.label).to.equal(@"alt / John Doe");
        });
        
        it(@"Sets link label from text first", ^{
            html = (GDataXMLDocument *) [[GDataXMLDocument alloc] initWithHTMLString:personAnchorWithAllAttributes error:&error];
            expect(error).to.beNil();

            link = [WHLink linkWithHTML:html atXPath:@"//a" fromRequest:nil target:[WHPerson class] error:&error];
            expect(link).toNot.beNil();
            expect(link.label).to.equal(@"text / John Doe");
        });
        
        it(@"Sets link label from title first when no text", ^{
            html = (GDataXMLDocument *) [[GDataXMLDocument alloc] initWithHTMLString:personAnchorWithImgAltAndTitle error:&error];
            expect(error).to.beNil();

            link = [WHLink linkWithHTML:html atXPath:@"//a" fromRequest:nil target:[WHPerson class] error:&error];
            expect(link).toNot.beNil();
            expect(link.label).to.equal(@"title / John Doe");
        });
        
    });

SpecEnd
