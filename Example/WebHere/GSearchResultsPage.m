// GSearchResultsPage
//
// Created by Rui Lopes on 21/10/14.
// Copyright (c) 2014 Rui Lopes. All rights reserved.
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
// Copyright (c) 2014 Rui Lopes. All rights reserved.
//

#import <GDataXML-HTML/GDataXMLNode.h>
#import <WebHere/WHHTTPRequest.h>
#import <WebHere/WHHTTPRequest+HTML.h>
#import "GSearchResultsPage.h"

@interface GSearchResultsPage () {
  NSMutableArray *_searchResults;
}

@property(nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation GSearchResultsPage

@synthesize searchResults = _searchResults;

- (void)buildFromHTML:(GDataXMLDocument *)html
          fromRequest:(WHHTTPRequest *)request
                error:(NSError **)error {

  NSArray *searchResultsNodes =
      [html nodesForXPath:@"//div[@class='web_result']" error:error];

  if (!*error) {
    _searchResults = [@[] mutableCopy];

    for (GDataXMLNode *webResultNode in searchResultsNodes) {
      WHLink *searchResultLink =
          [WHLink linkWithNode:[webResultNode firstNodeForXPath:@"./div[1]/a"
                                                          error:error]
                   fromRequest:request
                        target:[NSObject class]
                         error:error];
      if (searchResultLink && !*error) {
        GDataXMLNode *descriptionNode =
            [webResultNode firstNodeForXPath:@"./div[2]" error:error];
        if (descriptionNode && !*error) {
          searchResultLink.userInfo[@"result.description"] =
              descriptionNode.stringValue;
        }
      }

      [_searchResults addObject:searchResultLink];
    }
  }
}

@end