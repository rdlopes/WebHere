// WHPerson.h
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
//

#import <Foundation/Foundation.h>

static NSString *const PERSON_HTML =
        @"<html>\n"
                "<head>\n<title>John Doe</title>\n</head>\n"
                "<body>\n"
                "<div id=\"age\">25</div>\n"
                "<div id=\"city\">Paris</div>\n"
                "<div id=\"country\">France</div>\n"
                "</body>\n</html>";

static NSString *const ADMIN_HTML =
        @"<html>\n"
                "<head>\n<title>John Doe</title>\n</head>\n"
                "<body>\n"
                "<div id=\"age\">25</div>\n"
                "<div id=\"city\">Paris</div>\n"
                "<div id=\"country\">France</div>\n"
                "<div id=\"nickname\">The Administrator</div>\n"
                "<div id=\"rights\">WriteOnly</div>\n"
                "</body>\n"
                "</html>";

@interface WHPerson : NSObject

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;

@end

@interface WHUnmatchedPerson : WHPerson

@end

typedef enum WHAdminRights {
    WHAdminRightsReadWrite,
    WHAdminRightsWriteOnly,
    WHAdminRightsUnknown
} WHAdminRights;

@interface WHAdmin : WHPerson

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, assign) WHAdminRights rights;

@end
