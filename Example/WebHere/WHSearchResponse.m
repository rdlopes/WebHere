//
//  WHSearchResponse.m
//  WebHere
//
//  Created by Rui Lopes on 28/12/2014.
//  Copyright (c) 2014 Rui Lopes. All rights reserved.
//

#import "WHSearchResponse.h"
#import "WHSearchResult.h"

@interface WHSearchResponse () <WHObject>
@end

@implementation WHSearchResponse

- (instancetype)init {
    self = [super init];
    if (self) {
        _searchResults = [@[] mutableCopy];
    }

    return self;
}


- (void)buildFromHTML:(GDataXMLDocument *)html fromRequest:(WHHTTPRequest *)request error:(NSError **)error {
    NSArray *webResults = [html nodesForXPath:@"//div[@id='ires']//div[@class='g']" error:error];

    for (GDataXMLNode *webResultNode in webResults) {

        GDataXMLNode *linkNode = [webResultNode firstNodeForXPath:@".//h3/a" error:error];
        GDataXMLNode *detailsNode = [webResultNode firstNodeForXPath:@".//div[@class='s']/span" error:error];


        WHSearchResult *searchResult = [[WHSearchResult alloc] initWithNode:linkNode
                                                                fromRequest:request
                                                                      error:error];

        searchResult.details = [detailsNode.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        [self.searchResults addObject:searchResult];
    }
}

@end
