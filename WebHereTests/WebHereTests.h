//
//  WebHereTests.h
//  WebHereTests
//
//  Created by Rui D Lopes on 25/03/13.
//  Copyright (c) 2013 Rui D Lopes. All rights reserved.
//

#ifndef LOGGING_LEVEL_TRACE
#	define LOGGING_LEVEL_TRACE		0
#endif
#ifndef LOGGING_LEVEL_INFO
#	define LOGGING_LEVEL_INFO		1
#endif
#ifndef LOGGING_LEVEL_ERROR
#	define LOGGING_LEVEL_ERROR		1
#endif
#ifndef LOGGING_LEVEL_DEBUG
#	define LOGGING_LEVEL_DEBUG		0
#endif

#import <SenTestingKit/SenTestingKit.h>
#import <Kiwi/Kiwi.h>
#import <Nocilla/Nocilla.h>
#import <OCLogTemplate/OCLogTemplate.h>
#import <WebHere/WebHere.h>

// Fixtures
#import "WHPerson.h"
#import "WHAdmin.h"
#import "WHUnmatchedPerson.h"
#import "WHPersonQueryForm.h"
#import "WHNSObject.h"
#import "WHLoginForm.h"

