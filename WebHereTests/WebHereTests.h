//
//  WebHereTests.h
//  WebHere
//
//  Created by Rui Lopes on 13/10/2014.
//  Copyright (c) 2014 Rui Lopes. All rights reserved.
//

#ifndef WebHere_WebHereTests_h
#define WebHere_WebHereTests_h

// Dependencies
#define EXP_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import "EXPMatchers+containAll.h"
#import <Nocilla/Nocilla.h>
#import "WebHere.h"

// Fixtures
#import "WHNSObject.h"
#import "WHPerson.h"
#import "WHPerson+HTML.h"
#import "WHLoginForm.h"
#import "WHPersonQueryForm.h"

// Global constants

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

#endif
